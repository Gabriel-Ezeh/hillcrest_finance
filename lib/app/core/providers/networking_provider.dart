import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hillcrest_finance/app/core/network/auth_interceptor.dart';
import 'package:hillcrest_finance/features/authentication/data/sources/auth_api_client.dart';
import 'package:hillcrest_finance/features/authentication/data/sources/onboarding_api_client.dart';
import 'package:hillcrest_finance/features/authentication/data/sources/otp_api_client.dart';
import 'package:hillcrest_finance/features/authentication/data/repositories/auth_repository.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'networking_provider.g.dart';

// --- CORE NETWORKING COMPONENTS ---

@riverpod
FlutterSecureStorage secureStorage(Ref ref) {
  return const FlutterSecureStorage();
}

@riverpod
Dio authDio(Ref ref) {
  final dio = Dio(BaseOptions(baseUrl: dotenv.env['KEYCLOAK_BASE_URL']!));
  if (kDebugMode) {
    dio.interceptors.add(PrettyDioLogger(requestHeader: true, requestBody: true, responseBody: true, error: true, compact: true));
  }
  return dio;
}

@riverpod
Dio onboardingDio(Ref ref) {
  final dio = Dio(BaseOptions(
    baseUrl: dotenv.env['ISSL_API_DOMAIN']!,
    headers: {
      'Accept': '*/*', // MODIFIED: Force the Accept header here for all requests
    },
  ));
  if (kDebugMode) {
    dio.interceptors.add(PrettyDioLogger(requestHeader: true, requestBody: true, responseBody: true, error: true, compact: true));
  }
  return dio;
}

@riverpod
Dio dio(Ref ref) {
  final dio = ref.watch(authDioProvider);
  final newDio = Dio(dio.options);
  newDio.interceptors.addAll(dio.interceptors);
  newDio.interceptors.add(AuthInterceptor(ref));
  return newDio;
}

// --- API CLIENT PROVIDERS ---

@riverpod
AuthApiClient authApiClient(Ref ref) {
  return AuthApiClient(ref.watch(authDioProvider));
}

@riverpod
OnboardingApiClient onboardingApiClient(Ref ref) {
  return OnboardingApiClient(ref.watch(onboardingDioProvider));
}

@riverpod
OtpApiClient otpApiClient(Ref ref) {
  return OtpApiClient(ref.watch(onboardingDioProvider));
}


// --- REPOSITORY PROVIDER ---

@riverpod
AuthRepository authRepository(Ref ref) {
  return AuthRepository(
    authApiClient: ref.watch(authApiClientProvider),
    onboardingApiClient: ref.watch(onboardingApiClientProvider),
    otpApiClient: ref.watch(otpApiClientProvider),
    secureStorage: ref.watch(secureStorageProvider),
    ref: ref,
  );
}
