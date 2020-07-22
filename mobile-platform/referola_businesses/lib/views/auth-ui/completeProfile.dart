import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:referola_businesses/logic/auth/accountFun.dart';
import 'package:referola_businesses/logic/dateTimeFormatter/timeStampToDate.dart';
import 'package:referola_businesses/ui-components/buttons/customAlertBox.dart';
import 'package:referola_businesses/ui-components/buttons/longButton.dart';
import 'package:referola_businesses/ui-components/buttons/primaryButton.dart';
import 'package:referola_businesses/ui-components/uploadToStorage/uploadFile.dart';
import 'package:referola_businesses/views/myBusinesses/myBusinesses.dart';

class CompleteYourProfilePage extends StatefulWidget {
  @override
  _CompleteYourProfilePageState createState() => _CompleteYourProfilePageState();
}

class _CompleteYourProfilePageState extends State<CompleteYourProfilePage> {

  bool isLoading = false;

  String legalName, profileImageUrl, emailId, phoneNum;
  DateTime dateOfBirth; 

  bool profileImageUploading = false;

  FirebaseUser user;

  final formKey1 = GlobalKey<FormState>();
  final formKey2 = GlobalKey<FormState>();

  final PageController pageController = PageController();

  onLoadActivity()async{
    setState(() {
      isLoading = true;
    });
    user = await FirebaseAuth.instance.currentUser();
    setState(() {
      isLoading = false;
    });
  }

  setUserProfile()async{
    setState(() {
      isLoading = true;
    });
    await AccountFun().createUserProfile(context, legalName, dateOfBirth, profileImageUrl, emailId).then((E){
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>MyBusinesses()));
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
                            final StorageReference storageReference = FirebaseStorage().ref().child("businessUsers/profileImages/"+user.uid);
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
                            radius: 50.0,
                            child: Icon(Icons.add_a_photo),
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
                      Text("Enter your Name", style: TextStyle(
                        fontFamily: "Nunito Sans Bold"
                      ),),
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
                        decoration: InputDecoration(
                          labelText: "Full Name",
                          hintText: "Ex : John"
                        ),
                      ),
                      SizedBox(
                        height: 30.0,
                      ),
                      Text("Select your Date of Birth", style: TextStyle(
                        fontFamily: "Nunito Sans Bold"
                      ),),
                      SizedBox(
                        height: 5.0,
                      ),
                      PrimaryButton().loadButton(context, dateOfBirth == null ? "Select your Date of Birth" : TimestampConvertor().organizeDate(dateOfBirth), (){
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
                        height: 30.0,
                      ),
                      Text("Enter your EmailId", style: TextStyle(
                        fontFamily: "Nunito Sans Bold"
                      ),),
                      TextFormField(
                        validator: (String val){
                          if(!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(val.trim())){
                            return "Enter valid Email Address";
                          }
                          return null;
                        },
                        onSaved: (String val){
                          setState(() {
                            emailId = val.trim();
                          });
                        },
                        decoration: InputDecoration(
                          labelText: "Email Id",
                          hintText: "Ex : name@example.com"
                        ),
                      ),
                      SizedBox(
                        height: 30.0,
                      ),
                      Text("Mobile Number", style: TextStyle(
                        fontFamily: "Nunito Sans Bold"
                      ),),
                      TextFormField(
                        
                        initialValue: user.phoneNumber,
                        enabled: false,
                        decoration: InputDecoration(
                          labelText: "Mobile Number",
                          
                        ),
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