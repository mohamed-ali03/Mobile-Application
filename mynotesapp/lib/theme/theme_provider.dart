import 'package:flutter/material.dart';
import 'package:mynotesapp/theme/theme.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeData _appTheme = lightMode;

  ThemeData get appTheme => _appTheme;

  bool isDarkMode() {
    return appTheme == darkMode;
  }

  set appTheme(ThemeData theme) {
    _appTheme = theme;
    notifyListeners();
  }

  void toggleTheme() {
    if (_appTheme == lightMode) {
      appTheme = darkMode;
    } else {
      appTheme = lightMode;
    }
  }
}
