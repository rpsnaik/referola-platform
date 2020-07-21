import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:referola/ui-components/buttons/customAlertBox.dart';
import 'package:referola/views/auth-ui/authUIPage.dart';
import 'package:referola/views/homePage/homePage.dart';




class AccountFun{

  Future<void> accountStatusVerifier(BuildContext context)async{
    await FirebaseAuth.instance.currentUser().then((FirebaseUser user)async{
      if(user == null){
        // Redirect to Sign In Page
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>AuthUIPage()));
      }else{
        print("Signed in Successfully! - "+user.uid);
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>HomePage()));
      }
    }).catchError((e){
      print(e);
      CustomAlertBox().load(context, "Error", e.message);
    });
  }

}