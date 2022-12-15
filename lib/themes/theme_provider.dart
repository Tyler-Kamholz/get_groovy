/// Name: Matthew
/// Date: December 14, 2022
/// Bugs: N/A
/// Description: Provides themes throughout the entire app
/// Reflection: N/A

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:getgroovy/themes/my_themes.dart';
import 'package:system_theme/system_theme.dart';

/// This class provides an interface to globally access
/// and change the app theme
class ThemeProvider extends ChangeNotifier {
  // Defaults to the system's theme
  ThemeMode _themeMode = ThemeMode.system;
  BuildContext context;

  ThemeProvider({required this.context}) {
    _themeMode = ThemeMode.system;
    updateSystemNavBar();
  }

  /// Gets the current theme
  ThemeMode get getThemeMode => _themeMode;

  // Returns the current thee
  GroovyTheme getCurrentTheme() {
    if (_themeMode == ThemeMode.light) {
      return MyThemes.lightTheme;
    } else if (_themeMode == ThemeMode.dark) {
      return MyThemes.darkTheme;
    } else {
      return SystemTheme.isDarkMode ? MyThemes.darkTheme : MyThemes.lightTheme;
    }
  }

  /// Sets the theme
  void setThemeMode(ThemeMode themeMode) {
    _themeMode = themeMode;
    updateSystemNavBar();
    notifyListeners();
  }

  void _setSystemNavBar(Brightness brightness) {
    switch (brightness) {
      case Brightness.light:
        Future(() {
          SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
              systemNavigationBarIconBrightness: Brightness.dark,
              systemNavigationBarColor: Color(0xFFf7ead6)));
        });
        return;
      case Brightness.dark:
        Future(() {
          SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
              systemNavigationBarIconBrightness: Brightness.light,
              systemNavigationBarColor: Colors.black));
        });
        return;
    }
  }

  // Updates the system navigation bar (android) to correspond with the theme
  void updateSystemNavBar() {
    // These futures are a hacky fix
    if (_themeMode == ThemeMode.light) {
      _setSystemNavBar(Brightness.light);
    } else if (_themeMode == ThemeMode.dark) {
      _setSystemNavBar(Brightness.dark);
    } else {
      _setSystemNavBar(
          SystemTheme.isDarkMode ? Brightness.dark : Brightness.light);
    }
    notifyListeners();
  }
}
