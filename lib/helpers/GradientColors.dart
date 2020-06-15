import 'package:flutter/material.dart';
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
