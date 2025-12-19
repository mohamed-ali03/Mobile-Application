import 'package:flutter/material.dart';
import 'package:foodapp/providers/auth_provider.dart';
import 'package:provider/provider.dart';

class UserHomeScreen extends StatelessWidget {
  const UserHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.read<AuthProvider>();
    return Scaffold(
      appBar: AppBar(
        title: Text('user'),
        actions: [
          IconButton(onPressed: () => auth.logout(), icon: Icon(Icons.logout)),
        ],
      ),
    );
  }
}
