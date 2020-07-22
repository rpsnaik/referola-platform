import 'package:flutter/material.dart';
import 'package:referola_businesses/ui-components/buttons/primaryButton.dart';

class UserAtBusinessLocation extends StatefulWidget {
  final ValueChanged<bool> atLoc;
  UserAtBusinessLocation({@required this.atLoc});
  @override
  _UserAtBusinessLocationState createState() => _UserAtBusinessLocationState();
}

class _UserAtBusinessLocationState extends State<UserAtBusinessLocation> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Are your at your Business Location", style: TextStyle(
          fontWeight: FontWeight.bold
        ),),
      ),
      body: Container(
        child: Center(
          child: PrimaryButton().loadButton(context, "Yes, I am", (){
            setState(() {
              widget.atLoc(true);
            });
            Navigator.pop(context);
          }),
        ),
      ),
    );
  }
}