import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:referola/logic/auth/emailAuth.dart';
import 'package:referola/logic/auth/googleAuth.dart';
import 'package:referola/ui-components/Forms/inputDecoration.dart';
import 'package:referola/ui-components/buttons/longButton.dart';
import 'package:referola/views/auth-ui/register.dart';
import '../../logic/auth/accountFun.dart';


class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String _email, _password;
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: Text("Log in",),
      ),
      body: Container(
        padding: EdgeInsets.all(20.0),
        margin: EdgeInsets.all(5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: ListView(
                children: [
                  FlutterLogo(
                    size: 100,
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Expanded(
                    child: Form(
                      key: formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          TextFormField(
                            cursorColor: Colors.blueGrey,
                            onSaved: (String emailId){
                              setState(() {
                                _email = emailId;
                              });
                            },
                            validator: (String val){
                              if(!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(val.toLowerCase().trim())){
                                return "Enter a valid email address!";
                              }
                              return null;
                            },
                            decoration: textInputDecoration.copyWith(
                              prefixIcon: Icon(Icons.mail),
                              hintText: "Email Id"
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            smartDashesType: SmartDashesType.enabled,
                            cursorColor: Colors.blueGrey,
                            obscureText: true,
                            onSaved: (String val){
                              setState(() {
                                _password = val;
                              });
                            },
                            validator: (String val){
                              if(val.length < 6){
                                return "Password should be of atleast 6 charecters!";
                              }
                              return null;
                            },
                            decoration: textInputDecoration.copyWith(
                              hintText: "Password",
                              prefixIcon: Icon(Icons.lock)
                            )
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                          CustomLongButton().loadButton(context, "Login", (){
                            if(formKey.currentState.validate()){
                                formKey.currentState.save();
                                signIn(_email, _password);
                                AccountFun().accountStatusVerifier(context);
                              }
                          }),
                          SizedBox(
                            height: 10,
                          ),
                          Text("or"),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Container(
                                  child: SignInButton(
                                    Buttons.Google,
                                    text: "Sign in with Google",
                                    padding: EdgeInsets.symmetric(vertical: 8),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    onPressed: () {
                                      googleSignIn().whenComplete(() => {
                                        AccountFun().accountStatusVerifier(context)
                                      });
                                    }
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Container(
                                    child: SignInButton(
                                    Buttons.Facebook,
                                    text: "Sign in with Facebook",
                                    padding: EdgeInsets.only(top: 15, bottom: 15),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    onPressed: () {
                                     
                                    }
                                  ),
                                  ),
                                ),
                              ],
                            ),
                          SizedBox(
                            height: 10,
                          ),
                          CupertinoButton(
                            child: Text("Don't have an account? Sign Up"),
                            onPressed: () {
                              Navigator.pop(context);
                              Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterAccount()));
                            },
                          ),

                        ],
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}