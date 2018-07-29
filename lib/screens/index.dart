import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gastos_rd/json/company_response.dart';
import 'package:gastos_rd/models/company.dart';
import 'package:gastos_rd/models/user.dart';

// Pages
import './main/company_sign_up.dart';
import './main/company_expenses_register.dart';
import './main/search_expenses.dart';
import './main/about.dart';

// Screens
// import '../screens/home.dart';
// import '../screens/parallax_list.dart';
// import '../screens/second_screen.dart';

class HomePage extends StatefulWidget {
  final User user;

  HomePage(this.user);

  @override
  _HomePageState createState() => new _HomePageState(user);
}

class _HomePageState extends State<HomePage> {
  int _selectedDrawerIndex = 0;
  final NetworkImage userImage = new NetworkImage('https://lh3.googleusercontent.com/-8dg263oazcQ/AAAAAAAAAAI/AAAAAAAAAAA/AB6qoq23B20ArLMIL0kFHyMvk_FBOFKyNA/s120-p-no-mo-il/photo.jpg');
  final NetworkImage userBackgroundImage = new NetworkImage('https://hdwallpaperim.com/wp-content/uploads/2017/08/25/466074-low_poly-landscape-mountains-mist-dead_trees-forest-river-water-stones-fence-trunks-Axe-hills-digital_art-3D-Cinema_4D-748x421.jpg');
  bool _userImageLoading = true;
  bool _userBackgroundImageLoading = true;
  User user;
  
  _HomePageState(this.user);

  @override
  void initState() {
    userImage.resolve(new ImageConfiguration()).addListener((_, __) {
      if (mounted) {
        setState(() {
          _userImageLoading = false;
        });
      }
    });
    userBackgroundImage.resolve(new ImageConfiguration()).addListener((_, __) {
      if (mounted) {
        setState(() {
          _userBackgroundImageLoading = false;
        });
      }
    });
  }

  _getDrawerItemWidget(int pos) {
    if (pos == 1) {
      return new CompanySignUp(user);
    } else if (pos == 2) {
      return new CompanyExpensesRegister(user);
    } else if (pos == 3) {
      return new SearchExpenses(user);
    } else if (pos == 4) {
      return new About(user);
    } else {
      return new About(user);
    }
  }

  _onSelectItem(int index) {
    setState(() => _selectedDrawerIndex = index);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Row(
          children: <Widget>[
            new Text(
              'Gastos RD',
            ),
            new Padding(
              padding: EdgeInsets.only(left: 8.0),
              child: new Icon(
                Icons.spa,
                color: Colors.lime,
              ),
            ),
          ],
        ),
        backgroundColor: Colors.green[800],
      ),
      drawer: new Drawer(
        child: new ListView(
          children: <Widget>[
            new UserAccountsDrawerHeader(
              accountName: new Text(user.name),
              accountEmail: new Text(user.email),
              currentAccountPicture: new GestureDetector(
                onTap: () {} ,
                child: new CircleAvatar(
                  backgroundColor: Colors.green,
                  child: Text(user.name[0].toUpperCase(), style: TextStyle(fontSize: 32.0, color: Colors.white),),
                ),
              ),
              decoration: new BoxDecoration(
                image: new DecorationImage(
                  fit: BoxFit.fill,
                  image: userBackgroundImage,
                ),
              ),
            ),
            new ListTile(
              title: new Text("Register a Company"),
              leading: new Icon(Icons.business,),
              selected: 1 == _selectedDrawerIndex,
              onTap: () {
                _onSelectItem(1);
                setState((){
                  _selectedDrawerIndex = 1;
                });
              }
            ),
            new ListTile(
              title: new Text("Register Expenses"),
              leading: new Icon(Icons.receipt,),
              selected: 2 == _selectedDrawerIndex,
              onTap: () {
                _onSelectItem(2);
                setState((){
                  _selectedDrawerIndex = 2;
                });
              }
            ),
            new ListTile(
              title: new Text("Search expenses"),
              leading: new Icon(Icons.search,),
              selected: 3 == _selectedDrawerIndex,
              onTap: () {
                _onSelectItem(3);
                setState((){
                  _selectedDrawerIndex = 3;
                });
              }
            ),
            new ListTile(
              title: new Text("About"),
              leading: new Icon(Icons.person,),
              selected: 4 == _selectedDrawerIndex,
              onTap: () {
                _onSelectItem(4);
                setState((){
                  _selectedDrawerIndex = 4;
                });
              }
            ),
            new Divider(),
            new ListTile(
              title: new Text("Close"),
              leading: new Icon(Icons.cancel,),
              onTap: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      ),
      body: _getDrawerItemWidget(_selectedDrawerIndex),
    );
  }
}