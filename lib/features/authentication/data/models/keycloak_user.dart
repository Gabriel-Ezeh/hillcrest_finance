import 'package:json_annotation/json_annotation.dart';

part 'keycloak_user.g.dart';

@JsonSerializable()
class KeycloakUser {
  final String id;
  final String? username;
  final String? email;
  final String? firstName;
  final String? lastName;
  final Map<String, dynamic>? attributes;

  KeycloakUser({
    required this.id,
    this.username,
    this.email,
    this.firstName,
    this.lastName,
    this.attributes,
  });

  factory KeycloakUser.fromJson(Map<String, dynamic> json) => _$KeycloakUserFromJson(json);

  Map<String, dynamic> toJson() => _$KeycloakUserToJson(this);
}
