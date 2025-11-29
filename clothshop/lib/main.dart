import 'package:clothshop/models/shop.dart';
import 'package:clothshop/pages/cart_page.dart';
import 'package:clothshop/pages/intro_page.dart';
import 'package:clothshop/pages/shop_page.dart';
import 'package:clothshop/teme/light_mode.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => Shop(),
      builder: (context, child) => const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: IntroPage(),
      theme: lightMode,
      routes: {
        '/introPage': (context) => IntroPage(),
        '/shopPage': (context) => ShopPage(),
        '/cartPage': (context) => CartPage(),
      },
    );
  }
}
