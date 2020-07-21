
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:referola_businesses/ui-components/buttons/primaryButton.dart';

class CustomAlertBox {
  load(BuildContext context, String title, String subtitle) async {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
            title: Text(
              title,
              style: TextStyle(fontFamily: "Nunito Sans Bold"),
            ),
            content: Text(subtitle),
            actions: [
              PrimaryButton().loadButton(context, "Okay", () {
                Navigator.pop(context);
              })
            ],
          );
        });
  }
}
