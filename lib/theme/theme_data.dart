import 'package:flutter/material.dart';

class MyTheme {
  static ThemeData getTheme() {
    final primarySwatch = Colors.blue;
    final secondaryColor = Colors.orange;

    return ThemeData(
      primarySwatch: primarySwatch,
      colorScheme: ColorScheme.fromSwatch(
        primarySwatch: primarySwatch,
      ).copyWith(
        secondary: secondaryColor,
      ),
      cardColor: secondaryColor,
    );
  }
}