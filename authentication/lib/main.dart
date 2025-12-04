import 'package:authentication/pages/auth_page.dart';
import 'package:authentication/pages/home_page.dart';
import 'package:authentication/pages/signup_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    name: 'auth-tutorial-753f1',
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const AuthPage(),
      routes: {
        '/authpage': (context) => AuthPage(),
        '/homepage': (context) => HomePage(),
        '/signuppage': (context) => SignupPage(),
      },
    );
  }
}
