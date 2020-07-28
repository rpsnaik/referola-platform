import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';



class CustomLongButton {
  Widget loadButton(BuildContext context, String title, Function onPressed) {
    return RaisedButton(
      padding: EdgeInsets.all(15.0),
      color: Colors.black,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      onPressed: onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
              fontFamily: "Proxima Nova",
            ),
          )
        ],
      ),
    );
  }
}
