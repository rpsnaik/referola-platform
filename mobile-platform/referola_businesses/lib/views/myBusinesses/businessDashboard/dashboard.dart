import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class BusinessDashboard extends StatefulWidget {
  final DocumentSnapshot businessData;
  BusinessDashboard({@required this.businessData});
  @override
  _BusinessDashboardState createState() => _BusinessDashboardState();
}

class _BusinessDashboardState extends State<BusinessDashboard> {

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text("Dashboard", style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 30.0
              ),)
            ],
          ),
        )
      ],
    );
  }
}
