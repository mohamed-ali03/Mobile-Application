import 'package:flutter/material.dart';
import 'package:joke/components/joke_tile.dart';
import 'package:joke/joke_provider/joke_provider.dart';
import 'package:joke/models/joke.dart';
import 'package:provider/provider.dart';

class JokePage extends StatefulWidget {
  const JokePage({super.key});

  @override
  State<JokePage> createState() => _JokePageState();
}

class _JokePageState extends State<JokePage> {
  late Future<bool> getTypes;

  @override
  void initState() {
    getTypes = context.read<JokeProvider>().getTypesProvider();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: FutureBuilder(
          future: getTypes,
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            return Column(
              children: [
                // row contain dropdown and search button
                _selectTypeWidget(),

                // list the joke
                Expanded(child: _listJokes()),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _selectTypeWidget() {
    final provider = context.watch<JokeProvider>();
    return Container(
      margin: EdgeInsets.all(20),
      padding: EdgeInsets.all(10),
      child: DropdownButton<String>(
        padding: EdgeInsets.all(10),
        value: context.watch<JokeProvider>().type,
        hint: const Text("Select type"),
        isExpanded: true,
        items: provider.types
            .map((type) => DropdownMenuItem(value: type, child: Text(type)))
            .toList(),
        onChanged: (value) {
          provider.getTenJokesFromSpecificTypeProvider(value!);
        },
      ),
    );
  }

  Widget _listJokes() {
    List<Joke> jokes = context.watch<JokeProvider>().jokes;
    return ListView.builder(
      itemCount: jokes.length,
      itemBuilder: (context, index) => JokeTile(joke: jokes[index]),
    );
  }
}
