import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant/core/functions.dart';
import 'package:restaurant/feature/auth/provider/auth_provider.dart';

void signInWithGoogle(BuildContext context) async {
  String massege = await context.read<AuthProvider>().signInWithGoogle();

  if (massege.isNotEmpty) {
    showCustomDialog(massege, context);
  }
}

void signInAnonymously(BuildContext context) async {
  String massege = await context.read<AuthProvider>().signInAnonymously();

  if (massege.isNotEmpty) {
    showCustomDialog(massege, context);
  }
}
