import 'package:gastos_rd/json/company_expenses_response.dart';

class CompanyExpenses {
  String rncSupplier;
  String supplierName;
  String ncf;
  DateTime date;
  double total;
  double itbis;
  String imageUri;
  String purchaseConcept;
  String companyRnc;
  String companyName;

  CompanyExpenses({
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

  CompanyExpenses.fromResponse(CompanyExpensesResponse response)
      : rncSupplier = response.rncSupplier,
        ncf = response.ncf,
        date = response.date,
        total = response.total,
        itbis = response.itbis,
        imageUri = response.imageUri,
        purchaseConcept = response.purchaseConcept,
        companyRnc = response.companyRnc;

  toJson() => <String, dynamic> {
      'rnc_supplier': this.rncSupplier,
      'ncf': this.ncf,
      'date': this.date?.toIso8601String(),
      'total': this.total,
      'itbis': this.itbis,
      'image_uri': this.imageUri,
      'purchase_concept': this.purchaseConcept,
      'company_rnc': this.companyRnc,
  };
}