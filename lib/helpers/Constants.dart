import 'package:flutter/material.dart';

// colors
Color colorBase = Color.fromRGBO(168, 195, 179, 0.2);
Color colorDark = Color.fromRGBO(131, 174, 154, 1.0);
Color colorDarker = Color.fromRGBO(48, 118, 113, 1.0);
Color colorText = Colors.black54;
Color colorBackground = Colors.lightGreen[50]; // Colors.white;

Color colorGrad1 = Color.fromRGBO(103, 178, 111, 1.0);
Color colorGrad2 = Color.fromRGBO(76, 162, 205, 1.0);

Color colorPopTime = Colors.teal;
Color colorFreeSlot = Colors.blue;

// Pages
const loginPageTag = 'Login Page';
const homePageTag = 'Home Page';
const phomePageTag = 'Provider Home Page';
const createAccountPageTag = 'Create Account Page';

// strings
const appTitle = "";
const pappTitle = "";
const rlistTitle = "Reservations";
const createServiceTitle = "Create Service";
const usernameHintText = "Username";
const emailaddHintText = "Email Address";
const passwordHintText = "Password";
const pconfirmHintText = "Confirm Password";
const loginButtonText = "Login";
const searchBarHintText = "Search";
const introductionText = "Introduction";
const timeTableTitleText = "Available slots";
const popularTimesTitleText = "Popular times";
const reserveButtonText = "Reserve";
const reservePopupText = "Select slot";
const userVersionText = "User";
const providerVersionText = "Service Provider";
const createAccountButtonText = "Create Account";
const checkinButtonText = "Check-in";
const createServiceButtonText = "Create Service";

// settings
const max_width = 320.0;
const days = ["", "Jul 6 Mon", "Jul 7 Tue", "Jul 8 Wed", "Jul 9 Thu", "Jul 10 Fri", "Jul 11 Sat", "Jul 12 Sun"];

// URLs
const baseUrl = "gghack-2020.herokuapp.com";
const placeIdFinderUrl = "https://developers-dot-devsite-v2-prod.appspot.com/maps/documentation/javascript/examples/full/places-placeid-finder";
const dummyServiceImage = "https://lexcodigital.com/wp-content/uploads/2017/06/customer-service.jpg";

// Icons
Icon completedIcon = Icon(
  Icons.check_circle,
  color: Colors.green[400],
  size: 24.0,
  semanticLabel: 'Completed',
);
Icon noShowIcon = Icon(
  Icons.cancel,
  color: Colors.red[400],
  size: 24.0,
  semanticLabel: 'No show',
);
Icon pendingIcon = Icon(
  Icons.hourglass_full,
  color: Colors.amber[400],
  size: 24.0,
  semanticLabel: 'Pending',
);
