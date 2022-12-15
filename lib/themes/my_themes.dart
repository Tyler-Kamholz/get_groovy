/// Name: Tyler, Matthew
/// Date: December 14, 2022
/// Bugs: N/A
/// Description: Just a bunch of constants to theme the app
/// Reflection: N/A

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
List<Color> darkThemeColors = [
  const Color(0xFF97DB4F),
  const Color(0xFF79C99E),
  const Color(0xFF508484),
  const Color(0xFF4D5359),
  const Color(0xFF4A4238),
  const Color(0xFF313131),
  const Color.fromARGB(255, 136, 136, 136),
  const Color.fromARGB(255, 84, 84, 84),
];

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
  String welcomeLogo;
  String welcomeBackground;
  String loginBackground;
  String homeLogo;
  Color textColor;
  Color textBoxTextColor;

  // Constructor must include all fields, having defaults are preferred but not required
  GroovyTheme(
      {required this.global,
      this.iconColor = Colors.black38,
      this.navBarColor = const Color(0xFFf7ead6),
      this.black = Colors.black,
      this.backgroundColor = const Color.fromARGB(255, 253, 246, 236),
      this.cardColor = Colors.white,
      required this.settingsTheme,
      this.loginColor = const Color(0xFF434964),
      this.signupColor = const Color(0xFFc1604c),
      this.welcomeLogo = "app_assets/Login-Page-trans.png",
      this.welcomeBackground = "app_assets/light_background_menu.png",
      this.loginBackground = "app_assets/light_background_login.png",
      this.homeLogo = "app_assets/Homepage-Trans.png",
      this.textColor = Colors.white,
      this.textBoxTextColor = Colors.black});
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
    welcomeLogo: "app_assets/Login-Page-trans.png",
    welcomeBackground: "app_assets/light_background_menu.png",
    loginBackground: "app_assets/light_background_login.png",
    homeLogo: "app_assets/Homepage-Trans.png",
    textColor: Colors.white,
    textBoxTextColor: Colors.black,
  );

  /// The customized dark theme
  static final darkTheme = GroovyTheme(
    global: ThemeData(brightness: Brightness.dark),
    settingsTheme: SettingsThemeData(
      settingsListBackground: darkThemeColors[7],
      titleTextColor: Colors.white,
    ),
    welcomeLogo: "app_assets/login_page_dark_mode.png",
    welcomeBackground: "app_assets/dark_background_menu.png",
    loginBackground: "app_assets/dark_background_login.png",
    homeLogo: "app_assets/homepage_dark_mode.png",
    navBarColor: darkThemeColors[5],
    loginColor: darkThemeColors[1],
    signupColor: darkThemeColors[0],
    textColor: darkThemeColors[5],
    textBoxTextColor: Colors.white,
    iconColor: darkThemeColors[6],
    backgroundColor: darkThemeColors[7],
    cardColor: darkThemeColors[5],
  );
}
