import 'package:json_annotation/json_annotation.dart';

part 'otp_request.g.dart';

@JsonSerializable(includeIfNull: false)
class OtpRequest {
  final String? email;

  @JsonKey(name: 'phonenumber')
  final String? phoneNumber;

  OtpRequest({this.email, this.phoneNumber});

  factory OtpRequest.fromJson(Map<String, dynamic> json) => _$OtpRequestFromJson(json);

  Map<String, dynamic> toJson() => _$OtpRequestToJson(this);
}
