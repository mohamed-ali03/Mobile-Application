import 'package:flutter/material.dart';
import 'package:habittracker/database/database.dart';
import 'package:habittracker/pages/home_page.dart';
import 'package:habittracker/theme/theme_provider.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Database().initDatebase();
  await Database().saveFirstLaunchTime();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
        ChangeNotifierProvider(create: (context) => Database()),
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
      theme: Provider.of<ThemeProvider>(context).themeData,
      home: HomePage(),
      routes: {'/homepage': (context) => HomePage()},
    );
  }
}
