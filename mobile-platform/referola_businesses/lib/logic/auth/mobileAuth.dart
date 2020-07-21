import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../../main.dart';

class MobileAuth{

  void signInWithCredential(BuildContext context, AuthCredential authCredential)async{
    await FirebaseAuth.instance.signInWithCredential(authCredential).then((AuthResult authResult){
      print("Signed in successfully!");
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
        builder: (context)=>SplashScreen()
      ), (Route<dynamic> r) => false);
    }).catchError((e){
      print(e);
    });
  }

}



// Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
//         builder: (context)=>SplashScreen()
//       ), (Route<dynamic> r) => false);