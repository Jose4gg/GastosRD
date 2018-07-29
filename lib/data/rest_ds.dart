import 'dart:async';
import 'dart:convert';

import 'package:gastos_rd/json/company_response.dart';
import 'package:gastos_rd/models/company.dart';
import 'package:gastos_rd/utils/network_util.dart';

class RestDatasource {
  static Future<Company> fetchCompany(String value) async {
    dynamic json = await NetworkUtil.get('http://api.marcos.do/rnc/$value');
    print('json: $json');
    if (json.toString() == '{}') {
      return null;
    }
    return Company.fromResponse(CompanyResponse.fromJson(json));
  }
}