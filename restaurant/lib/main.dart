import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant/core/theme/theme.dart';
import 'package:restaurant/feature/auth/pages/auth_gate.dart';
import 'package:restaurant/feature/auth/provider/auth_provider.dart';
import 'package:restaurant/feature/home/provider/fire_store_provider.dart';
import 'package:restaurant/firebase_options.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    name: 'project-828397665782',
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await Supabase.initialize(
    url: 'https://iflxomgtgrhoggbhlkfa.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImlmbHhvbWd0Z3Job2dnYmhsa2ZhIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjU3MDA5NzQsImV4cCI6MjA4MTI3Njk3NH0.ZoKs-L1IfDUccr57RbdbG-wy2xYcDbv9POWtOvcL5RY',
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthProvider()),
        ChangeNotifierProvider(create: (context) => FireStoreProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    //SizeConfig.init(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: appTheme,
      home: AuthGate(),
    );
  }
}
