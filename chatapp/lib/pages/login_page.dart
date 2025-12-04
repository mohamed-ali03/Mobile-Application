import 'package:chatapp/services/auth_service/auth_service.dart';
import 'package:chatapp/components/custom_button.dart';
import 'package:chatapp/components/custom_text_field.dart';
import 'package:chatapp/functions/showcustomdialog.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  final void Function()? onTap;
  const LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  void login(BuildContext context) async {
    try {
      await AuthService().signInWithEmailAndPassword(
        emailController.text.trim(),
        passwordController.text.trim(),
      );
      emailController.clear();
      passwordController.clear();
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

            // forget password
            SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () {},
                  child: Text(
                    'Forget Password?',
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
                Padding(padding: EdgeInsetsGeometry.only(right: 20)),
              ],
            ),

            SizedBox(height: 20),
            // sign in button
            CustomButton(text: 'Sign in', onTap: () => login(context)),
            SizedBox(height: 20),

            // don't have an account
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Not a member? '),
                GestureDetector(
                  onTap: widget.onTap,
                  child: Text(
                    'Register Now',
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
