import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:referola_businesses/logic/indexesBuilder/indexBuilder.dart';
import 'package:referola_businesses/ui-components/buttons/customAlertBox.dart';
import 'package:referola_businesses/ui-components/buttons/longButton.dart';
import 'package:referola_businesses/ui-components/buttons/primaryButton.dart';
import 'package:referola_businesses/ui-components/forms/textInputDecoration.dart';
import 'package:referola_businesses/ui-components/uploadToStorage/uploadFile.dart';

class AddCampaign extends StatefulWidget {
  final DocumentSnapshot businessData;
  AddCampaign({this.businessData});
  @override
  _AddCampaignState createState() => _AddCampaignState();
}

class _AddCampaignState extends State<AddCampaign> {
  final formKey = GlobalKey<FormState>();
  String campaignTitle, campaignSubTitle, campaignDes;
  String bannerImgUrl;
  File croppedImage;
  bool publishingBanner = false;

  DocumentReference campaignRef = Firestore.instance.collection("campaigns").document();

  List packages = [];

  bool isUploadingBanner = false;



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("New Campaign", style: TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.bold
        ),),
      ),
      body: Form(
        key: formKey,
        child: ListView(
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text("New Campaign", style: TextStyle(
                    fontSize: 25.0,
                    fontWeight: FontWeight.bold
                  ),),
                  SizedBox(
                    height: 20.0,
                  ),
                  
                  Text("Campaign Banner", style: TextStyle(
                    fontWeight: FontWeight.bold
                  ),),
                  SizedBox(
                    height: 15.0,
                  ),

                  InkWell(
                    onTap: ()async{
                      await ImagePicker().getImage(
                        source: ImageSource.gallery,
                        imageQuality: 30
                      ).then((PickedFile imageFile)async{
                        await ImageCropper.cropImage(
                          sourcePath: imageFile.path,
                          
                          aspectRatioPresets: [
                            CropAspectRatioPreset.ratio4x3,
                          ],
                          androidUiSettings: AndroidUiSettings(
                              toolbarTitle: 'Crop Banner',
                              toolbarColor: Colors.deepOrange,
                              toolbarWidgetColor: Colors.white,
                              initAspectRatio: CropAspectRatioPreset.original,
                              showCropGrid: true,
                              lockAspectRatio: true),
                          iosUiSettings: IOSUiSettings(
                            minimumAspectRatio: 1.0,
                            aspectRatioLockDimensionSwapEnabled: false,
                            aspectRatioLockEnabled: true
                          )
                        ).then((File cropImg)async{
                          setState(() {
                            isUploadingBanner = true;
                          });
                          StorageReference storageRef = FirebaseStorage().ref().child("campaignBannerImgs/"+campaignRef.documentID);
                          setState(() {
                            croppedImage = cropImg;
                          });
                          bannerImgUrl = await FirebaseStorageUploadTask().uploadBannerImage(context, storageRef, cropImg);
                          setState(() {
                            isUploadingBanner = false;
                          });
                          
                        }).catchError((e){
                          print(e);
                          CustomAlertBox().load(context, "Error", e.toString());
                        });
                      }).catchError((e){
                        print(e);
                        CustomAlertBox().load(context, "Error", e.toString());
                      });
                      
                    },
                    child: Container(
                      
                      height: MediaQuery.of(context).size.height*0.3,
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey,
                            blurRadius: 2.0,
                            spreadRadius: 2.0
                          )
                        ],
                        color: Colors.grey[200],
                        image: croppedImage == null ? null : DecorationImage(
                          image: FileImage(croppedImage),
                          fit: BoxFit.fitWidth
                        )
                      ),
                      child: Container(
                        child: Center(
                          child: Icon(Icons.image),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(
                    height: 20.0,
                  ),

                  isUploadingBanner ? Text("Banner Image Uploading...") : Container(),

                  SizedBox(
                    height: 20.0,
                  ),

                  Text("Campaign Title", style: TextStyle(
                    fontWeight: FontWeight.bold
                  ),),
                  SizedBox(
                    height: 10.0,
                  ),
                  TextFormField(
                    validator: (String val){
                      if(val.trim().length < 2){
                        return "Enter valid Title";
                      }
                      return null;
                    },
                    onSaved: (String val){
                      setState(() {
                        campaignTitle = val;
                      });
                    },
                    decoration: textInputDecoration,
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Text("Campaign Sub title", style: TextStyle(
                    fontWeight: FontWeight.bold
                  ),),
                  SizedBox(
                    height: 10.0,
                  ),
                  TextFormField(
                    validator: (String val){
                      if(val.trim().length < 2){
                        return "Enter valid SubTitle";
                      }
                      return null;
                    },
                    onSaved: (String val){
                      setState(() {
                        campaignSubTitle = val;
                      });
                    },
                    decoration: textInputDecoration,
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Text("Campaign Description", style: TextStyle(
                    fontWeight: FontWeight.bold
                  ),),
                  SizedBox(
                    height: 10.0,
                  ),
                  TextFormField(
                    maxLength: 300,
                    validator: (String val){
                      if(val.trim().length < 30 && val.trim().length > 300){
                        return "Description must be atleast 30 charecters";
                      }
                      return null;
                    },
                    onSaved: (String val){
                      setState(() {
                        campaignDes = val;
                      });
                    },
                    maxLines: 4,
                    decoration: textInputDecoration,
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Text("Packages", style: TextStyle(
                    fontWeight: FontWeight.bold
                  ),),
                  SizedBox(
                    height: 10.0,
                  ),

                  ListView.builder(
                    primary: false,
                    shrinkWrap: true,
                    itemCount: packages.length+1,
                    itemBuilder: (context, i){
                      if(i == packages.length){
                        return ListTile(
                          leading: Icon(Icons.add),
                          onTap: (){
                            final packageKey = GlobalKey<FormState>();
                            String packageTitle;
                            double cost = 0, discount = 0, rewardedEarningPercentage = 0;
                            showDialog(
                              context: context,
                              builder: (context){
                                return StatefulBuilder(
                                  builder: (context, setState2){
                                    return Scaffold(
                                      appBar: AppBar(
                                        title: Text("Package Details", style: TextStyle(
                                          fontWeight: FontWeight.bold
                                        ),),
                                      ),
                                      body: Form(
                                        key: packageKey,
                                        child: ListView(
                                          children: <Widget>[
                                            Container(
                                              padding: EdgeInsets.all(20.0),
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Text("Add Package Details", style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 25.0
                                                  ),),
                                                  SizedBox(
                                                    height: 10.0,
                                                  ),
                                                  Text("Title", style: TextStyle(
                                                    fontWeight: FontWeight.bold
                                                  ),),
                                                  SizedBox(
                                                    height: 5.0,
                                                  ),
                                                  TextFormField(
                                                    validator: (String val){
                                                      if(val.trim().length < 2){
                                                        return "Enter valid Package Name";
                                                      }
                                                      return null;
                                                    },
                                                    onSaved: (String val){
                                                      setState2((){
                                                        packageTitle = val.trim();
                                                      });
                                                    },
                                                    decoration: textInputDecoration,
                                                  ),
                                                  SizedBox(
                                                    height: 20.0,
                                                  ),
                                                  SizedBox(
                                                    height: 10.0,
                                                  ),
                                                  Text("Actual Cost", style: TextStyle(
                                                    fontWeight: FontWeight.bold
                                                  ),),
                                                  SizedBox(
                                                    height: 5.0,
                                                  ),
                                                  TextFormField(
                                                    validator: (String val){
                                                      if(double.parse(val) <= 0){
                                                        return "Invalid Amount!";
                                                      }
                                                      return null;
                                                    },
                                                    onChanged: (String val){
                                                      setState2((){
                                                        cost = double.parse(val);
                                                      });
                                                    },
                                                    onSaved: (String val){
                                                      setState2((){
                                                        cost = double.parse(val);
                                                      });
                                                    },
                                                    keyboardType: TextInputType.number,
                                                    decoration: textInputDecoration,
                                                  ),
                                                  SizedBox(
                                                    height: 20.0,
                                                  ),
                                                  SizedBox(
                                                    height: 10.0,
                                                  ),
                                                  Text("Discount", style: TextStyle(
                                                    fontWeight: FontWeight.bold
                                                  ),),
                                                  SizedBox(
                                                    height: 5.0,
                                                  ),
                                                  TextFormField(
                                                    validator: (String val){
                                                      if(double.parse(val) <= 0){
                                                        return "You need to provide minimum discount!";
                                                      }
                                                      return null;
                                                    },
                                                    onChanged: (String val){
                                                      setState2((){
                                                        discount = double.parse(val);
                                                      });
                                                    },
                                                    onSaved: (String val){
                                                      setState2((){
                                                        discount = double.parse(val);
                                                      });
                                                    },
                                                    keyboardType: TextInputType.number,
                                                    decoration: textInputDecoration,
                                                  ),
                                                  SizedBox(
                                                    height: 20.0,
                                                  ),
                                                  SizedBox(
                                                    height: 10.0,
                                                  ),
                                                  Text("Rewarded Earning Percentage", style: TextStyle(
                                                    fontWeight: FontWeight.bold
                                                  ),),
                                                  SizedBox(
                                                    height: 5.0,
                                                  ),
                                                  TextFormField(
                                                    validator: (String val){
                                                      if(double.parse(val) <= 0){
                                                        return "You need to provide minimum rewarded amount!";
                                                      }
                                                      return null;
                                                    },
                                                    onChanged: (String val){
                                                      setState2((){
                                                        rewardedEarningPercentage = double.parse(val);
                                                      });
                                                    },
                                                    onSaved: (String val){
                                                      setState2((){
                                                        rewardedEarningPercentage = double.parse(val);
                                                      });
                                                    },
                                                    keyboardType: TextInputType.number,
                                                    decoration: textInputDecoration,
                                                  ),
                                                  SizedBox(
                                                    height: 20.0,
                                                  ),

                                                  Text("Detailed Price Info", style: TextStyle(
                                                    fontSize: 17.0,
                                                    fontWeight: FontWeight.bold
                                                  ),),
                                                  SizedBox(
                                                    height: 10.0,
                                                  ),
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    children: <Widget>[
                                                      Text("Actual Price"),
                                                      Text(cost.toString())
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: 5.0,
                                                  ),
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    children: <Widget>[
                                                      Text("Price you will recieve after Discount"),
                                                      Text( (cost - (cost*discount)/100).toString() )
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: 5.0,
                                                  ),
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    children: <Widget>[
                                                      Text("Price you will recieve on referral"),
                                                      Text( ((cost - (cost*discount)/100) - ((cost*rewardedEarningPercentage)/100)) .toString())
                                                    ],
                                                  ),


                                                  SizedBox(
                                                    height: 20.0,
                                                  ),



                                                  PrimaryButton().loadButton(context, "Save Package", (){
                                                    try{
                                                      if(packageKey.currentState.validate()){
                                                        packageKey.currentState.save();
                                                        setState(() {
                                                          packages.add({
                                                            "packageTitle": packageTitle,
                                                            "packageAmount": cost,
                                                            "packageDiscount": discount,
                                                            "packageRewardPercentage": rewardedEarningPercentage
                                                          });
                                                          Navigator.pop(context);
                                                        });
                                                      }
                                                    }catch(e){
                                                      print(e);
                                                      CustomAlertBox().load(context, "Error", e.message);
                                                    }
                                                  }),



                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      )
                                    );
                                  }
                                );
                              }
                            );
                          },
                          title: Text("Add Package"),
                        );
                      }
                      return Container(
                        padding: EdgeInsets.all(10.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[ 
                            Text(packages[i]['packageTitle']),
                            Text(packages[i]['packageAmount'].toString()),
                            Text(packages[i]['packageDiscount'].toString()),
                            Text(packages[i]['packageRewardPercentage'].toString())
                          ],
                        ),
                      );
                    }
                  ),

                  SizedBox(
                    height: 20.0,
                  ),

                  publishingBanner ? Center(
                    child: CircularProgressIndicator(),
                  ) : CustomLongButton().loadButton(context, "Publish", ()async{
                    setState(() {
                      publishingBanner = true;
                    });
                    if(formKey.currentState.validate()){
                      formKey.currentState.save();
                      if(packages.length > 0){
                        if(bannerImgUrl != null){
                          List searchIndexes = IndexBuilder().build(campaignTitle);
                          await campaignRef.setData({
                            "campainId": campaignRef.documentID,
                            "campainStatus": true,
                            "campainTitle": campaignTitle,
                            "campainSubTitle": campaignSubTitle,
                            "campainDescription": campaignDes,
                            "campainBannerImgUrl": bannerImgUrl,
                            "campainCreatedOn": Timestamp.now(),
                            "camapinUpdatedOn": Timestamp.now(),
                            "categories": [],
                            "ratingTotal": 0,
                            "ratingCount": 0,
                            "packages": packages,
                            "searchIndexes": searchIndexes
                          }).then((E){
                            Navigator.pop(context);
                          }).catchError((e){
                            print(e);
                            setState(() {
                              publishingBanner = false;
                            });
                            CustomAlertBox().load(context, "Error", e.message);
                          });
                        }else{
                          setState(() {
                            publishingBanner = false;
                          });
                          CustomAlertBox().load(context, "Select Banner Image", "Please attach a banner image!");
                        }
                      }else{
                        setState(() {
                          publishingBanner = false;
                        });
                        CustomAlertBox().load(context, "Empty Packages!", "You need to have a minimum of one package!");
                      }
                    }
                    setState(() {
                      publishingBanner = false;
                    });
                  })




                ],
              ),
            )
          ],
        ),
      )
    );
  }
}