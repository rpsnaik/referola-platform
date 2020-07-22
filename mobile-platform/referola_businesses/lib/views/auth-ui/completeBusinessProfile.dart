import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:referola_businesses/data/weeks.dart';
import 'package:referola_businesses/logic/auth/accountFun.dart';
import 'package:referola_businesses/ui-components/buttons/customAlertBox.dart';
import 'package:referola_businesses/ui-components/buttons/primaryButton.dart';
import '../../ui-components/buttons/longButton.dart';

class AddBusinessProfile extends StatefulWidget {
  final ValueChanged<bool> added;
  AddBusinessProfile({@required this.added});
  @override
  _AddBusinessProfileState createState() =>
      _AddBusinessProfileState();
}

class _AddBusinessProfileState extends State<AddBusinessProfile> {
  bool loading = false;

  String title, email, businessLogoImgUrl, shortDes;

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

  setBusiness() async {
    setState(() {
      loading = true;
    });
    await BusinessesFun().addBusinessProfile(context, user, title, email, null, null, shortDes, startTime, closeTime, holidays).then((E){
      setState(() {
        widget.added(true);
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
          "Create a businesss",
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
                        Text("Enter your Business Name"),
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
                          decoration: InputDecoration(
                            labelText: "Business Name",
                            hintText: "Ex : Techno Park LLC",
                          ),
                        ),
                        
                        SizedBox(
                          height: 15,
                        ),
                        
                        Text("What your Business does"),
                        TextFormField(
                          validator: (String val) {
                            if (val.length < 3) {
                              return "Provide long description";
                            }
                            return null;
                          },
                          onSaved: (String val) {
                            setState(() {
                              shortDes = val.trim();
                            });
                          },
                          decoration: InputDecoration(
                            labelText: "Description",
                            hintText: "Ex : TechnoPark LLC",
                          ),
                        ),

                        SizedBox(
                          height: 15,
                        ),
                        Text("Enter your email address"),
                        TextFormField(
                          validator: (String val) {
                            if (!RegExp(
                                    r'^.+@[a-zA-Z]+\.{1}[a-zA-Z]+(\.{0,1}[a-zA-Z]+)$')
                                .hasMatch(val.trim())) {
                              return "Enter valid email address";
                            }
                            return null;
                          },
                          onSaved: (String val) {
                            setState(() {
                              email = val.trim();
                            });
                          },
                          decoration: InputDecoration(
                            labelText: "Email Id",
                            hintText: "Ex : yourname@example.com",
                          ),
                        ),

                        SizedBox(
                          height: 15.0,
                        ),
                        Text("Business Start Time"),
                        SizedBox(
                          height: 5.0,
                        ),
                        PrimaryButton().loadButton(context, startTime == null ? "Select the Business Start Time" : startTime.format(context), ()async{
                          await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.now()
                          ).then((TimeOfDay time){
                            setState(() {
                              startTime = time;
                            });
                          }).catchError((e){
                            print(e);
                            CustomAlertBox().load(context, "Error", e.message);
                          });
                        }),

                        SizedBox(
                          height: 15.0,
                        ),
                        Text("Business Close Time"),
                        SizedBox(
                          height: 5.0,
                        ),
                        PrimaryButton().loadButton(context, closeTime == null ? "Select the Business Close Time" : closeTime.format(context), ()async{
                          await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.now()
                          ).then((TimeOfDay time){
                            setState(() {
                              closeTime = time;
                            });
                          }).catchError((e){
                            print(e);
                            CustomAlertBox().load(context, "Error", e.message);
                          });
                        }),

                        SizedBox(
                          height: 15.0,
                        ),
                        
                        Text("Select Holidays in week"),
                        SizedBox(
                          height: 10.0,
                        ),
                        
                        PrimaryButton().loadButton(context, "Select Holidays", ()async{
                          holidays = await showDialog(
                            context: context,
                            builder: (ctx) {
                              return MultiSelectListDialog(
                                items: week.map((item) => 
                                  MultiSelectItem(item, item)).toList(),
                                title: "Business Holidays",
                                initialSelectedItems: holidays,
                              );
                            },
                          );
                          setState(() {
                            
                          });
                        }),

                        Text(holidays.toString()),

                        SizedBox(
                          height: 20.0,
                        ),
                       
                        CustomLongButton().loadButton(context, "Create", () {
                          if(startTime != null && closeTime != null){
                            if (formKey.currentState.validate()) {
                              formKey.currentState.save();

                              setBusiness();
                            }
                          }else{
                            CustomAlertBox().load(context, "Incomplete Details!", "Please, Select the Business Start time and Close Time");
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