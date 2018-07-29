// import 'package:socialy/json/user_response.dart';

import 'package:gastos_rd/json/user_response.dart';
import 'package:gastos_rd/models/company.dart';

class User {
  String name;
  String email;
  String password;
  String passwordConfirmation;
  DateTime createdDate;

  User({
    this.name,
    this.email,
    this.password,
    this.createdDate,
  });

  User.fromResponse(UserResponse response)
      : name = response.name,
        email = response.email,
        password = response.password,
        passwordConfirmation = response.passwordConfirmation,
        createdDate = response.createdDate;

  toJson() => <String, dynamic> {
    'name': this.name,
    'email': this.email,
    'password': this.password,
    'password_confimation': this.passwordConfirmation,
    'created_date': this.createdDate?.toIso8601String()
  };
}