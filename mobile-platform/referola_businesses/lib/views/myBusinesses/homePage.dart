import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:referola_businesses/views/myBusinesses/businessDashboard/dashboard.dart';
import 'package:referola_businesses/views/myBusinesses/myCampaigns/myCampaigns.dart';

class HomePage extends StatefulWidget {
  final DocumentSnapshot businessData;
  HomePage({@required this.businessData});
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currIndex = 0;

  List<Widget> pages;

  @override
  void initState() {
    pages = [BusinessDashboard(businessData: widget.businessData,), MyCampaigns(businessData: widget.businessData,), Container(), Container()];
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            title: Text("Dashboard")
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            title: Text("My Campaigns")
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.library_books),
            title: Text("My Orders")
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            title: Text("Profile")
          ),
        ],
        currentIndex: currIndex,
        onTap: (int i){
          setState(() {
            currIndex = i;
          });
        },

      ),
      body: pages[currIndex]
    );
  }
}