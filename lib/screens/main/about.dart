import 'package:flutter/material.dart';
import 'package:gastos_rd/models/user.dart';

class About extends StatelessWidget {
  final User user;

  About(this.user);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(8.0),
      alignment: Alignment.topCenter,
      child: Column(
        children: <Widget>[
          CircleAvatar(
            radius: 64.0,
            child: Text(
              'J',
              style: TextStyle(
                color: Colors.white,
                fontSize: 48.0,
              ),
            ),
            backgroundColor: Colors.green,
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
          ),
          Text(user.name.toUpperCase(),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24.0,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 24.0),
          ),
          Row(
            children: <Widget>[
              Container(
                width: 140.0,
                child: Text('Name:', style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),),
              ),
              Text(user.name, style: TextStyle(fontSize: 18.0),),
            ],
          ),
          Padding(padding: EdgeInsets.symmetric(vertical: 4.0),),
          Row(
            children: <Widget>[
              Container(
                width: 140.0,
                child: Text('Email:', style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
              ),
              Text(user.email, style: TextStyle(fontSize: 18.0),),
            ],
          ),
          Padding(padding: EdgeInsets.symmetric(vertical: 4.0),),
          Row(
            children: <Widget>[
              Container(
                width: 140.0,
                child: Text('Created Date:', style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),),
              ),
              Text(user.createdDate.toIso8601String() ?? 'Unknown', style: TextStyle(fontSize: 18.0),),
            ],
          ),
        ],
      ),
    );
  }
}