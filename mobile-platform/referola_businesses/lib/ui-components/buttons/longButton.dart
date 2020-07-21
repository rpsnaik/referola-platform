import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';



class CustomLongButton {
  Widget loadButton(BuildContext context, String title, Function onPressed) {
    return RaisedButton(
      padding: EdgeInsets.all(13.0),
      color: Colors.blueGrey,
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
              fontSize: 15.0,
              fontFamily: "Nunito Sans Bold",
            ),
          )
        ],
      ),
    );
  }
}
