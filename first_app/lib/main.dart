import 'package:first_app/provider/my_provider.dart';
import 'package:first_app/textfield.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(create: (_) => MyProvider(), child: const MyApp()),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  TextEditingController textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Container(
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Selector<MyProvider, String>(
                selector: (_, provider) => provider.name,
                builder: (_, value, _) => Text(value),
              ),

              TextField(controller: textEditingController),
              IconButton(
                onPressed: () => context.read<MyProvider>().changeName(
                  textEditingController.text,
                ),
                icon: Icon(Icons.send),
              ),

              Selector<MyProvider, int>(
                selector: (_, MyProvider provider) => provider.counter,
                builder: (_, value, _) => Text(value.toString()),
              ),

              IconButton(
                onPressed: () => context.read<MyProvider>().incrementCounter(),
                icon: Icon(Icons.add),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
