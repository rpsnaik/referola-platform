import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:referola_businesses/logic/getLocation/fetchLocationinfo.dart';
import 'package:referola_businesses/ui-components/buttons/customAlertBox.dart';
import 'package:referola_businesses/views/auth-ui/authUiPage.dart';
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
        businessProfileCheck(context, user);
        //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>HomePage()));
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
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>CompleteYourProfilePage()));
      }
    }).catchError((e){
      print(e);
      CustomAlertBox().load(context, "Error", e.message);
    });
  }

  Future<void> addBusinessProfile(BuildContext context, FirebaseUser user, String title, String email, String businessLogoImgUrl, String shortDes)async{
    await user.updateEmail(email);
    await user.reload();

    
    LocData locData = await GetLocation().fetch(context);
    Position position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    final coordinates = new Coordinates(position.latitude, position.longitude);
    var addresses = await Geocoder.local.findAddressesFromCoordinates(coordinates);
    var first = addresses.first;
    await Firestore.instance.collection("businesses").document(user.uid).setData({
      "businessId": user.uid,
      "businessTitle": title,
      "email": email,
      "mobileNumber": user.phoneNumber,
      "addressLine1": first.addressLine,
      "addressCity": first.subAdminArea,
      "addressState": first.adminArea,
      "addressCountry": first.countryName,
      "addressPincode": first.postalCode,
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