import 'package:flutter/material.dart';

// colors
Color colorDark = Color.fromRGBO(58, 66, 86, 1.0);
Color colorBase = Color.fromRGBO(64, 75, 96, 0.9);
Color colorLoom = Colors.white54;
Color colorLight = Color.fromRGBO(44,119,143, 1.0);

Color colorTone1 = Colors.blue[50];
Color colorTone2 = Colors.blue[100];
Color colorTone3 = Colors.blue[200];
Color colorTone4 = Colors.blue[300];

// Pages
const loginPageTag = 'Login Page';
const homePageTag = 'Home Page';

// strings
const appTitle = "Ross";
const usernameHintText = "Username";
const passwordHintText = "Password";
const loginButtonText = "Login";
const searchBarHintText = "Search";
const introductionText = "Introduction";
const timeTableTitleText = "Available slots";
const reserveButtonText = "Reserve";
const reservePopupText = "Select slot";

// settings
const days = ["", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];

// temp storage - for testing purposes only
var optime = [10, 22];
var freeslots = [
  [2,2,1,1,3,3,3,3,2,2,1,1], // Mon
  [2,2,1,1,2,2,2,2,1,1,0,0], // Tue
  [0,1,2,2,4,4,3,3,2,2,1,1],
  [1,1,0,0,1,1,2,2,2,2,1,1],
  [0,0,1,1,3,3,3,3,0,0,0,0],
  [0,0,2,2,1,1,2,2,3,3,3,3],
  [1,1,0,0,0,0,1,1,2,2,2,2],
];

const pickerData = ''' [
{"Mon": [10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20]},
{"Tue": [10, 11, 12, 13, 14, 15, 16, 17, 18, 19]},
{"Wed": [11, 12, 13, 14, 15, 16, 17, 18, 19, 20]},
{"Thu": [10, 11, 14, 15, 16, 17, 18, 19, 20]},
{"Fri": [12, 13, 14, 15, 16]},
{"Sat": [12, 13, 14, 15, 16, 17, 18, 19, 20]},
{"Sun": [10, 11, 16, 17, 18, 19, 20]}
] ''';