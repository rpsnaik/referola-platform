import 'package:flutter/material.dart';
import 'package:referola/views/homePage/featured/featuredPage.dart';
import 'package:referola/views/homePage/notifications/notificationsPage.dart';
import 'package:referola/views/homePage/profile/profilePage.dart';
import 'package:referola/views/homePage/saved/savedPage.dart';
import 'package:referola/views/homePage/search/searchPage.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currIndex = 0;
  List bottomNavItems = [FeaturedPage(), SearchPage(), NotificationsPage(), SavedPage(), ProfilePage()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: currIndex,
        onTap: (int i){
          setState((){
            currIndex = i;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text("Featured")
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            title: Text("Search")
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            title: Text("Notification")
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            title: Text("Saved")
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            title: Text("Profile")
          ),
        ],
      ),
      
      body: bottomNavItems[currIndex]
    );
  }
}
