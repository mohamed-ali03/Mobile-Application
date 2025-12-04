// ignore_for_file: use_build_context_synchronously

import 'package:chatapp/services/auth_service/auth_service.dart';
import 'package:chatapp/components/custom_button.dart';
import 'package:chatapp/components/custom_text_field.dart';
import 'package:chatapp/functions/showcustomdialog.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  final void Function()? onTap;
  const RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController emailController = TextEditingController();

  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  void signUp(BuildContext context) async {
    try {
      if (passwordController.text == confirmPasswordController.text) {
        await AuthService().signUpWithEmailAndPassword(
          emailController.text.trim(),
          passwordController.text.trim(),
        );
        emailController.clear();
        passwordController.clear();
      } else {
        showCustomDialog('Passwords are not match!', context);
      }
    } catch (e) {
      showCustomDialog(e.toString(), context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // logo
            Icon(
              Icons.message,
              size: 150,
              color: Theme.of(context).colorScheme.inversePrimary,
            ),
            SizedBox(height: 20),
            // welcome message
            Text(
              'Welcome to our chating app',
              style: TextStyle(
                color: Theme.of(context).colorScheme.inversePrimary,
              ),
            ),
            SizedBox(height: 20),

            // email field
            CustomTextField(
              hint: 'Email',
              controller: emailController,
              obscureText: false,
            ),
            SizedBox(height: 20),

            // password field
            CustomTextField(
              hint: 'Password',
              controller: passwordController,
              obscureText: true,
            ),
            SizedBox(height: 20),

            // password field
            CustomTextField(
              hint: 'Confirm Password',
              controller: confirmPasswordController,
              obscureText: true,
            ),
            SizedBox(height: 20),

            // sign in button
            CustomButton(text: 'Sign up', onTap: () => signUp(context)),
            SizedBox(height: 20),

            // don't have an account
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Have an account? '),
                GestureDetector(
                  onTap: widget.onTap,
                  child: Text(
                    'Login Now',
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
