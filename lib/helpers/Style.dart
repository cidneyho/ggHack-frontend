import 'dart:math';
import 'package:flutter/material.dart';
import 'package:gghack/models/Service.dart';
import 'Constants.dart';

Color getGradient(int value) {
  Color color;
  switch (value) {
    case 0:
      color = Colors.transparent;
      break;
    case 1:
      color = colorTone1;
      break;
    case 2:
      color = colorTone2;
      break;
    case 3:
      color = colorTone3;
      break;
    default:
      color = colorTone4;
      break;
  }
  return color;
}

List<List<Color>> getPopularTimesColors(Service service) {
  Color baseColor = colorTone4;
  int minVal = 0;
  int maxVal = service.popularTimes.map(
          (e) => e.reduce(max)).toList().reduce(max);
  for(int i=0; i<7; ++i) {
    for(int j=service.startTime; j<service.closeTime; ++j) {
      service.popularTimes[i][j];
    }
  }
}

BoxDecoration getGradientBox() {
  return BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: <Color>[
        colorGrad1,
        colorGrad2
      ],
    ),
  );
}

InputDecoration getInputDecoration(String hintText) {
  return InputDecoration(
    hintText: hintText,
    contentPadding: EdgeInsets.symmetric(horizontal: 20),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16.0),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16.0),
      borderSide: BorderSide(color: colorText)
    ),
    hintStyle: TextStyle(
      color: colorText,
    )
  );
}