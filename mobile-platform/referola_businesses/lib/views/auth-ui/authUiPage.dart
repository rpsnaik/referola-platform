import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:referola_businesses/ui-components/buttons/longButton.dart';
import 'package:referola_businesses/views/auth-ui/phoneNumberSignIn.dart';


class AuthUIPage extends StatefulWidget {
  @override
  _AuthUIPageState createState() => _AuthUIPageState();
}

class _AuthUIPageState extends State<AuthUIPage> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.blueGrey,
      ),
    );
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("referola", style: TextStyle(
          fontSize: 25,
          fontWeight: FontWeight.w900,
         ),
        ),
        elevation: 2.0,
        backgroundColor: Colors.blueGrey,
      ),
      backgroundColor: Colors.grey[100],
      body: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(left: 20),
              alignment: Alignment.topLeft,
              child: Container(
                child: Column(
                  children: [
                    Center(child: FlutterLogo(
                      size: 100,
                    )),
                  ],
                ),
              ),
            ),
           
            Container(
              margin: EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  CustomLongButton()
                      .loadButton(context, "Sign in with Mobile Number", () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PhonNumberSignInPage(),
                      ),
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
