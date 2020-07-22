import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:referola_businesses/logic/getLocation/fetchLocationinfo.dart';
import 'package:referola_businesses/ui-components/buttons/customAlertBox.dart';
import 'package:referola_businesses/views/auth-ui/authUiPage.dart';
import 'package:referola_businesses/views/auth-ui/completeProfile.dart';
import 'package:referola_businesses/views/myBusinesses/myBusinesses.dart';




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

  Future<void> userProfileCheck(BuildContext context, FirebaseUser user)async{
    await Firestore.instance.collection("businessUsers").document(user.uid).get().then((DocumentSnapshot docData){
      if(docData.data != null){
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>MyBusinesses()));
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
      "name": name,
      "dateOfBirth": dob,
      "profileImageUrl": profileImgUrl,
      "uid": user.uid,
      "emailId": emailId,
      "contactNum": user.phoneNumber,
      "accountCreatedOn": Timestamp.now(),

      "accountDisabled": false
    }).catchError((e){
      print(e);
      CustomAlertBox().load(context, "Error", e.message);
    });
  }




  
}


class BusinessesFun{
  List<DocumentSnapshot> businesses = [];
  
  Future<void> loadBusinesses(BuildContext context)async{
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    await Firestore.instance.collection("businesses").where("businessOwnerId", isEqualTo: user.uid).orderBy("businessCreatedOn", descending: false).limit(20).getDocuments().then((QuerySnapshot qSanpData){
      businesses = qSanpData.documents;
    }).catchError((e){
      print(e);
      CustomAlertBox().load(context, "Error", e.message);
    });
  }


  Future<void> loadMoreBusinesses(BuildContext context)async{
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    await Firestore.instance.collection("businesses").where("businessOwnerId", isEqualTo: user.uid).orderBy("businessCreatedOn", descending: false).startAfterDocument(businesses[businesses.length-1]).limit(20).getDocuments().then((QuerySnapshot qSanpData){
      businesses.addAll(qSanpData.documents);
    }).catchError((e){
      print(e);
      CustomAlertBox().load(context, "Error", e.message);
    });
  }


  Future<void> addBusinessProfile(BuildContext context, FirebaseUser user, String title, String email, String businessProfileImgUrl, String businessBannerImgUrl, String shortDes, TimeOfDay startTime, TimeOfDay endTime, List holidays)async{

    
    LocData locData = await GetLocation().fetch(context);

    print(locData.address);

    DocumentReference businessRef = Firestore.instance.collection("businesses").document();
    await businessRef.setData({
      "businessDisabled": false,
      
      "businessId": businessRef.documentID,
      "businessTitle": title,
      "businessShortDescription": shortDes,
      "businessEmailId": email,
      "businessContactNumber": user.phoneNumber,
      "businessProfileImgUrl": businessProfileImgUrl,
      "businessBannerImgUrl": businessBannerImgUrl,
      "addressName": locData.address[0].name,
      "addressLocality": locData.address[0].locality,
      "addressSubAdministrativeArea": locData.address[0].subAdministrativeArea,
      "addressAdministrativeArea": locData.address[0].administrativeArea,
      "addressCountry": locData.address[0].country,
      "addressPincode": locData.address[0].postalCode,
      "latitude": locData.lat,
      "longitude": locData.long,

      "businessStartTime": startTime.format(context),
      "businessCloseTime": endTime.format(context),
      "businessHolidaysOn": holidays,

      "businessOwnerId": user.uid,
      "businessCreatedOn": Timestamp.now(),

      "wallet": 0
    }).then((E){
      print("Added Successfully!");
    }).catchError((e){
      print(e);
      CustomAlertBox().load(context, "Error", e.message);
    });
  }

}


class CampainFun {
  List<DocumentSnapshot> campains = [];
   Future<void> addCampains(BuildContext context, FirebaseUser user, String title, String subTitle, String desc, String campainBannerImgUrl,int ratCount )async{

    

    DocumentReference campainRef = Firestore.instance.collection("campains").document();
    await campainRef.setData({
      "campainId": campainRef.documentID,
      "campainStatus": true,
      "campainTitle": title,
      "campainSubTitle": subTitle,
      "campainDescription": desc,
      "campainBannerImgUrl": campainBannerImgUrl,
      "campainCreatedOn": Timestamp.now(),
      "camapinUpdatedOn": Timestamp.now(),
      "categories": [],
      "ratingTotal": 5,
      "ratingCount": ratCount,
      "packages": [
        {
            "packageTitle": "2 Implamtations",
            "packageAmount": 200,
            "packageDiscount": 20,
            "packageRewardDiscount": 3
        },
        {
            "packageTitle": "4 Implamtations",
            "packageAmount": 320,
            "packageDiscount": 20,
            "packageRewardDiscount": 7
        }
            ]

    }).then((E){
      print("Added Successfully!");
    }).catchError((e){
      print(e);
      CustomAlertBox().load(context, "Error", e.message);
    });
  }

  
    Future<void> loadCampains(BuildContext context)async{
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    await Firestore.instance.collection("campains").where("campainId", isEqualTo: user.uid).orderBy("campainCreatedOn", descending: false).limit(20).getDocuments().then((QuerySnapshot qSanpData){
      campains = qSanpData.documents;
    }).catchError((e){
      print(e);
      CustomAlertBox().load(context, "Error", e.message);
    });
  }


  Future<void> loadMoreCampains(BuildContext context)async{
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    await Firestore.instance.collection("campains").where("campainId", isEqualTo: user.uid).orderBy("campainCreatedOn", descending: false).startAfterDocument(campains[campains.length-1]).limit(20).getDocuments().then((QuerySnapshot qSanpData){
      campains.addAll(qSanpData.documents);
    }).catchError((e){
      print(e);
      CustomAlertBox().load(context, "Error", e.message);
    });
  }

}