import 'package:flutter/material.dart';
import 'package:gghack/helpers/Style.dart';
import 'package:gghack/helpers/Requester.dart';
import 'package:gghack/models/User.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'helpers/Constants.dart';
import 'helpers/Dialogue.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  List<bool> isSelected;

  @override
  void initState() {
    isSelected = [true, false];
    super.initState();
  }

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
          ProgressDialog pr = ProgressDialog(context,type: ProgressDialogType.Normal, isDismissible: true, showLogs: false);
          await pr.show();
          User.name = _usernameController.text;
          User.token = await Requester().login(
              _usernameController.text, _passwordController.text).catchError(
                  (exp) async {
                    print("Error occurred in loginButton: $exp");
                    await pr.hide();
                    Dialogue.showConfirmNoContent(context, "Failed to login: ${exp.toString()}", "Got it.");
                  });
          await pr.hide();

          if (User.token != null) {
            if (isSelected[0] == true) {
              User.role = "customer";
              Navigator.of(context).pushNamed(homePageTag);
            } else {
              User.role = "provider";
              Navigator.of(context).pushNamed(phomePageTag);
            }
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

    final versionToggle = Positioned(
      top: 32.0,
      right: 10.0,
      child: ToggleButtons(
        color: Colors.black12,
        selectedColor: Colors.black54,
        borderColor: Colors.transparent,
        selectedBorderColor: Colors.transparent,
        fillColor: Colors.transparent,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              userVersionText,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              providerVersionText,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ],
        onPressed: (int index) {
          setState(() {
            for (int i = 0; i < isSelected.length; i++) {
              isSelected[i] = i == index;
            }
          });
        },
        isSelected: isSelected,
      ),
    );

    return Scaffold(
      backgroundColor: colorBackground,
      body: Stack(
        children: <Widget>[
          versionToggle,
          Center(
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
          )
        ],
      )
    );
  }
}
