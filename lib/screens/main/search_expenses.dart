import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gastos_rd/components/date_picker.dart';
import 'package:gastos_rd/json/company_expenses_response.dart';
import 'package:gastos_rd/models/company_expenses.dart';
import 'package:gastos_rd/models/user.dart';

class SearchExpenses extends StatefulWidget {
  final User user;

  SearchExpenses(this.user);

  @override
  _SearchExpensesState createState() => _SearchExpensesState(user);
}

class _SearchExpensesState extends State<SearchExpenses> {
  final User user;
  DateTime startDate = new DateTime(1999, 1, 1);
  DateTime endDate = new DateTime.now();

  _SearchExpensesState(this.user);

  Future<List<CompanyExpenses>> _getCompaniesExpenses() async {
    List<CompanyExpenses> list = new List<CompanyExpenses>();

    final QuerySnapshot snapshot = await Firestore.instance
        .collection("CompanyExpenses")
        .where('date', isGreaterThanOrEqualTo: startDate.toIso8601String(), isLessThanOrEqualTo: endDate.toIso8601String())
        .getDocuments();
    
    if(snapshot.documents.length != 0) {
      snapshot.documents.forEach((d) async { 
        list.add(new CompanyExpenses.fromResponse(CompanyExpensesResponse.fromJson(d.data)));
      });
    }

    print(list);

    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Column (
      children: <Widget> [
        Column(
          children: <Widget>[
            DatePicker(
              decoration: InputDecoration(
                labelText: 'Date',
                fillColor: Colors.grey[150],
                filled: true,
              ),
              firstDate: DateTime(2000, 1, 1),
              selectedDate: startDate,
              selectDate: (DateTime date) {
                setState(() {
                  startDate = date;
                });
              },
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 2.0),
            ),
            DatePicker(
              decoration: InputDecoration(
                labelText: 'Date',
                fillColor: Colors.grey[150],
                filled: true,
              ),
              firstDate: DateTime(2000, 1, 1),
              selectedDate: endDate,
              selectDate: (DateTime date) {
                setState(() {
                  endDate = date;
                });
              },
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 2.0),
            ),
            CupertinoButton(
              onPressed: _getCompaniesExpenses,
              padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 10.0),
              color: Colors.blue[600],
              child: Text('SEARCH', style: TextStyle(color: Colors.white, fontSize: 18.0),),
            ),
          ],
        ),
        Container(
          height: 489.0,
          child: FutureBuilder<List<CompanyExpenses>>(
          future: _getCompaniesExpenses(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (context, i) {
                  return Column(
                    children: <Widget>[
                      Center(
                        child: Text('Expense #$i:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 32.0)),
                      ),
                      Padding(padding: EdgeInsets.symmetric(vertical: 4.0),),
                      Image.network(snapshot.data[i].imageUri),
                      Padding(padding: EdgeInsets.symmetric(vertical: 4.0),),
                      Row(
                        children: <Widget>[
                          Container(
                            width: 140.0,
                            child: Text('Company:', style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
                          ),
                          Text(snapshot.data[i].companyName ?? '', style: TextStyle(fontSize: 18.0),),
                        ],
                      ),
                      Padding(padding: EdgeInsets.symmetric(vertical: 4.0),),
                      Row(
                        children: <Widget>[
                          Container(
                            width: 140.0,
                            child: Text('Supplier:', style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
                          ),
                          Text(snapshot.data[i].supplierName ?? '', style: TextStyle(fontSize: 18.0),),
                        ],
                      ),
                      Padding(padding: EdgeInsets.symmetric(vertical: 4.0),),
                      Row(
                        children: <Widget>[
                          Container(
                            width: 140.0,
                            child: Text('NCF:', style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
                          ),
                          Text(snapshot.data[i].ncf, style: TextStyle(fontSize: 18.0),),
                        ],
                      ),
                      Padding(padding: EdgeInsets.symmetric(vertical: 4.0),),
                      Row(
                        children: <Widget>[
                          Container(
                            width: 140.0,
                            child: Text('Date:', style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
                          ),
                          Text(snapshot.data[i].date.toIso8601String(), style: TextStyle(fontSize: 18.0),),
                        ],
                      ),
                      Padding(padding: EdgeInsets.symmetric(vertical: 4.0),),
                      Row(
                        children: <Widget>[
                          Container(
                            width: 140.0,
                            child: Text('Total:', style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
                          ),
                          Text('RD\$${snapshot.data[i].total.toString()}', style: TextStyle(fontSize: 18.0),),
                        ],
                      ),
                      Padding(padding: EdgeInsets.symmetric(vertical: 4.0),),
                      Row(
                        children: <Widget>[
                          Container(
                            width: 140.0,
                            child: Text('ITBIS:', style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
                          ),
                          Text('RD\$${snapshot.data[i].itbis.toString()}', style: TextStyle(fontSize: 18.0),),
                        ],
                      ),
                      Padding(padding: EdgeInsets.symmetric(vertical: 4.0),),
                      Row(
                        children: <Widget>[
                          Container(
                            width: 140.0,
                            child: Text('Purchase Concept:', style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
                          ),
                          Text(snapshot.data[i].purchaseConcept.toString(), style: TextStyle(fontSize: 18.0),),
                        ],
                      ),
                      Padding(padding: EdgeInsets.symmetric(vertical: 4.0),),
                      Padding(padding: EdgeInsets.symmetric(vertical: 4.0),),
                    ],
                  );
                },
              );
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }
            // By default, show a loading spinner
            return CircularProgressIndicator();
          },
        ),
      ),
    ],
  );
  }
}