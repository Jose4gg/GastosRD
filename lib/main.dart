import 'package:flutter/material.dart';
import 'package:gastos_rd/screens/auth/sign_in.dart';
import 'package:gastos_rd/screens/auth/sign_up.dart';
import 'package:gastos_rd/screens/main/about.dart';
import 'package:gastos_rd/screens/main/company_expenses_register.dart';
import './screens/main/company_sign_up.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Socialy',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: SignIn(),
    );
  }
}