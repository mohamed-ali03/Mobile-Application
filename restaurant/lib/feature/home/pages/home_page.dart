import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant/feature/auth/provider/auth_provider.dart';
import 'package:restaurant/feature/home/firestore/firestore.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () => context.read<AuthProvider>().logout(),
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      body: Center(
        child: IconButton(
          onPressed: () => Firestore.getCategory('Vk4I9sM3AHtBHa4IqkhX'),
          icon: Icon(Icons.receipt),
        ),
      ),
    );
  }
}
