import 'package:flutter/material.dart';
import 'helpers/Constants.dart';

class ProviderLoginPage extends StatelessWidget {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    final username = TextFormField(
      controller: _usernameController,
      keyboardType: TextInputType.phone,
      maxLength: 4,
      maxLines: 1,
      decoration: InputDecoration(
          hintText: usernameHintText,
          contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          hintStyle: TextStyle(
              color: colorText,
          )
      ),
      style: TextStyle(
        color: colorText,
      ),
    );

    final password = TextFormField(
      controller: _passwordController,
      keyboardType: TextInputType.phone,
      maxLength: 4,
      maxLines: 1,
      decoration: InputDecoration(
          hintText: passwordHintText,
          contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          hintStyle: TextStyle(
              color: colorText,
          )
      ),
      style: TextStyle(
        color: colorText,
      ),
    );

    final loginButton = Padding(
      padding: EdgeInsets.symmetric(horizontal: 64.0, vertical: 20.0),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        onPressed: () {
          // TODO: if password correct,
          Navigator.of(context).pushNamed(homePageTag);
        },
        padding: EdgeInsets.all(12),
        color: colorDarker,
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
          // Navigator.of(context).pushNamed(create Business Account Page Tag);
        },
        padding: EdgeInsets.all(12),
        color: colorDark,
        child: Text(createButtonText,
            style: TextStyle(color: Colors.white, fontSize: 16, decoration: TextDecoration.underline)
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
            password,
            loginButton,
            createButton
          ],
        ),
      ),
    );
  }
}