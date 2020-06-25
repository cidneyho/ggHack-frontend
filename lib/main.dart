import 'package:flutter/material.dart';
import 'helpers/Constants.dart';
import 'AppSelection.dart';
import 'LoginPage.dart';
import 'ProviderLoginPage.dart';
import 'HomePage.dart';

void main() {
  runApp(RossApp());
}

class RossApp extends StatelessWidget {
  final routes = <String, WidgetBuilder>{
    appSelectionTag: (context) => AppSelection(),
    loginPageTag: (context) => LoginPage(),
    ploginPageTag: (context) => ProviderLoginPage(),
    homePageTag: (context) => HomePage(),
  };

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: appTitle,
      theme: new ThemeData(
        primaryColor: colorDark,
      ),
      home: AppSelection(),
      routes: routes,
    );
  }
}
