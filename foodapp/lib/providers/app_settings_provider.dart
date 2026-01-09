import 'package:flutter/foundation.dart';

class AppSettingsProvider extends ChangeNotifier {
  bool _isDarkMode = false;
  String lang = 'ar';

  bool get isDarkMode => _isDarkMode;

  void toggleDarkMode() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }

  void setLanguage(String language) {
    lang = language;
    notifyListeners();
  }
}
