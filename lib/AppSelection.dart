import 'package:flutter/material.dart';
import 'helpers/Constants.dart';

class AppSelection extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    final userButton = RaisedButton (
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      onPressed: () {
        Navigator.of(context).pushNamed(loginPageTag);
      },
      padding: EdgeInsets.all(20.0),
      color: colorDark,
      child: Text(userVersionText, style: TextStyle(color: Colors.white, fontSize: 20)),
    );

    final providerButton = Padding(
      padding: EdgeInsets.only(left: 20.0),
      child: RaisedButton (
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        onPressed: () {
          Navigator.of(context).pushNamed(ploginPageTag);
        },
        padding: EdgeInsets.all(20.0),
        color: colorDark,
        child: Text(providerVersionText, style: TextStyle(color: Colors.white, fontSize: 20)),
      )
    );

    return Scaffold(
      backgroundColor: colorBackground,
      body: Center(
        child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [userButton, providerButton,]
          )
      ),
    );
  }
}
