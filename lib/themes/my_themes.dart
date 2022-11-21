import 'package:flutter/material.dart';

/// Defines the data available to use for themes
/// If you need to stylize a specific widget, create a new field of this class
/// and add it to the constructor
/// Then, in MyThemes, modify the constructor instantiations to customize your settings
/// Inspect loginBackgroundColor for more details
class GroovyTheme {
  // Data types
  ThemeData global;
  Color loginBackgroundColor;

  // Constructor must include all fields, having defaults are preferred but not required
  GroovyTheme({
    required this.global,
    this.loginBackgroundColor = Colors.green,
  });
}

/// A class to bundle and configure themes
class MyThemes {
  /// The customized light theme
  static final lightTheme = GroovyTheme(
    global: ThemeData(brightness: Brightness.light),
    loginBackgroundColor: Colors.green,
  );

  /// The customized dark theme
  static final darkTheme = GroovyTheme(
    global: ThemeData(brightness: Brightness.dark),
    loginBackgroundColor: const Color.fromARGB(255, 151, 68, 0),
  );
}
