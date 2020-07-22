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
    return Scaffold(
      drawer: Drawer(),
      appBar: AppBar(
        title: Text("Dashboard"),
      ),
    );
  }
}