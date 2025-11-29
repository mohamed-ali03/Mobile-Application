import 'package:flutter/material.dart';

class Textfield extends StatefulWidget {
  const Textfield({super.key});

  @override
  State<Textfield> createState() => _TextfieldState();
}

class _TextfieldState extends State<Textfield> {
  TextEditingController? _textcontroller = TextEditingController();

  String text = '';

  void returnNam() {
    setState(() {
      text = "Fuck " + _textcontroller!.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(text),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 100,
                vertical: 20,
              ),
              child: TextField(
                controller: _textcontroller,
                autocorrect: true,
                decoration: InputDecoration(
                  hint: Text('Enter your name ....'),
                  border: OutlineInputBorder(),
                ),
              ),
            ),

            ElevatedButton(onPressed: returnNam, child: Text('Send')),
          ],
        ),
      ),
    );
  }
}
