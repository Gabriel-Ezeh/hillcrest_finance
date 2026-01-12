import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hillcrest_finance/app/core/exceptions/network_exceptions.dart';
import 'package:hillcrest_finance/features/authentication/data/models/keycloak_user.dart';
import 'package:hillcrest_finance/features/authentication/data/models/otp_request.dart';
import 'package:hillcrest_finance/features/authentication/data/models/send_email_request.dart';
import 'package:hillcrest_finance/features/authentication/data/models/sign_up_request.dart';
import 'package:hillcrest_finance/features/authentication/data/models/token_response.dart';
import 'package:hillcrest_finance/features/authentication/data/sources/auth_api_client.dart';
import 'package:hillcrest_finance/features/authentication/data/sources/onboarding_api_client.dart';
import 'package:hillcrest_finance/features/authentication/data/sources/otp_api_client.dart';
import 'package:hillcrest_finance/features/authentication/presentation/providers/signup_data_provider.dart';
import 'package:hillcrest_finance/utils/constants/api_constants.dart';

import '../../../../app/core/providers/networking_provider.dart';

class AuthRepository {
  final AuthApiClient _authApiClient;
  final OnboardingApiClient _onboardingApiClient;
  final OtpApiClient _otpApiClient;
  final FlutterSecureStorage _secureStorage;
  final Ref _ref;

  AuthRepository({
    required AuthApiClient authApiClient,
    required OnboardingApiClient onboardingApiClient,
    required OtpApiClient otpApiClient,
    required FlutterSecureStorage secureStorage,
    required Ref ref,
  })  : _authApiClient = authApiClient,
        _onboardingApiClient = onboardingApiClient,
        _otpApiClient = otpApiClient,
        _secureStorage = secureStorage,
        _ref = ref;

  // --- Keys ---
  static const _kAccessToken = "ACCESS_TOKEN";
  static const _kRefreshToken = "REFRESH_TOKEN";

  // --- Full Sign-Up Flow ---

  Future<void> checkIfUserExists({required String email}) async {
    // ... (logic remains the same)
  }

  Future<void> sendEmailOtp(String email) async {
    try {
      final tenantId = dotenv.env['xTenantId']!;

      // Step 1: Generate the OTP
      final otp = await _otpApiClient.generateEmailOtp(
        tenantId: tenantId,
        email: email,
      );

      // Step 2: Send email with OTP
      final sendEmailRequest = SendEmailRequest(
        attachments: [{}],
        body: "Good day,\n\nThis is your One-time password for your online profile creation with CandourCrest Finance.\n\nPin: $otp",
        from: "customerservice@candourcrest.com",
        subject: "OTP Verification",
        to: email,
      );

      await _otpApiClient.sendEmail(
        tenantId: tenantId,
        body: sendEmailRequest,
      );

    } on DioException catch (e) {
      if (e.response != null && e.response!.statusCode! >= 400) {
        throw ClientException(message: 'Failed to send email OTP. Please check the address and try again.');
      }
      throw ServerException();
    } catch (e) {
      throw UnexpectedException();
    }
  }


  Future<void> verifyEmailOtp(String email, String otp) async {
    // ... (logic remains the same)
  }

  Future<void> sendSmsOtp(String phoneNumber) async {
    try {
      final tenantId = dotenv.env['xTenantId']!;

      // Step 1: Generate the OTP
      final otp = await _otpApiClient.generateEmailOtp(
        tenantId: tenantId,
        email: phoneNumber,
      );

      // Step 2: Send SMS with OTP
      await _otpApiClient.sendSmsOtp(
        tenantId: tenantId,
        message: "Good day,\n\nThis is your One-time password for your online profile creation with CandourCrest Finance.\n\nPin: $otp",
        phoneNumber: phoneNumber,
      );

    } on DioException catch (e) {
      if (e.response != null && e.response!.statusCode! >= 400) {
        throw ClientException(message: 'Failed to send SMS OTP. Please check the phone number and try again.');
      }
      throw ServerException();
    } catch (e) {
      throw UnexpectedException();
    }
  }


  Future<void> verifySmsOtp(String phoneNumber, String otp) async {
    // ... (logic remains the same)
  }

  Future<void> createKeycloakUser() async {
    // ... (logic remains the same)
  }

  // --- Standard Auth Methods ---

  Future<bool> isSignedIn() async {
    final token = await getAccessToken();
    return token != null && token.isNotEmpty;
  }


  Future<TokenResponse> login(String username, String password) async {
    try {
      final response = await _authApiClient.login(
        realm: dotenv.env['CC_REALM']!,
        grantType: "password",
        clientId: dotenv.env['CC_CLIENT_ID']!,
        clientSecret: dotenv.env['CC_CLIENT_SECRET']!,
        username: username,
        password: password,
      );
      await _saveTokens(response);
      return response;
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout) throw TimeoutException();
      if (e.response?.statusCode == 401) throw InvalidCredentialsException();
      throw ServerException();
    } catch (e) {
      throw UnexpectedException();
    }
  }

  Future<TokenResponse?> refreshToken() async {
    try {
      final refreshToken = await getRefreshToken();
      if (refreshToken == null) return null;
      final response = await _authApiClient.refreshToken(
        realm: dotenv.env['CC_REALM']!,
        grantType: "refresh_token",
        clientId: dotenv.env['CC_CLIENT_ID']!,
        clientSecret: dotenv.env['CC_CLIENT_SECRET']!,
        refreshToken: refreshToken,
      );
      await _saveTokens(response);
      return response;
    } catch (_) {
      return null; // refresh failed
    }
  }

  Future<void> logout() async {
    try {
      final refreshToken = await getRefreshToken();
      if (refreshToken != null) {
        await _authApiClient.logout(
          realm: dotenv.env['CC_REALM']!,
          clientId: dotenv.env['CC_CLIENT_ID']!,
          clientSecret: dotenv.env['CC_CLIENT_SECRET']!,
          refreshToken: refreshToken,
        );
      }
    } catch (_) {}
    await _secureStorage.deleteAll();
  }

  // --- Helper Methods ---

  Future<String?> getAccessToken() => _secureStorage.read(key: _kAccessToken);
  Future<String?> getRefreshToken() => _secureStorage.read(key: _kRefreshToken);

  Future<void> _saveTokens(TokenResponse response) async {
    await _secureStorage.write(key: _kAccessToken, value: response.accessToken);
    if (response.refreshToken != null) {
      await _secureStorage.write(key: _kRefreshToken, value: response.refreshToken!);
    }
  }

  Future<String> _getAdminAuthToken() async {
    try {
      final dio = _ref.read(authDioProvider);
      final response = await dio.post(
        '/auth/realms/${dotenv.env['CC_REALM']}/protocol/openid-connect/token',
        data: {
          'grant_type': 'client_credentials',
          'client_id': dotenv.env['CC_ADMIN_CLIENT_ID'],
          'client_secret': dotenv.env['ADMIN_CLIENT_SECRET'],
        },
        options: Options(contentType: Headers.formUrlEncodedContentType),
      );
      final tokenResponse = TokenResponse.fromJson(response.data);
      return tokenResponse.accessToken;
    } on DioException {
      throw ServerException(message: 'Failed to authenticate for an administrative task.');
    } catch (_) {
      throw UnexpectedException();
    }
  }
}

  // ... (rest of the file remains the same)

