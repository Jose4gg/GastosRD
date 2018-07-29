import 'package:json_annotation/json_annotation.dart';

part 'company_response.g.dart';

@JsonSerializable()
class CompanyResponse extends Object {
  String rnc;
  String name;
  @JsonKey(name: 'comercial_name')
  String comercialName;
  String category;
  @JsonKey(name: 'payment_regimen')
  String paymentRegimen;
  String status;
  @JsonKey(name: 'user_email')
  String userEmail;

  CompanyResponse({
    this.rnc,
    this.name,
    this.comercialName,
    this.category,
    this.paymentRegimen,
    this.status,
    this.userEmail,
  });

  factory CompanyResponse.fromJson(Map<String, dynamic> json) => _$CompanyResponseFromJson(json);
}