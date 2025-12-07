import 'package:flutter/material.dart';
import 'package:joke/joke_service/joke_service.dart';
import 'package:joke/models/joke.dart';
import 'package:provider/provider.dart';

class JokePage extends StatefulWidget {
  const JokePage({super.key});

  @override
  State<JokePage> createState() => _JokePageState();
}

class _JokePageState extends State<JokePage> {
  String? selectedType;

  @override
  void initState() {
    super.initState();

    final jokeService = Provider.of<JokeService>(context, listen: false);

    // load types and default jokes
    jokeService.getJokeTypes();
    jokeService.getNumOfJokes("general");
  }

  @override
  Widget build(BuildContext context) {
    final jokeService = Provider.of<JokeService>(context);
    final List<Joke> jokes = jokeService.jokesList;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // row contain dropdown and search button
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
              child: Row(
                children: [
                  Expanded(
                    child: DropdownButton<String>(
                      value: selectedType,
                      hint: const Text("Select type"),
                      isExpanded: true,
                      items: jokeService.typesList
                          .map(
                            (type) => DropdownMenuItem(
                              value: type,
                              child: Text(type),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        if (value == null) return;

                        setState(() {
                          selectedType = value;
                        });

                        Provider.of<JokeService>(
                          context,
                          listen: false,
                        ).getNumOfJokes(value);
                      },
                    ),
                  ),

                  Container(
                    margin: const EdgeInsets.only(left: 20),
                    decoration: const BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.search, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),

            // list view of jokes
            Expanded(
              child: ListView.builder(
                itemCount: jokes.length,
                itemBuilder: (context, index) => Container(
                  padding: EdgeInsets.all(10),
                  margin: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    title: Text(jokes[index].type),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text(
                        '${jokes[index].setup}.....${jokes[index].punchline}',
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
