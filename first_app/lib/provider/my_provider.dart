import 'package:flutter/foundation.dart';

class MyProvider extends ChangeNotifier {
  int counter = 0;
  String name = "Mohamed";

  void incrementCounter() {
    counter++;
    notifyListeners();
  }

  void changeName(String newName) {
    name = newName;
    notifyListeners();
  }
}
