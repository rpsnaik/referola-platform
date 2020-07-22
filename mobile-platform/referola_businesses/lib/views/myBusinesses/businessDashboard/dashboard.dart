import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:referola_businesses/views/myBusinesses/businessDashboard/campains/addCampains.dart';

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
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => AddCampains()));
            },
            )
        ],
      ),
    );
  }
}