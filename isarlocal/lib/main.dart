import 'package:flutter/material.dart';
import 'package:isarlocal/models/notes/note_database.dart';
import 'package:isarlocal/pages/notes_page.dart';
import 'package:isarlocal/pages/settings_page.dart';
import 'package:isarlocal/theme/theme_provider.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NoteDatabase().init();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => NoteDatabase()),
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
      ],
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
      home: NotesPage(),
      theme: Provider.of<ThemeProvider>(context).themeData,
      routes: {
        '/notespage': (context) => NotesPage(),
        '/settingspage': (context) => SettingsPage(),
      },
    );
  }
}
