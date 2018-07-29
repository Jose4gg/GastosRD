import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:gastos_rd/components/group_title.dart';
import 'package:gastos_rd/data/rest_ds.dart';
import 'package:gastos_rd/models/company.dart';
import 'package:gastos_rd/models/user.dart';

// import 'package:socialy/data/rest_ds.dart';
import '../../services/validators.dart';

class CompanySignUp extends StatelessWidget {
  User user;

  CompanySignUp(this.user);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          child: CompanySignUpForm(user),
        ),
      ),
    );
  }
}

class CompanySignUpForm extends StatefulWidget {
  User user;

  CompanySignUpForm(this.user);

  @override
  _CompanySignUpFormState createState() => _CompanySignUpFormState(user);
}

class _CompanySignUpFormState extends State<CompanySignUpForm> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  bool _autovalidate = false;
  Company _newCompany;
  String _rnc;
  User user;

  _CompanySignUpFormState(this.user);

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

  void _handleSubmitted() async {
    final FormState form = _formKey.currentState;
    // loading();
    form.save();
    if (!form.validate()) {
      setState(() {
        _autovalidate = true;
      });
    } else {
      form.save();
      _newCompany = await RestDatasource.fetchCompany(_rnc);
      print(_newCompany);
      if (_newCompany == null) {
        showInSnackBar('RNC is not valid. Please try again.');
      }
      else {
        _signUp();
      }
    }
  }
  
  void showInSnackBar(String value) {
    Scaffold.of(context).showSnackBar(new SnackBar(
      content: new Text(value)
    ));
  }
  
  void _signUp() async {
    final DocumentReference documentReference = Firestore.instance.collection("Company").document();
    
    _newCompany.userEmail = user.email;

    final QuerySnapshot snapshot = await Firestore.instance
        .collection("Company")
        .where("user_email", isEqualTo: user.email)
        .getDocuments();
    
    if(snapshot.documents.length > 0) {
      showInSnackBar('Company with rnc ${_newCompany.rnc} already exists!');
    } else {
      documentReference.setData(_newCompany.toJson()).whenComplete(() {
        showInSnackBar('Company ${_newCompany.name} registered successfully!');
      }).catchError((e) => print(e));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(32.0),
      child: Form(
        key: _formKey,
        autovalidate: _autovalidate,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            GroupTitle(
              icon: Icon(Icons.business),
              title: 'Company Information',
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 12.0),
            ),
            TextFormField(
              decoration: InputDecoration(
                labelText: "RNC",
                fillColor: Colors.grey[150],
                filled: true,
                errorMaxLines: 2,
                hintText: 'E.g: 123456789',
              ),
              keyboardType: TextInputType.number,
              validator: (value) => Validators.validateRNC(value),
              onSaved: (value) => _rnc = value,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
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