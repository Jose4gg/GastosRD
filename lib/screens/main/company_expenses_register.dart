import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:gastos_rd/components/group_title.dart';
import 'package:gastos_rd/data/rest_ds.dart';
import 'package:gastos_rd/json/company_response.dart';
import 'package:gastos_rd/models/company.dart';
import 'package:gastos_rd/models/company_expenses.dart';
import 'package:gastos_rd/models/user.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

// import 'package:socialy/data/rest_ds.dart';
import '../../services/validators.dart';
import '../../components/date_picker.dart';

class CompanyExpensesRegister extends StatelessWidget {
  final User user;

  CompanyExpensesRegister(this.user);
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView( 
        primary: false,
        child: FutureBuilder<List<Company>>(
          future: _getCompanies(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return CompanyExpensesRegisterForm(snapshot.data);
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }
            // By default, show a loading spinner
            return CircularProgressIndicator();
          },
        ),
      ),
    );
  }

  Future<List<Company>> _getCompanies() async {
    List<Company> list = new List<Company>();
    final QuerySnapshot snapshot = await Firestore.instance
        .collection("Company")
        .where("user_email", isEqualTo: user.email)
        .getDocuments();
    
    if(snapshot.documents.length == 0) {
      return list;
    } else {
      snapshot.documents.forEach((d) { 
        list.add(new Company.fromResponse(CompanyResponse.fromJson(d.data)));
      });
      return list;
    }
  }
}

class CompanyExpensesRegisterForm extends StatefulWidget {
  final List<Company> companies;

  CompanyExpensesRegisterForm(this.companies);

  @override
  companyExpensesRegisterFormState createState() => companyExpensesRegisterFormState(companies);
}

