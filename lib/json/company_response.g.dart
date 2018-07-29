// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'company_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CompanyResponse _$CompanyResponseFromJson(Map<String, dynamic> json) {
  return new CompanyResponse(
      rnc: json['rnc'] as String,
      name: json['name'] as String,
      comercialName: json['comercial_name'] as String,
      category: json['category'] as String,
      paymentRegimen: json['payment_regimen'] as String,
      status: json['status'] as String,
      userEmail: json['user_email'] as String);
}

Map<String, dynamic> _$CompanyResponseToJson(CompanyResponse instance) =>
    <String, dynamic>{
      'rnc': instance.rnc,
      'name': instance.name,
      'comercial_name': instance.comercialName,
      'category': instance.category,
      'payment_regimen': instance.paymentRegimen,
      'status': instance.status,
      'user_email': instance.userEmail
    };
