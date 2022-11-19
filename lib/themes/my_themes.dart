import 'package:flutter/material.dart';

const List<Color> lightThemeColors = [
  Color(0xFF434964),
  Color(0xFFc1604c),
  Color(0xFFdbbb8a),
  Color(0xFF9eaca7),
  Color(0xFFf7ead6)
];

const Color black = Colors.black;

/// A class to bundle and configure themes
class MyThemes {
  /// The customized light theme
  static final lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: lightThemeColors[4],
    iconTheme: const IconThemeData(color: black),
  );

  /// The customized dark theme
  static final darkTheme = ThemeData(brightness: Brightness.dark);
}
