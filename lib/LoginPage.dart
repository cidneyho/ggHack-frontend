import 'package:flutter/material.dart';
import 'package:gghack/helpers/Style.dart';
import 'package:gghack/helpers/Requester.dart';
import 'package:gghack/models/User.dart';
import 'helpers/Constants.dart';

class LoginPage extends StatelessWidget {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

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

    final loginButton = Padding(
      padding: EdgeInsets.fromLTRB(64, 32, 64, 16),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        onPressed: () async {
          User.name = _usernameController.text;
          User.token = await Requester().login(
              _usernameController.text, _passwordController.text).catchError(
                  (exp) => print("Error occurred in loginButton: $exp"));
          
          if (User.token != null) {
              Navigator.of(context).pushNamed(homePageTag);
          }
        },
        padding: EdgeInsets.all(12),
        color: colorDark,
        child: Text(loginButtonText,
            style: TextStyle(color: Colors.white, fontSize: 16)),
      ),
    );

    final createButton = Padding(
      padding: EdgeInsets.symmetric(horizontal: 64.0),
      child: FlatButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        onPressed: () {
          Navigator.of(context).pushNamed(createAccountPageTag);
        },
        padding: EdgeInsets.all(12),
        color: Colors.transparent,
        child: Text(createAccountButtonText,
            style: TextStyle(color: colorText, fontSize: 16, decoration: TextDecoration.underline)
        ),
      ),
    );

    return Scaffold(
      backgroundColor: colorBackground,
      body: Center(
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          children: <Widget>[
            username,
            password,
            loginButton,
            createButton
          ],
        ),
      ),
    );
  }
}
