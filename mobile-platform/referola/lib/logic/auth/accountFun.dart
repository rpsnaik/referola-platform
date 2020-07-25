import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:referola/logic/getLocation/fetchLocationInfo.dart';
import 'package:referola/ui-components/buttons/customAlertBox.dart';
import 'package:referola/views/auth-ui/authUIPage.dart';
import 'package:referola/views/auth-ui/completeProfile.dart';
import 'package:referola/views/homePage/homePage.dart';




class AccountFun{

  Future<void> accountStatusVerifier(BuildContext context)async{
    await FirebaseAuth.instance.currentUser().then((FirebaseUser user)async{
      if(user == null){
        // Redirect to Sign In Page
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => AuthUIPage()), (route) => false);
      }else{
        print("Signed in Successfully! - "+user.uid);
        userProfileCheck(context, user);
      }
    }).catchError((e){
      print(e);
      CustomAlertBox().load(context, "Error", e.message);
    });
  }


    Future<void> userProfileCheck(BuildContext context, FirebaseUser user)async{
    await Firestore.instance.collection("users").document(user.uid).get().then((DocumentSnapshot docData){
      if(docData.data != null){
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => HomePage()), (route) => false);
      }else{
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => CompleteYourProfilePage()), (route) => false);
      }
    }).catchError((e){
      print(e);
      CustomAlertBox().load(context, "Error", e.message);
    });
  }


   Future<void> createUserProfile(BuildContext context, FirebaseUser user, String name, String profileImgUrl, DateTime dob, LocData locData)async{


    await Firestore.instance.collection("users").document(user.uid).setData({
      "userId": user.uid,
      "userLegalName": name,
      "userEmail": user.email,
      "userDateOfBirth": dob,
      "addressName": locData.address[0].name,
      "addressLocality": locData.address[0].locality,
      "addressSubAdministrativeArea": locData.address[0].subAdministrativeArea,
      "addressAdministrativeArea": locData.address[0].administrativeArea,
      "addressCountry": locData.address[0].country,
      "addressPincode": locData.address[0].postalCode,
      "latitude": locData.lat,
      "longitude": locData.long,
      "userProfileImage": profileImgUrl,
      "accountCreatedOn": FieldValue.serverTimestamp(),
    }).then((E){
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>HomePage()));
    }).catchError((e){
      print(e);
      CustomAlertBox().load(context, "Error", e.message);
    });
  }

}