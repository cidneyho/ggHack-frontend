import 'package:flutter/material.dart';

import 'Constants.dart';

class Dialogue {
  static void showBarrierDismissible(
      BuildContext context, String titleText, String contentText) {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          Future.delayed(Duration(milliseconds: 1500), () {
            Navigator.of(context, rootNavigator: true).pop(true);
          });
          return AlertDialog(
            title: Text(
                titleText,
                style: TextStyle(fontWeight: FontWeight.bold)
            ),
            content: SingleChildScrollView(
                child: Text(
                  contentText,
                  style: TextStyle(color: colorText),
                )
            ),
          );
        }
    );
  }

  static void showBarrierDismissibleNoContent(
      BuildContext context, String titleText) {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          Future.delayed(Duration(milliseconds: 1500), () {
            Navigator.of(context, rootNavigator: true).pop(true);
          });
          return AlertDialog(
            content: Text(
                titleText,
                style: TextStyle(fontWeight: FontWeight.bold)
            ),
          );
        }
    );
  }

  static void showConfirm(
      BuildContext context, String titleText, String contentText, String okText) {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
                titleText,
                style: TextStyle(fontWeight: FontWeight.bold)
            ),
            content: SingleChildScrollView(
                child: Text(
                  contentText,
                  style: TextStyle(color: colorText),
                )
            ),
            actions: <Widget>[
              FlatButton(
                child: Text(okText),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        }
    );
  }

  static void showConfirmNoContent(
      BuildContext context, String titleText, String okText) {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Text(
                titleText,
                style: TextStyle(fontWeight: FontWeight.bold)
            ),
            actions: <Widget>[
              FlatButton(
                child: Text(okText),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        }
    );
  }

  static bool showAlertDialog(BuildContext context, String titleText) {

    bool response;

    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text("Cancel"),
      onPressed:  () {
        Navigator.pop(context);
        return false;
      },
    );
    Widget continueButton = FlatButton(
      child: Text("Confirm"),
      onPressed:  () {
        Navigator.pop(context);
        return true;
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(titleText),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );

    return null;
  }
}