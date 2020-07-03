import 'package:flutter/material.dart';
import 'helpers/Constants.dart';
import 'package:gghack/RequesterUnitTest.dart';

class AppSelection extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    UnitTest.testMakeAndCancelReservation();
    final userButton = RaisedButton (
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      onPressed: () {
        Navigator.of(context).pushNamed(loginPageTag);
      },
      padding: EdgeInsets.all(20.0),
      color: colorDarker,
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
        color: colorDarker,
        child: Text(providerVersionText, style: TextStyle(color: Colors.white, fontSize: 20)),
      )
    );

    return Scaffold(
      backgroundColor: colorDark,
      body: Center(
        child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [userButton, providerButton,]
          )
      ),
    );
  }
}
