import 'package:flutter/material.dart';

/// This class provides an interface to globally access
/// and change the app theme
class ThemeProvider extends ChangeNotifier {
  // Defaults to the system's theme
  ThemeMode _themeMode = ThemeMode.system;

  ThemeProvider() {
    _themeMode = ThemeMode.system;
  }

  /// Gets the current theme
  ThemeMode get getThemeMode => _themeMode;

  /// Sets the theme
  void setThemeMode(ThemeMode themeMode) {
    _themeMode = themeMode;
    notifyListeners();
  }
}
