import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../../../../utils/constants/api_constants.dart';
import '../models/keycloak_user.dart';
import '../models/sign_up_request.dart';
import '../models/token_response.dart';

part 'auth_api_client.g.dart';

@RestApi()
abstract class AuthApiClient {
  factory AuthApiClient(Dio dio, {String? baseUrl}) = _AuthApiClient;

  // --- STANDARD AUTH ---

  @POST(ApiConstants.keycloakTokenEndpoint)
  @FormUrlEncoded()
  Future<TokenResponse> login({
    @Path("realm") required String realm,
    @Field("grant_type") required String grantType,
    @Field("client_id") required String clientId,
    @Field("client_secret") required String clientSecret,
    @Field("username") required String username,
    @Field("password") required String password,
  });

  @POST(ApiConstants.keycloakTokenEndpoint)
  @FormUrlEncoded()
  Future<TokenResponse> refreshToken({
    @Path("realm") required String realm,
    @Field("grant_type") required String grantType,
    @Field("client_id") required String clientId,
    @Field("client_secret") required String clientSecret,
    @Field("refresh_token") required String refreshToken,
  });

  @POST(ApiConstants.keycloakLogoutEndpoint)
  @FormUrlEncoded()
  Future<void> logout({
    @Path("realm") required String realm,
    @Field("client_id") required String clientId,
    @Field("client_secret") required String clientSecret,
    @Field("refresh_token") required String refreshToken,
  });

  // --- ADMIN API FOR SIGN-UP ---

  // Step 1: Check if user exists by email
  @GET(ApiConstants.keycloakGetUsers)
  Future<List<KeycloakUser>> getUsers({
    @Path("realm") required String realm,
    @Query("email") required String email,
    @Header("Authorization") required String adminToken,
  });

  // Step 3: Create the user in Keycloak
  // Note: This returns a 201 Created with an empty body.
  // We must call getUsers again to get the new user's ID.
  @POST(ApiConstants.keycloakCreateUser)
  Future<void> createUser({
    @Path("realm") required String realm,
    @Body() required SignUpRequest user,
    @Header("Authorization") required String adminToken,
  });

  // Step 4: Update the user with attributes (requestId, accountType)
  @PUT(ApiConstants.keycloakUpdateUser)
  Future<void> updateUser({
    @Path("realm") required String realm,
    @Path("userId") required String userId,
    @Body() required Map<String, dynamic> attributes,
    @Header("Authorization") required String adminToken,
  });
}
