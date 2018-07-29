import 'package:gastos_rd/json/company_response.dart';
import 'package:gastos_rd/models/company_expenses.dart';

class Company {
  String rnc;
  String name;
  String comercialName;
  String category;
  String paymentRegimen;
  String status;
  String userEmail;

  Company({
    this.rnc,
    this.name,
    this.comercialName,
    this.category,
    this.paymentRegimen,
    this.status,
    this.userEmail,
  });

  Company.fromResponse(CompanyResponse response)
      : rnc = response.rnc,
        name = response.name,
        comercialName = response.comercialName,
        category = response.category,
        paymentRegimen = response.paymentRegimen,
        status = response.status,
        userEmail = response.userEmail;

  toJson() => <String, dynamic> {
    'rnc': this.rnc,
    'name': this.name,
    'comercial_name': this.comercialName,
    'category': this.category,
    'payment_regimen': this.paymentRegimen,
    'status': this.status,
    'user_email': this.userEmail
  };
}