import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:referola_businesses/logic/getLocation/fetchLocationinfo.dart';
import 'package:referola_businesses/ui-components/buttons/customAlertBox.dart';
import 'package:referola_businesses/views/auth-ui/authUiPage.dart';
import 'package:referola_businesses/views/auth-ui/completeBusinessProfile.dart';
import 'package:referola_businesses/views/auth-ui/completeProfile.dart';
import 'package:referola_businesses/views/homePage/homePage.dart';




class AccountFun{

  Future<void> accountStatusVerifier(BuildContext context)async{
    await FirebaseAuth.instance.currentUser().then((FirebaseUser user)async{
      if(user == null){
        // Redirect to Sign In Page
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>AuthUIPage()));
      }else{
        print("Signed in Successfully! - "+user.uid);
        
        userProfileCheck(context, user);
      }
    }).catchError((e){
      print(e);
      CustomAlertBox().load(context, "Error", e.message);
    });
  }

  Future<void> businessProfileCheck(BuildContext context, FirebaseUser user)async{
    await Firestore.instance.collection("businesses").document(user.uid).get().then((DocumentSnapshot docData){
      if(docData.data != null){
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>HomePage()));
      }else{
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>CompleteBusinessProfile()));
      }
    }).catchError((e){
      print(e);
      CustomAlertBox().load(context, "Error", e.message);
    });
  }

  Future<void> userProfileCheck(BuildContext context, FirebaseUser user)async{
    await Firestore.instance.collection("businessUsers").document(user.uid).get().then((DocumentSnapshot docData){
      if(docData.data != null){
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>HomePage()));
      }else{
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>CompleteYourProfilePage()));
      }
    }).catchError((e){
      print(e);
      CustomAlertBox().load(context, "Error", e.message);
    });
  }

    Future<void> createUserProfile(BuildContext context, String name, DateTime dob, String profileImgUrl, String emailId)async{
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    await Firestore.instance.collection("businessUsers").document(user.uid).setData({
      "userLegalName": name,
      "userDateOfBirth": dob,
      "userProfileImage": profileImgUrl,
      "userId": user.uid,
      "userEmailId": emailId,
      "userContactNum": user.phoneNumber,
      "accountCreatedOn": FieldValue.serverTimestamp()
    }).catchError((e){
      print(e);
      CustomAlertBox().load(context, "Error", e.message);
    });
  }
  




  Future<void> addBusinessProfile(BuildContext context, FirebaseUser user, String title, String email, String businessLogoImgUrl, String shortDes)async{

    
    LocData locData = await GetLocation().fetch(context);

    print(locData.address);


    await Firestore.instance.collection("businesses").document(user.uid).setData({
      "businessId": user.uid,
      "businessTitle": title,
      "email": email,
      "mobileNumber": user.phoneNumber,
      "addressName": locData.address[0].name,
      "addressLocality": locData.address[0].locality,
      "addressSubAdministrativeArea": locData.address[0].subAdministrativeArea,
      "addressAdministrativeArea": locData.address[0].administrativeArea,
      "addressCountry": locData.address[0].country,
      "addressPincode": locData.address[0].postalCode,
      "latitude": locData.lat,
      "longitude": locData.long,
      "businessLogo": businessLogoImgUrl,
      "businessShortDescription": shortDes,
      "accountVerified": true //We need to set this fasle later...
    }).then((E){
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>HomePage()));
    }).catchError((e){
      print(e);
      CustomAlertBox().load(context, "Error", e.message);
    });
  }

}