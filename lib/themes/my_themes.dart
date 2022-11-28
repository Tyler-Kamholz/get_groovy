import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';

/// Defines the data available to use for themes
/// If you need to stylize a specific widget, create a new field of this class
/// and add it to the constructor
/// Then, in MyThemes, modify the constructor instantiations to customize your settings
/// Inspect loginBackgroundColor for more details

List<Color> lightThemeColors = [
  const Color.fromARGB(255, 253, 246, 236),
  const Color(0xFFf7ead6),
  const Color(0xFF9eaca7),
  const Color(0xFFdbbb8a),
  const Color(0xFFc1604c),
  const Color(0xFF434964),
  Colors.black38
];
List<Color> darkThemeColors = [];

class GroovyTheme {
  // Data types
  SettingsThemeData settingsTheme;
  ThemeData global;
  Color iconColor;
  Color navBarColor;
  Color black;
  Color backgroundColor;
  Color cardColor;
  Color loginColor;
  Color signupColor;

  // Constructor must include all fields, having defaults are preferred but not required
  GroovyTheme({
    required this.global,
    this.iconColor = Colors.black38,
    this.navBarColor = const Color(0xFFf7ead6),
    this.black = Colors.black,
    this.backgroundColor = const Color.fromARGB(255, 253, 246, 236),
    this.cardColor = Colors.white,
    required this.settingsTheme,
    this.loginColor = const Color(0xFF434964),
    this.signupColor = const Color(0xFFc1604c),
  });
}

/// A class to bundle and configure themes
class MyThemes {
  /// The customized light theme
  static final lightTheme = GroovyTheme(
    global: ThemeData(brightness: Brightness.light),
    iconColor: lightThemeColors[6],
    navBarColor: lightThemeColors[1],
    black: Colors.black,
    backgroundColor: lightThemeColors[0],
    cardColor: Colors.white,
    settingsTheme: SettingsThemeData(
        settingsListBackground: lightThemeColors[0],
        settingsSectionBackground: Colors.white),
    loginColor: lightThemeColors[5],
    signupColor: lightThemeColors[4],
  );

  /// The customized dark theme
  static final darkTheme = GroovyTheme(
    global: ThemeData(brightness: Brightness.dark),
    settingsTheme:
        SettingsThemeData(settingsListBackground: lightThemeColors[0]),
  );
}
