import 'package:dio/dio.dart' hide Headers;
import 'package:retrofit/retrofit.dart';
import '../models/otp_request.dart';
import '../models/send_email_request.dart';

part 'otp_api_client.g.dart';

@RestApi()
abstract class OtpApiClient {
  factory OtpApiClient(Dio dio, {String? baseUrl}) = _OtpApiClient;

  /// Generates an OTP for the user's email address and returns it as plain text.
  @GET("http://api.issl.ng:7777/ibank/api/v1/generateotp")
  @Headers(<String, dynamic>{'Accept': 'application/json'})
  Future<String> generateEmailOtp({
    @Header("x-tenant-id") required String tenantId,
    @Query("userId") required String email,
  });

  /// Triggers the sending of the generated OTP to the user's email.
  @POST("http://api.issl.ng:7777/ibank/api/v1/sendmail")
  @Headers(<String, dynamic>{'Content-Type': 'application/json', 'Accept': 'application/json'})
  Future<void> sendEmail({
    @Header("x-tenant-id") required String tenantId,
    @Body() required SendEmailRequest body,
  });

  /// Sends an OTP to the user's phone number.
  /// Sends an OTP to the user's phone number.
  @GET("/ibank/api/v1/sendsms")
  @Headers(<String, dynamic>{'Accept': 'application/json'})
  Future<void> sendSmsOtp({
    @Header("x-tenant-id") required String tenantId,
    @Query("message") required String message,
    @Query("recipient") required String phoneNumber,
  });


  /// Validates the OTP for a given user ID (email or phone).
  @GET("/ibank/api/v1/validateotp/{userId}/{otp}")
  @Headers(<String, dynamic>{'Accept': 'application/json'})
  Future<void> validateOtp({
    @Header("x-tenant-id") required String tenantId,
    @Path("userId") required String userId,
    @Path("otp") required String otp,
  });
}
