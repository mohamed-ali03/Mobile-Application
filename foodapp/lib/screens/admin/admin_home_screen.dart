import 'package:flutter/material.dart';
import 'package:foodapp/widgets/my_drawer.dart';

class AdminHomeScreen extends StatelessWidget {
  const AdminHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('admin')),
      drawer: MyDrawer(),
    );
  }
}
