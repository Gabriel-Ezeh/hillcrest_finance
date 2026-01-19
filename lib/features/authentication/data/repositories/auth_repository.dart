import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hillcrest_finance/app/core/exceptions/network_exceptions.dart';
import 'package:hillcrest_finance/app/core/storage/user_local_storage.dart';
import 'package:hillcrest_finance/features/authentication/data/models/keycloak_user.dart';
import 'package:hillcrest_finance/features/authentication/data/models/send_email_request.dart';
import 'package:hillcrest_finance/features/authentication/data/models/sign_up_request.dart';
import 'package:hillcrest_finance/features/authentication/data/models/token_response.dart';
import 'package:hillcrest_finance/features/authentication/data/sources/auth_api_client.dart';
import 'package:hillcrest_finance/features/authentication/data/sources/otp_api_client.dart';
import 'package:hillcrest_finance/features/authentication/presentation/providers/signup_data_provider.dart';

import '../../../../app/core/providers/networking_provider.dart';

class AuthRepository {
  final AuthApiClient _authApiClient;
  final OtpApiClient _otpApiClient;
  final FlutterSecureStorage _secureStorage;
  final UserLocalStorage _userLocalStorage;
  final Ref _ref;

  AuthRepository({
    required AuthApiClient authApiClient,
    required OtpApiClient otpApiClient,
    required FlutterSecureStorage secureStorage,
    required UserLocalStorage userLocalStorage,
    required Ref ref,
  })  : _authApiClient = authApiClient,
        _otpApiClient = otpApiClient,
        _secureStorage = secureStorage,
        _userLocalStorage = userLocalStorage,
        _ref = ref;

  // --- Keys ---
  static const _kAccessToken = "ACCESS_TOKEN";
  static const _kRefreshToken = "REFRESH_TOKEN";

  // --- Full Sign-Up Flow ---

