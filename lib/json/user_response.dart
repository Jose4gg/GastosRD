import 'package:json_annotation/json_annotation.dart';

part 'user_response.g.dart';

@JsonSerializable()
class UserResponse extends Object {
  @JsonKey()
  String name;
  String email;
  String password;
  @JsonKey(name: "password_confimation")
  String passwordConfirmation;
  @JsonKey(name: "created_date")
  DateTime createdDate;

  UserResponse({
    this.name,
    this.email,
    this.password,
    this.passwordConfirmation,
    this.createdDate,
  });

  factory UserResponse.fromJson(Map<String, dynamic> json) => _$UserResponseFromJson(json);
}