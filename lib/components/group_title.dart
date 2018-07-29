import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class GroupTitle extends StatelessWidget {
  final Icon icon;
  final String title;

  GroupTitle({
    @required this.icon,
    @required this.title,
  });
  
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(right: 8.0),
          child: icon,
        ),
        Text(
          title,
          textAlign: TextAlign.left,
          style: TextStyle(
            fontSize: 18.0
          ),
        ),
      ],
    );
  }
}