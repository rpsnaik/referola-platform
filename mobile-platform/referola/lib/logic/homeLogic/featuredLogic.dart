import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:referola/ui-components/buttons/customAlertBox.dart';

class FeaturedLoadLogic{
  List<DocumentSnapshot> data = [];

  Future<void> loadData(BuildContext context)async{
    if(data.length < 8){
      await Firestore.instance.collection("campaigns").orderBy("currRating", descending: true).limit(15).getDocuments().then((QuerySnapshot querySnapshot){
        print("Got Docs");
        data = querySnapshot.documents;
      }).catchError((e){
        print(e);
        CustomAlertBox().load(context, 'Error', e.message);
      });
    }
  }

  Future<void> loadMoreData(BuildContext context)async{
    await Firestore.instance.collection("campaigns").orderBy("currRating", descending: true).startAfterDocument(data[data.length-1]).limit(15).getDocuments().then((QuerySnapshot querySnapshot){
      data.addAll(querySnapshot.documents);
    }).catchError((e){
      print(e);
      CustomAlertBox().load(context, 'Error', e.message);
    });
  }

}