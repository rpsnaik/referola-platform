import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:referola/logic/dateTimeFormatter/timeStampToDate.dart';
import 'package:referola/logic/getLocation/fetchLocationInfo.dart';
import 'package:referola/ui-components/Forms/inputDecoration.dart';
import 'package:referola/ui-components/uploadToStorage/uploadFile.dart';
import '../../logic/auth/accountFun.dart';
import '../../ui-components/buttons/customAlertBox.dart';
import '../../ui-components/buttons/longButton.dart';
import '../homePage/homePage.dart';

class CompleteYourProfilePage extends StatefulWidget {
  @override
  _CompleteYourProfilePageState createState() => _CompleteYourProfilePageState();
}

class _CompleteYourProfilePageState extends State<CompleteYourProfilePage> {

  bool isLoading = false;

  String legalName, profileImageUrl, phoneNum;
  DateTime dateOfBirth;
  LocData locData; 

  bool profileImageUploading = false;

  FirebaseUser user;

  final formKey1 = GlobalKey<FormState>();

  onLoadActivity()async{
    setState(() {
      isLoading = true;
    });
    user = await FirebaseAuth.instance.currentUser();
    LocationLogic locationLogic = LocationLogic();
                        
    if(await locationLogic.verifyPermission()){
      print("Permission Granted");

    }else{
      print("Location Required!");
      CustomAlertBox().load(context, "Location Required!", "Please enable location permission!");
    }
    locData = await GetLocation().fetch(context);
    setState(() {
      isLoading = false;
    });
  }

