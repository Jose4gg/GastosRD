import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gastos_rd/json/user_response.dart';
// import 'package:gastos_rd/data/rest_ds.dart';
import 'package:gastos_rd/models/user.dart';
import 'package:gastos_rd/screens/auth/sign_up.dart';
import 'package:gastos_rd/screens/index.dart';
import 'package:gastos_rd/services/validators.dart';

class SignIn extends StatelessWidget {  
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: SignInForm());
  }
}

class SignInForm extends StatefulWidget {
  @override
  _SignInFormState createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  bool _autovalidate = false;
  bool _obscurePassword = true;
  User user = new User();
  
  void loading(){
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => new Dialog(
        child: SingleChildScrollView(
          child: new CircularProgressIndicator(),
        ),
      ),
    );
  }

  void _handleSubmitted() {
    final FormState form = _formKey.currentState;
    if (!form.validate()) {
      setState(() {
        _autovalidate = true;
      });
      // showInSnackBar('Please fix the errors in red before submitting.');
    } else {
      form.save();
      _signIn();
    }
  }

  void _signIn() async {
    final QuerySnapshot snapshot = await Firestore.instance
        .collection("User")
        .where("email", isEqualTo: user.email)
        .where("password", isEqualTo: user.password)
        .getDocuments();
    
    if(snapshot.documents.length > 0) {
      User user = User.fromResponse(UserResponse.fromJson(snapshot.documents.first.data));

      Navigator.of(context).pushReplacement(new MaterialPageRoute(
        builder: (BuildContext context) => HomePage(user),
      ));
    } else {
      await showInSnackBar('Email or password is incorrect.');
    }
  }
  
  void showInSnackBar(String value) {
    Scaffold.of(context).showSnackBar(new SnackBar(
        content: new Text(value)
    ));
  }

  void _showPassword() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        primaryColor: Colors.white,
        accentColor: Colors.blue[600],
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: new LinearGradient(
            begin: FractionalOffset.topLeft,
            end: FractionalOffset.bottomRight,
            colors: <Color>[
              Colors.lightBlue[400],
              Colors.deepPurple[400],
            ],
          ),
        ),
        padding: EdgeInsets.all(50.0),
        child: Form(
          key: _formKey,
          autovalidate: _autovalidate,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextFormField(
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'Email',
                  hintStyle: Theme.of(context).textTheme.caption.copyWith(
                    color: Colors.white,
                  ),
                  labelStyle: Theme.of(context).textTheme.caption.copyWith(
                    color: Colors.white,
                    fontSize: 16.0,
                  ),
                ),
                style: TextStyle(
                  color: Colors.white,
                ),
                validator: Validators.validateEmail,
                onSaved: (value) => user.email = value,
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Password',
                  hintStyle: Theme.of(context).textTheme.caption.copyWith(
                    color: Colors.white,
                  ),
                  labelStyle: Theme.of(context).textTheme.caption.copyWith(
                    color: Colors.white,
                    fontSize: 16.0,
                  ),
                  suffixIcon: IconButton(
                    icon: _obscurePassword ? Icon(Icons.visibility) : Icon(Icons.visibility_off),
                    alignment: Alignment.bottomCenter,
                    onPressed: _showPassword,
                  ),
                ),
                style: TextStyle(
                  color: Colors.white,
                ),
                obscureText: _obscurePassword,
                validator: Validators.validatePassword,
                onSaved: (value) => user.password = value,
              ),
              Padding(
                padding: EdgeInsets.only(top: 20.0),
                child: Container(
                  alignment: Alignment.center,
                  child: CupertinoButton(
                    onPressed: _handleSubmitted,
                    padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 10.0),
                    color: Colors.white,
                    child: Text('SIGN IN', style: TextStyle(color: Colors.blue[600], fontSize: 18.0),),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 24.0),
                child: GestureDetector(
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => SignUp(),
                    ),
                  ),
                  child: Center(
                    child: RichText(
                      textAlign: TextAlign.right,
                      text: TextSpan(
                        style: TextStyle(color: Colors.white),
                        children:[
                          TextSpan(text: "Don't have an Account? "),
                          TextSpan(
                            text: 'Sign up!',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}