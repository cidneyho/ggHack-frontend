import 'package:flutter/material.dart';
import 'package:gghack/helpers/Requester.dart';
import 'package:gghack/helpers/Style.dart';
import 'helpers/Constants.dart';
import 'helpers/Dialogue.dart';

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
      keyboardType: TextInputType.text,
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
        keyboardType: TextInputType.emailAddress,
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
        keyboardType: TextInputType.text,
        maxLines: 1,
        obscureText: true,
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
        keyboardType: TextInputType.text,
        maxLines: 1,
        obscureText: true,
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
          _createAccountPressed(context);
        },
        padding: EdgeInsets.all(12),
        color: colorDark,
        child: Text(createAccountButtonText,
            style: TextStyle(color: Colors.white, fontSize: 16)
        ),
      ),
    );

    return Scaffold(
      appBar: new AppBar(
        elevation: 0.2,
        title: Text("Create Account", style: TextStyle(color: Colors.white)),
        leading: BackButton(color: Colors.white),
        flexibleSpace: Container(
          decoration: getGradientBox(),
        ),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      backgroundColor: colorBackground,
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

  void _createAccountPressed(BuildContext context) async {
    String response = await Requester(context).createAccount(
      _emailaddController.text,
      _usernameController.text,
      _passwordController.text,
      _pconfirmController.text
    ).catchError((error) async {
      Dialogue.showConfirmNoContent(context, "Account creation failed: ${error.toString()}", "Got it.");
    });

    if (response != null) {
        Navigator.of(context).pushNamed(loginPageTag);
        Dialogue.showBarrierDismissibleNoContent(context, "Account created.");
    }
  }
}
