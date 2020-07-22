import 'package:flutter/material.dart';
import 'package:referola/logic/auth/emailAuth.dart';
import 'package:referola/ui-components/Forms/inputDecoration.dart';
import 'package:referola/ui-components/buttons/longButton.dart';
import 'package:referola/views/homePage/homePage.dart';


class RegisterAccount extends StatefulWidget {
  @override
  _RegisterAccountState createState() => _RegisterAccountState();
}

class _RegisterAccountState extends State<RegisterAccount> {
  String _email, _password, pass1;
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: Text("Register"),
      ),
      body: Container(
        child: ListView(
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Form(
                    key: formKey,
                    child: Column(
                      children: <Widget>[
                        TextFormField(
                          decoration: textInputDecoration.copyWith(
                            hintText: "Email Id",
                            prefixIcon: Icon(Icons.mail)
                          ),
                          onSaved: (String val){
                            setState(() {
                              _email = val.toLowerCase().trim();
                            });
                          },
                          validator: (String val){
                            if(!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(val.toLowerCase().trim())){
                              return "Enter a valid email address!";
                            }
                            return null;
                          },
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          decoration: textInputDecoration.copyWith(
                            hintText: "Password",
                            prefixIcon: Icon(Icons.lock)
                          ),
                          validator: (String val){
                            if(val.length < 6){
                              return "Password should be of atleast 6 charecters!";
                            }
                            if(val != pass1){
                              return "Password Mismatch!";
                            }
                            return null;
                          },
                          onSaved: (String val){
                            setState(() {
                              _password = val;
                            });
                          },
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          decoration: textInputDecoration.copyWith(
                            hintText: "Re-enter Password",
                            prefixIcon: Icon(Icons.lock)
                          ),
                          validator: (String val){
                            if(val.length < 6){
                              return "Password should be of atleast 6 charecters!";
                            }
                            if(val != _password){
                              return "Password Mismatch!";
                            }
                            return null;
                          },
                          onSaved: (String val){
                            setState(() {
                              pass1 = val;
                            });
                          },
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        CustomLongButton().loadButton(context, "Register", (){
                          formKey.currentState.save();
                            if(formKey.currentState.validate()){
                              signUp(_email, _password);
                              Navigator.push(context, MaterialPageRoute(builder: (context) =>HomePage()));
                            }
                        }),
                      ],
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













