import 'package:flutter/material.dart';
import 'package:referola/logic/auth/googleAuth.dart';
import 'package:referola/views/auth-ui/authUIPage.dart';

class HomePage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: Text("HomePage", style: TextStyle(
          
        ),),
        automaticallyImplyLeading: false,
      ),
      body: Container(
        child: Center(
          child: MaterialButton(
            onPressed: () {
              googleSignout().then((value) {
                Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => AuthUIPage()), (route) => false);
              });
            },
            child: Text("log out"),
          ),
        )
      ),
    );
  }
}