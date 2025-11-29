import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoeshop/models/cart.dart';
import 'package:shoeshop/pages/home_page.dart';
import 'package:shoeshop/pages/intro_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => Cart(),
      builder: (context, child) => MaterialApp(
        debugShowCheckedModeBanner: false,
        home: IntroPage(),
        routes: {'/homepage': (context) => HomePage()},
      ),
    );
  }
}
