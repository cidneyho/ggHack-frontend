import 'package:flutter/material.dart';
import 'helpers/Constants.dart';
import 'LoginPage.dart';
import 'CreateAccountPage.dart';
import 'ProviderHomePage.dart';
import 'CustomerHomePage.dart';

void main() {
  runApp(RossApp());
}

class RossApp extends StatelessWidget {
  final routes = <String, WidgetBuilder>{
    loginPageTag: (context) => LoginPage(),
    customerHomePageTag: (context) => CustomerHomePage(),
    providerHomePageTag: (context) => ProviderHomePage(),
    createAccountPageTag: (context) => CreateAccountPage(),
  };

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: appTitle,
      theme: new ThemeData(
        primaryColor: colorDark,
      ),
      home: LoginPage(),
      routes: routes,
    );
  }
}
