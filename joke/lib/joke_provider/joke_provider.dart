import 'package:flutter/material.dart';
import 'package:joke/joke_service/joke_service.dart';
import 'package:joke/models/joke.dart';

class JokeProvider extends ChangeNotifier {
  // list of types
  List<String> types = ['Select type'];
  // list of jokes
  List<Joke> jokes = [];
  // selected type
  String type = 'Select type';

  // get types of jokes
  Future<bool> getTypesProvider() async {
    try {
      types.clear();
      types.add(type);
      types.addAll(await JokeService.getTypesService());
      notifyListeners();
      return true;
    } catch (e) {
      types.clear();
      types.add('Select type');
      return false;
    }
  }

  // get ten jokes from specific type
  Future<void> getTenJokesFromSpecificTypeProvider(String selectedtype) async {
    try {
      type = selectedtype;
      notifyListeners();
      jokes.clear();
      jokes = await JokeService.getJokesFromOneTypeService(type);
      notifyListeners();
    } catch (e) {
      jokes.clear();
    }
  }
}
