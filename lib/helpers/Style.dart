import 'dart:math';
import 'package:flutter/material.dart';
import 'Constants.dart';

List<List<Color>> getGradientColors(
  List<List<int>> table, MaterialColor baseColor, int darknessLevel, [bool smallValues = false]) {

  // return colors of diff darkness depneding on the value 

  double minVal = smallValues? 0: table.map (
          (e) => e.reduce(min)).toList().reduce(min).toDouble();
  double maxVal = smallValues? 10: table.map (
          (e) => e.reduce(max)).toList().reduce(max).toDouble();
  
  int row = table.length;
  int col = table[0].length;

  List<List<Color>> colors = List<List<Color>>.generate(row, (index) {
    return List<Color>.generate(col, (index) => baseColor[0]);
  });

  for (int i = 0; i < row; ++i) {
    for (int j = 0; j < col; ++j) {
      // percentage, [0, 1]
      double popularity = (table[i][j].toDouble() - minVal) / (maxVal - minVal);
      int darkness = (popularity * darknessLevel.toDouble()).toInt() * 100;
      if (darkness > 0) {
        colors[i][j] = baseColor[darkness];
      } else {
        colors[i][j] = baseColor[50];
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
    filled: true,
    fillColor: Colors.white,
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

InputDecoration getBlankDecoration({Widget suffixIcon, String hintText}) {
  return InputDecoration(
    contentPadding: EdgeInsets.symmetric(horizontal: 4),
    // border: InputBorder.none,
    // focusedBorder: InputBorder.none,
    suffixIcon: suffixIcon,
    hintText: hintText,
    hintStyle: TextStyle(fontSize: 13.0, color: Colors.grey[400]),
  );
}

Widget getFormTitle(String title) {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: 2),
    child: Text(title, style: TextStyle(color: colorText, fontWeight: FontWeight.bold))
  );
}