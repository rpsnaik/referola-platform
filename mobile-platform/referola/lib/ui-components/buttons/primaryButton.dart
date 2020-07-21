import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class PrimaryButton{
  Widget loadButton(BuildContext context, String title, Function onPressed){
    return RaisedButton(
      padding: EdgeInsets.only(left: 50.0, right: 50.0),
      color: Colors.blueGrey[900],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0)
      ),
      child: Text(title, style: TextStyle(
        color: Colors.white,
        fontFamily: "Nunito Sans Bold"
      ),),
      onPressed: onPressed
    );
  }
}