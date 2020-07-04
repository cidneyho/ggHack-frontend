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
  // return 7x24 colors matching the value in service's popularTimes
  // Using https://api.flutter.dev/flutter/material/Colors-class.html
  MaterialColor baseColor = Colors.teal;
  int maxDarkness = 6;
  double minVal = 0.0;
  double maxVal = service.popularTimes.map(
          (e) => e.reduce(max)).toList().reduce(max).toDouble();

  List<List<Color>> colors = List<List<Color>>.generate(7, (index) {
    return List<Color>.generate(24, (index) => baseColor[0]);
  });

  for(int i=0; i<7; ++i) {
    for(int j=0; j<24; ++j) {
      double popularity = (service.popularTimes[i][j].toDouble() - minVal) / (maxVal - minVal);
      int darkness = (popularity * maxDarkness.toDouble()).toInt() * 100;
      if(darkness > 0) {
        colors[i][j] = baseColor[darkness];
      } else {
        colors[i][j] = Colors.white;
      }
    }
  }
  return colors;
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