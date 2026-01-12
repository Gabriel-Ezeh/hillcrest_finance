import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hillcrest_finance/app/core/providers/networking_provider.dart';
import 'package:hillcrest_finance/features/authentication/data/models/token_response.dart';
import 'package:hillcrest_finance/features/authentication/data/sources/auth_api_client.dart';

class AuthInterceptor extends Interceptor {
  final Ref ref;

  AuthInterceptor(this.ref);

  static const _kAccessToken = "ACCESS_TOKEN";
  static const _kRefreshToken = "REFRESH_TOKEN";

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Do not add the auth token to the login/refresh requests themselves
    if (options.path.contains('token')) {
      return handler.next(options);
    }

    final storage = ref.read(secureStorageProvider);
    final token = await storage.read(key: _kAccessToken);

    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    return handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (err.response?.statusCode != 401) {
      return handler.next(err);
    }

    try {
      final newTokens = await _performTokenRefresh();
      if (newTokens == null) {
        // If we can't get a new token, we can't recover. Pass the error along.
        return handler.next(err);
      }

      // Save new tokens
      final storage = ref.read(secureStorageProvider);
      await storage.write(key: _kAccessToken, value: newTokens.accessToken);
      await storage.write(key: _kRefreshToken, value: newTokens.refreshToken);

      // Retry the original failed request with the new token
      final response = await _retry(err.requestOptions, newTokens.accessToken);
      return handler.resolve(response);
    } catch (e) {
      // THIS IS THE FIX: If refresh fails, do NOT call logout().
      // Just pass the original error along. The UI layer is responsible
      // for catching this final failure and triggering a logout.
      // This breaks the circular dependency.
      return handler.next(err);
    }
  }

  Future<TokenResponse?> _performTokenRefresh() async {
    final storage = ref.read(secureStorageProvider);
    final refreshToken = await storage.read(key: _kRefreshToken);

    if (refreshToken == null) return null;

    // Use a separate, clean Dio instance to avoid the interceptor loop.
    final refreshDio = Dio();
    final baseUrl = dotenv.env['KEYCLOAK_BASE_URL']!;
    final apiClient = AuthApiClient(refreshDio, baseUrl: baseUrl);

    return apiClient.refreshToken(
      realm: dotenv.env['CC_REALM']!,
      grantType: "refresh_token",
      clientId: dotenv.env['CC_CLIENT_ID']!,
      clientSecret: dotenv.env['CC_CLIENT_SECRET']!,
      refreshToken: refreshToken,
    );
  }

  Future<Response> _retry(RequestOptions requestOptions, String newAccessToken) async {
    // We must use a new Dio instance to avoid re-triggering the interceptor on the same request.
    final retryDio = Dio(BaseOptions(
      baseUrl: requestOptions.baseUrl,
      headers: requestOptions.headers..['Authorization'] = 'Bearer $newAccessToken',
    ));

    return retryDio.request<dynamic>(
      requestOptions.path,
      data: requestOptions.data,
      queryParameters: requestOptions.queryParameters,
      options: Options(method: requestOptions.method, headers: requestOptions.headers),
    );
  }
}
