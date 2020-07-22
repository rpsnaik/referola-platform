import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:referola_businesses/logic/auth/accountFun.dart';
import 'package:referola_businesses/ui-components/buttons/customAlertBox.dart';
import '../../../../logic/auth/accountFun.dart';
import '../../../../ui-components/Forms/textInputDecoration.dart';
import '../../../../ui-components/buttons/longButton.dart';
import '../../../../ui-components/uploadToStorage/uploadFile.dart';

class AddCampains extends StatefulWidget {
  @override
  _AddCampainsState createState() =>
      _AddCampainsState();
}

class _AddCampainsState extends State<AddCampains> {
  bool loading = false;

  String title, email, desc, subTitle, campainBannerImgUrl;
  int ratCount;

  bool profileImageUploading = false;

  FirebaseUser user;

  final formKey = GlobalKey<FormState>();

  TimeOfDay startTime, closeTime;
  List holidays = [];


  onLoad() async {
    setState(() {
      loading = true;
    });
    user = await FirebaseAuth.instance.currentUser();
    setState(() {
      loading = false;
    });
  }

  setCampain() async {
    setState(() {
      loading = true;
    });
    await CampainFun().addCampains(context, user, title, subTitle, desc, campainBannerImgUrl, ratCount).then((E){
      setState(() {
        
      });
      Navigator.pop(context);
    }).catchError((e){
      print(e);
      CustomAlertBox().load(context, "Error", e.message);
    });
    setState(() {
      loading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    onLoad();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Theme.of(context).primaryColor,
        title: Text(
          "Create a Campain",
        ),
      ),
      body: loading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView(
              children: <Widget>[
                Form(
                  key: formKey,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                                              Center(
                        child: InkWell(
                          onTap: ()async{
                            final StorageReference storageReference = FirebaseStorage().ref().child("campains/BannerImage/"+user.uid);
                            setState(() {
                              profileImageUploading = true;
                            });
                            await FirebaseStorageUploadTask().uploadTaskImage(context, storageReference).then((String imgUrl){
                              campainBannerImgUrl = imgUrl;
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
                          child: campainBannerImgUrl== null ? CircleAvatar(
                            radius: 50.0,
                            child: Icon(Icons.add_a_photo),
                          ) : CircleAvatar(
                            radius: 50.0,
                            backgroundImage: CachedNetworkImageProvider(
                              campainBannerImgUrl
                            ),
                            
                          ),
                        )
                      ),
                        Text("Title"),
                        TextFormField(
                          validator: (String val) {
                            if (val.length < 3) {
                              return "Enter a valid name";
                            }
                            return null;
                          },
                          onSaved: (String val) {
                            setState(() {
                              title = val.trim();
                            });
                          },
                          decoration: textInputDecoration.copyWith(
                            hintText: "Ex : Campain"
                          ),
                        ),
                        Text("Sub Title"),
                        TextFormField(
                          validator: (String val) {
                            if (val.length < 3) {
                              return "Enter a valid name";
                            }
                            return null;
                          },
                          onSaved: (String val) {
                            setState(() {
                              subTitle = val.trim();
                            });
                          },
                          decoration: textInputDecoration.copyWith(
                            hintText: "Ex : Doctors plan"
                          ),
                        ),
                        
                        SizedBox(
                          height: 15,
                        ),
                        
                        Text("Campaion is For"),
                        TextFormField(
                          minLines: 1,
                          maxLines: 10,
                          validator: (String val) {
                            if (val.length < 3) {
                              return "Provide long description";
                            }
                            return null;
                          },
                          onSaved: (String val) {
                            setState(() {
                              desc = val.trim();
                            });
                          },
                          decoration: textInputDecoration.copyWith(
                            hintText: "Ex : TechnoPark LLC",
                          )
                        ),

                        CustomLongButton().loadButton(context, "Publish", () {
                          if (formKey.currentState.validate()) {
                              formKey.currentState.save();

                              setCampain();
                            }
                          else{
                            CustomAlertBox().load(context, "Incomplete Details!", "Please fill all the details");
                          }
                        }),
                       
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}