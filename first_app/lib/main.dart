import 'package:first_app/counter_page.dart';
import 'package:first_app/first_page.dart';
import 'package:first_app/home_page.dart';
import 'package:first_app/settings_page.dart';
import 'package:first_app/textfield.dart';
import 'package:first_app/voicepage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    List names = ['Mohamed', 'Jack', 'Sparrow'];
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Voicepage(),
      routes: {
        '\firstpage': (context) => FirstPage(),
        '\homepage': (context) => HomePage(),
        '\settingspage': (context) => SettingsPage(),
      },
    );
  }
}
