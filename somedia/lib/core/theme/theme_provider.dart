import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:somedia/core/theme/theme.dart';

class ThemeProvider extends ChangeNotifier {
  // make a theme instance
  static ThemeData _themeData = lightMode;

  // define a shared preferences object
  late SharedPreferences prefs;

  // getter for theme data
  ThemeData get themeData => _themeData;

  // make a constructor to load the mode in the beginning of the app
  ThemeProvider() {
    _loadTheme();
  }

  void _loadTheme() async {
    // initialize prefs as  instance of shared prefrences
    prefs = await SharedPreferences.getInstance();

    // if is it dark mode
    bool isDark = prefs.getBool('isDarkMode') ?? false;

    // change the theme if needed
    themeData = isDark ? darkMode : lightMode;
  }

  // setter for theme data
  set themeData(ThemeData theme) {
    _themeData = theme;
    notifyListeners();
  }

  // check if it dark mode
  bool isDarkMode() => _themeData == darkMode;

  // toggle function
  void toggleTheme() {
    if (_themeData == lightMode) {
      themeData = darkMode;
      prefs.setBool('isDarkMode', true);
    } else {
      themeData = lightMode;
      prefs.setBool('isDarkMode', false);
    }
  }
}