  setUserProfile()async{
    setState(() {
      isLoading = true;
    });
    await AccountFun().createUserProfile(context, user, legalName, profileImageUrl,dateOfBirth).then((E){
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>HomePage()));
    }).catchError((e){  
      print(e);
      CustomAlertBox().load(context, "Error", e.message);
    });
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    onLoadActivity();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: Text("Complete your Profile", style: TextStyle(
          fontFamily: "Nunito Sans Bold"
        ),),
      ),
      body: isLoading ? Center(
        child: CircularProgressIndicator(),
      ) : Container(
      child: ListView(
            children: [
              Container(
                padding: EdgeInsets.all(20.0),
                child: Form(
                  key: formKey1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 10.0,
                      ),
                      Center(
                        child: InkWell(
                          onTap: ()async{
                            final StorageReference storageReference = FirebaseStorage().ref().child("users/profileImages/"+user.uid);
                            setState(() {
                              profileImageUploading = true;
                            });
                            await FirebaseStorageUploadTask().uploadTaskImage(context, storageReference).then((String imgUrl){
                              profileImageUrl = imgUrl;
                              setState(() {
                                
                              });
                            }).catchError((e){
                              print(e);
                              CustomAlertBox().load(context, "Error", e.message);
                            });
                            setState(() {
                              profileImageUploading = false;
                            });
                          },
                          child: profileImageUrl == null ? CircleAvatar(
                            backgroundColor: Colors.blueGrey,
                            radius: 50.0,
                            child: Icon(Icons.add_a_photo, color: Colors.white,),
                          ) : CircleAvatar(
                            radius: 50.0,
                            backgroundImage: CachedNetworkImageProvider(
                              profileImageUrl
                            ),
                            
                          ),
                        )
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Row(
                        children: [
                          Icon(Icons.person, color: Colors.blueGrey,),
                          SizedBox(
                            width: 5,
                          ),
                          Text("Enter your Name", style: TextStyle(
                            fontFamily: "Nunito Sans Bold"
                          ),),
                        ],
                      ),
                       SizedBox(
                        height: 5.0,
                      ),
                      TextFormField(
                        validator: (String val){
                          if(val.length < 3){
                            return "Enter valid Name";
                          }
                          return null;
                        },
                        onSaved: (String val){
                          setState(() {
                            legalName = val.trim();
                          });
                        },
                        decoration: textInputDecoration.copyWith(
                          hintText: "Ex : Richard Hendriks",
                        )
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      Row(
                        children: [
                          Icon(FontAwesomeIcons.babyCarriage, color: Colors.blueGrey, size: 20,),
                          SizedBox(
                            width: 5,
                          ),
                          Text("Select your Date of Birth", style: TextStyle(
                            fontFamily: "Nunito Sans Bold"
                          ),),
                        ],
                      ),
                      SizedBox(
                        height: 5.0,
                      ),
                      CustomLongButton().loadButton(context, dateOfBirth == null ? "Select your Date of Birth" : TimestampConvertor().organizeDate(dateOfBirth), (){
                        showDatePicker(
                          context: context,
                          initialDate: DateTime.now().subtract(Duration(days: 2500)),
                          firstDate: DateTime(1920),
                          lastDate: DateTime.now().subtract(Duration(days: 2500))
                        ).then((DateTime dateTime){
                          setState(() {
                            dateOfBirth = dateTime;
                          });
                        });
                      }),
                      SizedBox(
                        height: 20.0,
                      ),
                      Row(
                        children: [
                          Icon(Icons.mail, color: Colors.blueGrey,),
                          SizedBox(
                            width: 5,
                          ),
                          Text("Enter your EmailId", style: TextStyle(
                            fontFamily: "Nunito Sans Bold"
                          ),),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      TextFormField(
                        // validator: (String val){
                        //   if(!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(val.trim())){
                        //     return "Enter valid Email Address";
                        //   }
                        //   return null;
                        // },
                        enabled: false,
                        initialValue: user.email,
                        decoration: textInputDecoration
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                        Row(
                        children: [
                          Icon(Icons.location_on, color: Colors.blueGrey,),
                          SizedBox(
                            width: 5,
                          ),
                          Text("Address Line", style: TextStyle(
                            fontFamily: "Nunito Sans Bold"
                          ),),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                       TextFormField(
                        // validator: (String val){
                        //   if(!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(val.trim())){
                        //     return "Enter valid Email Address";
                        //   }
                        //   return null;
                        // },
                       enabled: false,
                        initialValue: locData.address[0].name,
                        decoration: textInputDecoration
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                        Row(
                        children: [
                          Icon(Icons.mail, color: Colors.blueGrey,),
                          SizedBox(
                            width: 5,
                          ),
                          Text("EmailId", style: TextStyle(
                            fontFamily: "Nunito Sans Bold"
                          ),),
                        ],
                      ),
                      SizedBox(height: 5,),
                       TextFormField(
                        // validator: (String val){
                        //   if(!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(val.trim())){
                        //     return "Enter valid Email Address";
                        //   }
                        //   return null;
                        // },
                         enabled: false,
                        initialValue: locData.address[0].locality,
                        decoration: textInputDecoration
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                        Row(
                        children: [
                          Icon(Icons.location_city, color: Colors.blueGrey,),
                          SizedBox(
                            width: 5,
                          ),
                          Text("subAdministrativeArea", style: TextStyle(
                            fontFamily: "Nunito Sans Bold"
                          ),),
                        ],
                      ),
                      SizedBox(height: 5,),
                       TextFormField(
                        // validator: (String val){
                        //   if(!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(val.trim())){
                        //     return "Enter valid Email Address";
                        //   }
                        //   return null;
                        // },
                        enabled: false,
                        initialValue: locData.address[0].subAdministrativeArea,
                        decoration: textInputDecoration
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                        Row(
                        children: [
                          Icon(Icons.local_activity, color: Colors.blueGrey,),
                          SizedBox(
                            width: 5,
                          ),
                          Text("Adminstrative area", style: TextStyle(
                            fontFamily: "Nunito Sans Bold"
                          ),),
                        ],
                      ),
                      SizedBox(height: 5,),
                       TextFormField(
                        // validator: (String val){
                        //   if(!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(val.trim())){
                        //     return "Enter valid Email Address";
                        //   }
                        //   return null;
                        // },
                        enabled: false,
                        initialValue: locData.address[0].administrativeArea,
                        decoration:textInputDecoration
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                        Row(
                        children: [
                          Icon(Icons.location_searching, color: Colors.blueGrey,),
                          SizedBox(
                            width: 5,
                          ),
                          Text("Country", style: TextStyle(
                            fontFamily: "Nunito Sans Bold"
                          ),),
                        ],
                      ),
                      SizedBox(height: 5,),
                       TextFormField(
                        // validator: (String val){
                        //   if(!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(val.trim())){
                        //     return "Enter valid Email Address";
                        //   }
                        //   return null;
                        // },
                        enabled: false,
                        initialValue: locData.address[0].country,
                        decoration:textInputDecoration
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                        Row(
                        children: [
                          Icon(FontAwesomeIcons.locationArrow, color: Colors.blueGrey, size: 20,),
                          SizedBox(
                            width: 5,
                          ),
                          Text("Zip code", style: TextStyle(
                            fontFamily: "Nunito Sans Bold"
                          ),),
                        ],
                      ),
                      SizedBox(height: 5,),
                       TextFormField(
                        // validator: (String val){
                        //   if(!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(val.trim())){
                        //     return "Enter valid Email Address";
                        //   }
                        //   return null;
                        // },
                        enabled: false,
                        initialValue: locData.address[0].postalCode,
                        decoration: textInputDecoration
                      ),
                      SizedBox(
                        height: 30.0,
                      ),
                      CustomLongButton().loadButton(context, "Finish", (){
                        if(formKey1.currentState.validate()){
                          if(dateOfBirth != null){
                            formKey1.currentState.save();
                            setUserProfile();
                          }else{
                            CustomAlertBox().load(context, "Select Date of Birth", "Please Select your Date your Date of birth!");
                          }
                        }
                      })
                      
                    ],
                  ),
                )
              )
            ],
          ),
      ),
    );
  }
}