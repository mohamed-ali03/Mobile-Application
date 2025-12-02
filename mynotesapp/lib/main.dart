import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:mynotesapp/pages/note_page.dart';
import 'package:mynotesapp/pages/settings_page.dart';
import 'package:mynotesapp/theme/theme_provider.dart';
import 'package:provider/provider.dart';

void main() async {
  await Hive.initFlutter();

  var box = await Hive.openBox('mybox');

  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: NotePage(),
      theme: Provider.of<ThemeProvider>(context).appTheme,
      routes: {
        '/notePage': (context) => NotePage(),
        '/settingsPage': (context) => SettingsPage(),
      },
    );
  }
}
