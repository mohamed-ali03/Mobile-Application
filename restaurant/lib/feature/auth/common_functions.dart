import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant/core/constants.dart';
import 'package:restaurant/core/functions.dart';
import 'package:restaurant/feature/auth/provider/auth_provider.dart';
import 'package:restaurant/feature/home/provider/app_provider.dart';

void signInWithGoogle(BuildContext context) async {
  final authProvider = context.read<AuthProvider>();
  final appProvider = context.read<AppProvider>();

  RequestStatus status = await context.read<AuthProvider>().signInWithGoogle();

  if (status == RequestStatus.success) {
    final user = authProvider.user!;
    await appProvider.addUser(user);
    // 🔥 DO NOT navigate manually
    // AuthGate will handle routing
  } else if (status == RequestStatus.error) {
    if (!context.mounted) return;
    showCustomDialog(context, 'Error!! please try again');
  } else if (status == RequestStatus.empty) {
    if (!context.mounted) return;
    showCustomDialog(context, 'Invalid empty field!!');
  }
}

void signInAnonymously(BuildContext context) async {
  final authProvider = context.read<AuthProvider>();
  final appProvider = context.read<AppProvider>();
  RequestStatus status = await context.read<AuthProvider>().signInAnonymously();

  if (status == RequestStatus.success) {
    final user = authProvider.user!;
    await appProvider.addUser(user);
    // 🔥 DO NOT navigate manually
    // AuthGate will handle routing
  } else if (status == RequestStatus.error) {
    if (!context.mounted) return;
    showCustomDialog(context, 'Error!! please try again');
  } else if (status == RequestStatus.empty) {
    if (!context.mounted) return;
    showCustomDialog(context, 'Invalid empty field!!');
  }
}