  Future<void> checkIfUserExists({required String email, required String phoneNumber}) async {
    try {
      final realm = dotenv.env['CC_REALM']!;
      final adminToken = await _getAdminAuthToken();
      final bearerAdminToken = 'Bearer $adminToken';

      // Check for existing email
      var existingUsers = await _authApiClient.getUsers(
        realm: realm,
        email: email,
        adminToken: bearerAdminToken,
      );
      if (existingUsers.isNotEmpty) {
        throw EmailAlreadyExistsException();
      }

      // Check for existing phone number with pagination
      const int pageSize = 100;
      int page = 0;
      bool phoneFound = false;

      while (!phoneFound) {
        final users = await _authApiClient.getUsers(
          realm: realm,
          adminToken: bearerAdminToken,
          first: page * pageSize,
          max: pageSize,
        );

        if (users.isEmpty) break;

        // Check if any user has the phone number
        phoneFound = users.any((user) {
          final phoneAttr = user.attributes?['phoneNumber'];

          // Handle both List and String types
          if (phoneAttr is List) {
            return phoneAttr.contains(phoneNumber);
          } else if (phoneAttr is String) {
            return phoneAttr == phoneNumber;
          }
          return false;
        });

        if (phoneFound) {
          throw PhoneNumberAlreadyExistsException();
        }

        // If we got fewer results than pageSize, we've reached the end
        if (users.length < pageSize) break;

        page++;
      }

    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout) throw TimeoutException();
      throw ServerException();
    } catch (e) {
      if (e is NetworkException) rethrow;
      throw UnexpectedException();
    }
  }


  // In lib/features/authentication/data/repositories/auth_repository.dart

  Future<void> sendEmailOtp(String email) async {
    try {
      final tenantId = dotenv.env['xTenantId']!;

      // Step 1: Generate OTP
      print('Generating OTP for email: $email');
      final otp = await _otpApiClient.generateEmailOtp(
        tenantId: tenantId,
        email: email,
      );
      print('OTP generated successfully: $otp');

      // Step 2: Prepare email request (remove empty object from attachments)
      final emailRequest = SendEmailRequest(
        attachments: [], // Changed from [{}] to []
        body: "Good day,\n\nThis is your One-time password for your online profile creation with CandourCrest Finance.\n\nPin: $otp",
        from: "customerservice@candourcrest.com",
        subject: "OTP Verification",
        to: email,
      );

      print('Sending email to: $email');

      // Step 3: Send email
      final response = await _otpApiClient.sendEmail(
        tenantId: tenantId,
        body: emailRequest,
      );

      print('Email API Response Status: ${response.response.statusCode}');
      print('Email API Response Data: ${response.data}');

      // Check if the response indicates success
      if (response.response.statusCode == 200 || response.response.statusCode == 201) {
        print('Email sent successfully');
      } else {
        print('Unexpected status code: ${response.response.statusCode}');
        throw ClientException(
          message: 'Email service returned an unexpected response. Please try again.',
        );
      }

    } on DioException catch (e) {
      print('DioException occurred:');
      print('Type: ${e.type}');
      print('Message: ${e.message}');
      print('Response Data: ${e.response?.data}');
      print('Status Code: ${e.response?.statusCode}');
      print('Error: ${e.error}');

      // More specific error messages based on error type
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.sendTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw ClientException(
          message: 'Connection timeout. Please check your internet connection and try again.',
        );
      } else if (e.type == DioExceptionType.badResponse) {
        final statusCode = e.response?.statusCode;
        if (statusCode == 400) {
          throw ClientException(
            message: 'Invalid email request. Please verify the email address.',
          );
        } else if (statusCode == 401 || statusCode == 403) {
          throw ClientException(
            message: 'Authentication failed. Please contact support.',
          );
        } else if (statusCode == 500) {
          throw ClientException(
            message: 'Server error. The email service is currently unavailable.',
          );
        }
      }

      throw ClientException(
        message: 'Failed to send email OTP. Please check the address and try again.',
      );

    } catch (e) {
      print('Unexpected error: $e');
      throw UnexpectedException();
    }
  }


  Future<void> verifyEmailOtp(String email, String otp) async {
    // try {
    //   final tenantId = dotenv.env['xTenantId']!;
    //   final adminToken = await _getAdminAuthToken();
    //
    //   await _otpApiClient.validateOtp(
    //     tenantId: tenantId,
    //     authorization: 'Bearer $adminToken',
    //     userId: email,
    //     otp: otp,
    //   );
    // } on DioException catch (e) {
    //   if (e.response?.statusCode == 401) {
    //     throw ClientException(message: 'The OTP you entered is incorrect.');
    //   }
    //   throw ServerException();
    // } catch (e) {
    //   if (e is NetworkException) rethrow;
    //   throw UnexpectedException();
    // }
  }

  Future<void> sendSmsOtp(String phoneNumber) async {
    try {
      final tenantId = dotenv.env['xTenantId']!;
      final adminToken = await _getAdminAuthToken();

      print('Generating OTP for phone: $phoneNumber');
      final otp = await _otpApiClient.generateEmailOtp(
        tenantId: tenantId,
        email: phoneNumber,
      );
      print('OTP generated successfully: $otp');

      print('Sending SMS to: $phoneNumber');
      final response = await _otpApiClient.sendSmsOtp(
        tenantId: tenantId,
        message: otp,
        phoneNumber: phoneNumber,
        token: 'Bearer $adminToken',  // Use admin token instead
      );

      print('SMS sent successfully: ${response.sentOK}');

      if (!response.sentOK) {
        throw ClientException(
          message: 'SMS service failed to send the message.',
        );
      }

    } on DioException catch (e) {
      print('DioException: Status ${e.response?.statusCode}');

      if (e.response?.statusCode == 401) {
        throw ClientException(
          message: 'Authentication failed. Verify your credentials.',
        );
      }

      throw ClientException(
        message: 'Failed to send SMS OTP. Please try again.',
      );
    } catch (e) {
      print('Unexpected error: $e');
      throw UnexpectedException();
    }
  }




  Future<void> verifySmsOtp(String phoneNumber, String otp) async {
    try {
      final tenantId = dotenv.env['xTenantId']!;
      final adminToken = await _getAdminAuthToken();

      final response = await _otpApiClient.validateOtp(
        tenantId: tenantId,
        authorization: 'Bearer $adminToken',
        userId: phoneNumber,
        otp: otp,
      );

      print('Validation Response Status: ${response.response.statusCode}');
      print('Validation Response Body: ${response.data}');

      if (response.response.statusCode != 200 && response.response.statusCode != 201) {
        throw ClientException(message: 'The OTP you entered is incorrect.');
      }

    } on DioException catch (e) {
      print('DioException during OTP validation:');
      print('Status Code: ${e.response?.statusCode}');
      print('Response: ${e.response?.data}');

      if (e.response?.statusCode == 401) {
        throw ClientException(message: 'The OTP you entered is incorrect.');
      }
      throw ServerException();
    } catch (e) {
      print('Unexpected error during validation: $e');
      if (e is NetworkException) rethrow;
      throw UnexpectedException();
    }
  }

  Future<void> createKeycloakUser() async {
    final signUpData = _ref.read(signUpDataProvider);
    if (signUpData == null) {
      throw UnexpectedException(message: "Could not retrieve user data to create account.");
    }

    try {
      final adminToken = await _getAdminAuthToken();
      final signUpRequest = SignUpRequest(
        username: signUpData.username,
        email: signUpData.email,
        firstName: signUpData.firstName,
        lastName: signUpData.lastName,
        enabled: true,
        emailVerified: true, // MODIFIED: Set email as verified
        credentials: [KeycloakCredential(type: 'password', value: signUpData.password)],
        attributes: { // MODIFIED: Correctly pass all attributes
          'phoneNumber': signUpData.phoneNumber,
          'accountType': signUpData.accountType,
        },
      );
      await _authApiClient.createUser(
        realm: dotenv.env['CC_REALM']!,
        user: signUpRequest,
        adminToken: 'Bearer $adminToken',
      );

      await _userLocalStorage.saveUsername(signUpData.username);

    } on DioException catch (e) {
      if (e.response?.data['errorMessage']?.toString().contains('already exists') ?? false) {
        throw UserAlreadyExistsException();
      }
      throw ServerException();
    } catch (e) {
      if (e is NetworkException) rethrow;
      throw UnexpectedException();
    }
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


  Future<TokenResponse> refreshAccessToken(String refreshToken) async {
    try {
      final realm = dotenv.env['CC_REALM']!;
      return await _authApiClient.refreshToken(
        realm: realm,
        grantType: 'refresh_token',
        clientId: 'bankeasy',
        clientSecret: dotenv.env['CC_CLIENT_SECRET']!,
        refreshToken: refreshToken,
      );
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout) throw TimeoutException();
      throw ServerException();
    } catch (e) {
      if (e is NetworkException) rethrow;
      throw UnexpectedException();
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
