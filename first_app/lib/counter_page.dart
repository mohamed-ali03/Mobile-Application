import 'package:flutter/material.dart';

class CounterPage extends StatefulWidget {
  const CounterPage({super.key});

  @override
  State<CounterPage> createState() => _CounterPageState();
}

class _CounterPageState extends State<CounterPage> {
  int _counter = 0;
  bool _longpress = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Counter')),

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Don\'t Tape the button', style: TextStyle(fontSize: 28)),
            Text(_counter.toString(), style: TextStyle(fontSize: 28)),
            ElevatedButton(
              onLongPress: () {
                setState(() {
                  _longpress = true;
                });
              },
              onPressed: () {
                setState(() {
                  _counter++;
                  _longpress = false;
                });
              },
              child: Icon(Icons.add),
            ),
            if (_longpress) Text('Leave the button asshole'),
          ],
        ),
      ),
    );
  }
}
