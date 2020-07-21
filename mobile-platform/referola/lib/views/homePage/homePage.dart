import 'package:flutter/material.dart';
import 'package:referola/logic/auth/googleAuth.dart';
import 'package:referola/views/auth-ui/authUIPage.dart';

class HomePage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text("HomePage", style: TextStyle(
          color: Colors.blueGrey,
        ),),
        automaticallyImplyLeading: false,
      ),
      body: Container(
        child: Center(
          child: MaterialButton(
            onPressed: () {
              googleSignout();
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context) => AuthUIPage()));
            },
            child: Text("log out"),
          ),
        )
      ),
    );
  }
}