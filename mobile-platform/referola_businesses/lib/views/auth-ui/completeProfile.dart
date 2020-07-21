import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:referola_businesses/ui-components/buttons/customAlertBox.dart';
import 'package:referola_businesses/views/auth-ui/phoneNumberSignIn.dart';
import 'package:referola_businesses/views/homePage/homePage.dart';
import '../../logic/auth/accountFun.dart';
import '../../ui-components/buttons/longButton.dart';

class CompleteYourProfilePage extends StatefulWidget {
  @override
  _CompleteYourProfilePageState createState() =>
      _CompleteYourProfilePageState();
}

class _CompleteYourProfilePageState extends State<CompleteYourProfilePage> {
  bool loading = false;

  String title, email, businessLogoImgUrl, shortDes;

  FirebaseUser user;

  final formKey = GlobalKey<FormState>();

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
    await AccountFun()
        .addBusinessProfile(
            context, user, title, email, businessLogoImgUrl, shortDes)
        .then((E) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => HomePage()));
    }).catchError((e) {
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
   
    setState(() {
      
    });
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
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text("Enter Your Business Name"),
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
                          height: 35,
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
                          height: 35,
                        ),
                        TextFormField(
                          validator: (String val) {
                            if (val.length < 3) {
                              return "Enter a valid url";
                            }
                            return null;
                          },
                          onSaved: (String val) {
                            setState(() {
                              businessLogoImgUrl = val.trim();
                            });
                          },
                          decoration: InputDecoration(
                            labelText: "Logo Url",
                            hintText: "Ex : https://logourl.com",
                          ),
                        ),
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
                            hintText: "Ex : Techno Park LLC",
                          ),
                        ),
                        MaterialButton(
                          child: Text("Logout"),
                          onPressed: () => {
                            FirebaseAuth.instance.signOut(),
                            Navigator.pop(context),
                            Navigator.push(context, MaterialPageRoute(builder: (context) =>  PhonNumberSignInPage(),
                            ),
                           ),
                          },
                        ),
                        CustomLongButton().loadButton(context, "Create", () {
                          if (formKey.currentState.validate()) {
                            formKey.currentState.save();

                            setBusiness();
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