import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:referola_businesses/logic/auth/accountFun.dart';

void main() => runApp(
  MaterialApp(
    theme: ThemeData(
      primaryColor: Colors.red[300],
    ),
    home: SplashScreen(),
    debugShowCheckedModeBanner: false,
  ),
);

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  
  @override
  void initState() {
    Future.delayed((Duration(seconds: 1)), ()async{
      await AccountFun().accountStatusVerifier(context);
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Theme.of(context).primaryColor
      ),
    );
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(30.0),
        alignment: Alignment.center,
        child: FlutterLogo(
          size: 200,
        ),
      ),
    );
  }
}