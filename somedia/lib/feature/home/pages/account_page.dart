import 'package:flutter/material.dart';
import 'package:somedia/core/utils/size_config.dart';
import 'package:somedia/feature/auth/auth_service/auth_service.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Account'), centerTitle: true),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // icon for person
          Container(
            width: double.infinity,
            child: Icon(Icons.person, size: SizeConfig.defaultSize! * 10),
          ),

          // email of user
          Text(AuthService.getCurrentUser()!.email!),
        ],
      ),
    );
  }
}
