import 'dart:math';
import 'package:flutter/material.dart';
import 'Constants.dart';

List<List<Color>> getGradientColors(
    List<List<int>> table, MaterialColor baseColor, int darknessLevel,
    [int capacity = 0]) {
  // return colors of diff darkness depending on the value
  // Available/Free Slots: capacity > 0
  // Popular Times: capacity == 0

  double minVal = capacity > 0
      ? 0
      : table.map((e) => e.reduce(min)).toList().reduce(min).toDouble();
  double maxVal = capacity > 0
      ? capacity.toDouble()
      : table.map((e) => e.reduce(max)).toList().reduce(max).toDouble();

  int row = table.length;
  int col = table[0].length;

  List<List<Color>> colors = List<List<Color>>.generate(row, (index) {
    return List<Color>.generate(col, (index) => baseColor[0]);
  });

  for (int i = 0; i < row; ++i) {
    for (int j = 0; j < col; ++j) {
      // popularity: percentage, [0, 1]
      double popularity = (table[i][j].toDouble() - minVal) /
          (maxVal - minVal + 0.05); // avoid divided by 0
      popularity = max(popularity, 0.05); // to still color it
      var color = baseColor[darknessLevel * 100];
      colors[i][j] =
          Color.fromRGBO(color.red, color.green, color.blue, popularity);
    }
  }
  return colors;
}

BoxDecoration getGradientBox() {
  return BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: <Color>[colorGrad1, colorGrad2],
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
          borderSide: BorderSide(color: colorText)),
      hintStyle: TextStyle(
        color: colorText,
      ));
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
      child: Text(title,
          style: TextStyle(color: colorText, fontWeight: FontWeight.bold)));
}