class companyExpensesRegisterFormState extends State<CompanyExpensesRegisterForm> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  bool _autovalidate = false;
  bool _obscurePassword = true;
  bool _obscureRepeatPassword = true;
  CompanyExpenses _newCompanyExpenses = CompanyExpenses(date: DateTime.now());
  final List<Company> companies;
  Company _newCompany;

  companyExpensesRegisterFormState(this.companies);
  
  File _image;

  getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);

    if (image != null) {
      setState(() {
        _image = image;
      });
    }
  }

  void loading(){
    showDialog(
      context: context,
      builder: (BuildContext context) => new Dialog(
        child: SingleChildScrollView(
          child: new Container(
            height: 600.0,
          )
        ),
      ),
    );
  }
  
  void showInSnackBar(String value) {
    Scaffold.of(context).showSnackBar(new SnackBar(
      content: new Text(value)
    ));
  }

  void _handleSubmitted() async {
    final FormState form = _formKey.currentState;
    if (!form.validate()) {
      setState(() {
        _autovalidate = true;
      });
      // showInSnackBar('Please fix the errors in red before submitting.');
    } else {
      form.save();
      _newCompany = await RestDatasource.fetchCompany(_newCompanyExpenses.rncSupplier);
      if (_newCompany == null) {
        showInSnackBar('RNC is not valid. Please try again.');
      }
      else {
        if (_image != null) {
          _signUp();
        } else {
          showInSnackBar('Photo Evidence is required.');
        }
      }
    }
  }

  void _signUp() async {
    StorageUploadTask putFile = FirebaseStorage.instance.ref().child(_image.path).putFile(_image);
    Uri downloadUrl = (await putFile.future).downloadUrl;

    _newCompanyExpenses.imageUri = downloadUrl.toString();
    _newCompanyExpenses.companyRnc = _newCompany.rnc;
    _newCompanyExpenses.companyName = _newCompany.name;
    _newCompanyExpenses.supplierName = (await RestDatasource.fetchCompany(_newCompanyExpenses.rncSupplier)).name;
    
    final DocumentReference documentReference = Firestore.instance.collection("CompanyExpenses").document();
    
    documentReference.setData(_newCompanyExpenses.toJson()).whenComplete(() {
      showInSnackBar('Expense of NCF:${_newCompanyExpenses.ncf} registered successfully!');
    }).catchError((e) => print(e));
  }

  @override
  Widget build(BuildContext context) {
    Company company = companies[0];

    return Padding(
      padding: EdgeInsets.all(32.0),
      child: Form(
        key: _formKey,
        autovalidate: _autovalidate,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(vertical: 12.0),
            ),
            GroupTitle(
              icon: Icon(Icons.room_service),
              title: 'Service',
            ),
            InputDecorator(
              decoration: InputDecoration(
                labelText: 'Select a Company',
                fillColor: Colors.grey[150],
                filled: true,
              ),
              isEmpty: company == null,
              child: DropdownButton<Company>(
                isDense: true,
                hint: Text('Select a Company'),
                value: company,
                onChanged: (newValue) {
                  setState(() {
                    company = newValue;
                  });
                },
                items: companies.map((Company company) {
                  return DropdownMenuItem<Company>(
                    value: company,
                    child: Text(
                      company.name,
                      style: TextStyle(color: Colors.black),
                    ),
                  );
                }).toList(),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 20.0),
            ),
            GroupTitle(
              icon: Icon(Icons.person_outline),
              title: 'Supplier Information',
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 12.0),
            ),
            TextFormField(
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: "RNC Supplier",
                fillColor: Colors.grey[150],
                filled: true,
              ),
              validator: Validators.validateRNC,
              onSaved: (value) => _newCompanyExpenses.rncSupplier = value,
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 20.0),
            ),
            GroupTitle(
              icon: Icon(Icons.receipt),
              title: 'Invoice Information',
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
            ),
            TextFormField(
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: "NCF",
                fillColor: Colors.grey[150],
                filled: true,
              ),
              validator: (value) => value.length > 0 ? null : 'NCF is required.',
              onSaved: (value) => _newCompanyExpenses.ncf = value,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
            ),
            DatePicker(
              decoration: InputDecoration(
                labelText: 'Date',
                fillColor: Colors.grey[150],
                filled: true,
              ),
              firstDate: DateTime(2000, 1, 1),
              selectedDate: _newCompanyExpenses.date,
              selectDate: (DateTime date) {
                setState(() {
                  _newCompanyExpenses.date = date;
                });
              },
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 12.0),
            ),
            TextFormField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Total",
                fillColor: Colors.grey[150],
                filled: true,
              ),
              validator: (value) => Validators.validatePrice(value, "Total"),
              onSaved: (value) => _newCompanyExpenses.total = double.parse(value) ?? 0.0,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
            ),
            TextFormField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'ITBIS',
                fillColor: Colors.grey[150],
                filled: true,
              ),
              validator: (value) => Validators.validatePrice(value, 'ITBIS'),
              onSaved: (value) => _newCompanyExpenses.itbis = double.parse(value) ?? 0.0,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
            ),
            Row(
              children: <Widget>[
                Flexible(
                  child: _image == null 
                    ? Text('No image to show')
                    : Image.file(_image),
                ),
                Flexible(
                  child: CupertinoButton(
                    onPressed: getImage,
                    child: Text('Select Photo'),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
            ),
            TextFormField(
              decoration: InputDecoration(
                labelText: "Purchase Concept",
                fillColor: Colors.grey[150],
                filled: true,
              ),
              maxLines: 4,
              onSaved: (value) => _newCompanyExpenses.purchaseConcept = value,
            ),
            Padding(
              padding: EdgeInsets.only(top: 20.0),
            ), 
            Container(
              alignment: Alignment.center,
              child: CupertinoButton(
                onPressed: _handleSubmitted,
                padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 10.0),
                color: Colors.blue[600],
                child: Text('REGISTER', style: TextStyle(color: Colors.white, fontSize: 18.0),),
              ),
            ),
          ],
        ),
      ),
    );
  }
}