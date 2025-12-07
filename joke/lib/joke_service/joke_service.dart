import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:joke/models/joke.dart';

class JokeService extends ChangeNotifier {
  // ignore: constant_identifier_names
  static const String BASE_URL = 'official-joke-api.appspot.com';

  late Joke oneJoke;
  List<String> _types = [];
  List<Joke> _jokes = [];

  // Getters
  List<String> get typesList => _types;
  List<Joke> get jokesList => _jokes;

  // Setters
  set jokes(List<Joke> value) {
    _jokes = value;
    notifyListeners();
  }

  set types(List<String> value) {
    _types = value;
    notifyListeners();
  }

  Future<void> getOneRandomJoke() async {
    final response = await http.get(Uri.https(BASE_URL, '/random_joke'));

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      oneJoke = Joke.fromJson(decoded);
      notifyListeners();
    }
  }

  Future<void> getJokeTypes() async {
    final response = await http.get(Uri.https(BASE_URL, '/types'));

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      types = (decoded as List).map((item) => item.toString()).toList();
    }
  }

  Future<void> getNumOfJokes(String type) async {
    final response = await http.get(Uri.https(BASE_URL, '/jokes/$type/ten'));

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      jokes = (decoded as List).map((item) => Joke.fromJson(item)).toList();
    }
  }
}
