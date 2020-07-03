import 'package:flutter/material.dart';

// colors
Color colorBase = Color.fromRGBO(168, 195, 179, 0.2);
Color colorDark = Color.fromRGBO(131, 174, 154, 1.0);
Color colorDarker = Color.fromRGBO(48, 118, 113, 1.0);
Color colorText = Colors.black54;

Color colorGrad1 = Color.fromRGBO(103, 178, 111, 1.0);
Color colorGrad2 = Color.fromRGBO(76, 162, 205, 1.0);

Color colorTone1 = Color.fromRGBO(140, 187, 224, 0.25);
Color colorTone2 = Color.fromRGBO(140, 187, 224, 0.50);
Color colorTone3 = Color.fromRGBO(140, 187, 224, 0.75);
Color colorTone4 = Color.fromRGBO(140, 187, 224, 1.00);

// Pages
const loginPageTag = 'Login Page';
const ploginPageTag = 'Provider Login Page';
const homePageTag = 'Home Page';
const phomePageTag = 'Provider Home Page';
const appSelectionTag = 'App Selection';
const createAccountPageTag = 'Create Account Page';
const pcreateAccountPageTag = 'Provider Create Account Page';

// strings
const appTitle = "";
const usernameHintText = "Username";
const emailaddHintText = "Email Address";
const passwordHintText = "Password";
const pconfirmHintText = "Confirm Password";
const loginButtonText = "Login";
const searchBarHintText = "Search";
const introductionText = "Introduction";
const timeTableTitleText = "Available slots";
const reserveButtonText = "Reserve";
const reservePopupText = "Select slot";
const userVersionText = "User";
const providerVersionText = "Service Provider";
const createButtonText = "Create Account";
const checkinButtonText = "Check-in";

// settings
const max_width = 320.0;
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

const reservationInfo = "Monday 14:00";

const pickerData = ''' [
{"Mon": [10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20]},
{"Tue": [10, 11, 12, 13, 14, 15, 16, 17, 18, 19]},
{"Wed": [11, 12, 13, 14, 15, 16, 17, 18, 19, 20]},
{"Thu": [10, 11, 14, 15, 16, 17, 18, 19, 20]},
{"Fri": [12, 13, 14, 15, 16]},
{"Sat": [12, 13, 14, 15, 16, 17, 18, 19, 20]},
{"Sun": [10, 11, 16, 17, 18, 19, 20]}
] ''';

// frontend API
const baseUrl = "gghack-2020.herokuapp.com";
