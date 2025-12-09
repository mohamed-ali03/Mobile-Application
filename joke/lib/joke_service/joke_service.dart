import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:joke/models/joke.dart';

/*
    APIs
*/

// get types                   -->  https://official-joke-api.appspot.com/types (get)

// get ten jokes from one type -->  https://official-joke-api.appspot.com/jokes/programming/ten

// get number of random jokes  -->  https://official-joke-api.appspot.com/jokes/random/5

class JokeService {
  static const BASEURL = 'official-joke-api.appspot.com';

  static Future<List<String>> getTypesService() async {
    try {
      final response = await http.get(Uri.https(BASEURL, '/types'));

      if (response.statusCode == 200) {
        List<String> typesList = (jsonDecode(response.body) as List)
            .map((type) => type.toString())
            .toList();
        return typesList;
      } else {
        throw Exception(response.statusCode);
      }
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }

  static Future<List<Joke>> getJokesFromOneTypeService(String type) async {
    try {
      final response = await http.get(Uri.https(BASEURL, '/jokes/$type/ten'));

      if (response.statusCode == 200) {
        List<Joke> jokesList = (jsonDecode(response.body) as List)
            .map((joke) => Joke.fromJson(joke))
            .toList();
        return jokesList;
      } else {
        throw Exception(response.statusCode);
      }
    } catch (e) {
      rethrow;
    }
  }
}
