import 'package:flutter/material.dart';
import 'package:gghack/Requester.dart';
import 'package:gghack/helpers/Style.dart';
import 'helpers/Constants.dart';

class CreateAccountPage extends StatelessWidget {
  // text edit controllers
  final _usernameController = TextEditingController();
  final _emailaddController = TextEditingController();
  final _passwordController = TextEditingController();
  final _pconfirmController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    final username = TextFormField(
      controller: _usernameController,
      keyboardType: TextInputType.phone,
      maxLines: 1,
      decoration: getInputDecoration(usernameHintText),
      style: TextStyle(
        color: colorText,
      ),
    );

    final emailadd = Padding(
      padding: EdgeInsets.only(top: 24.0),
      child: TextFormField(
        controller: _emailaddController,
        keyboardType: TextInputType.phone,
        maxLines: 1,
        decoration: getInputDecoration(emailaddHintText),
        style: TextStyle(
          color: colorText,
        ),
      )
    );

    final password = Padding(
      padding: EdgeInsets.only(top: 24.0),
      child: TextFormField(
        controller: _passwordController,
        keyboardType: TextInputType.phone,
        maxLines: 1,
        decoration: getInputDecoration(passwordHintText),
        style: TextStyle(
          color: colorText,
        ),
      )
    );

    final pconfirm = Padding(
      padding: EdgeInsets.only(top: 24.0),
      child: TextFormField(
        controller: _pconfirmController,
        keyboardType: TextInputType.phone,
        maxLines: 1,
        decoration: getInputDecoration(pconfirmHintText),
        style: TextStyle(
          color: colorText,
        ),
      )
    );

    final createAccountButton = Padding(
      padding: EdgeInsets.symmetric(horizontal: 64.0, vertical: 32.0),
      child: FlatButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        onPressed: () {
          _createAccountPressed();
        },
        padding: EdgeInsets.all(12),
        color: colorDarker,
        child: Text(createButtonText,
            style: TextStyle(color: Colors.white, fontSize: 16)
        ),
      ),
    );

    return Scaffold(
      backgroundColor: colorDark,
      body: Center(
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          children: <Widget>[
            username,
            emailadd,
            password,
            pconfirm,
            createAccountButton
          ],
        ),
      ),
    );
  }

  void _createAccountPressed() async {
    // developing...
    String response = await Requester().createAccount(
      _emailaddController.text,
      _usernameController.text,
      _passwordController.text,
      _pconfirmController.text
    );
    print(response);
    // if succeed,
    // Navigator.of(context).pushNamed(loginPageTag);
  }
}
