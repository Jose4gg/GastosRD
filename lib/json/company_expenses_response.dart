import 'package:json_annotation/json_annotation.dart';

part 'company_expenses_response.g.dart';

@JsonSerializable()
class CompanyExpensesResponse extends Object {
  @JsonKey(name: 'rnc_supplier')
  String rncSupplier;
  @JsonKey(name: 'supplier_name')
  String supplierName;
  String ncf;
  DateTime date;
  double total;
  double itbis;
  @JsonKey(name: 'image_uri')
  String imageUri;
  @JsonKey(name: 'purchase_concept')
  String purchaseConcept;
  @JsonKey(name: 'company_rnc')
  String companyRnc;
  @JsonKey(name: 'company_name')
  String companyName;

  CompanyExpensesResponse({
    this.rncSupplier,
    this.supplierName,
    this.ncf,
    this.date,
    this.total,
    this.itbis,
    this.imageUri,
    this.purchaseConcept,
    this.companyRnc,
    this.companyName,
  });

  factory CompanyExpensesResponse.fromJson(Map<String, dynamic> json) => _$CompanyExpensesResponseFromJson(json);
}