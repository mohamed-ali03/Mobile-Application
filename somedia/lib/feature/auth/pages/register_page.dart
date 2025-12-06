import 'package:flutter/material.dart';
import 'package:somedia/core/common_functions.dart';
import 'package:somedia/core/utils/size_config.dart';
import 'package:somedia/core/widgets/custom_button.dart';
import 'package:somedia/core/widgets/custom_text_field.dart';
import 'package:somedia/feature/auth/auth_service/auth_service.dart';

class RegisterPage extends StatefulWidget {
  final Function() onTap;
  const RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController emailController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  TextEditingController confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  void signUp() async {
    // show loading circle
    showDialog(
      context: context,
      builder: (_) => Center(child: CircularProgressIndicator()),
    );

    // try to sign in
    try {
      if (emailController.text.isEmpty ||
          passwordController.text.isEmpty ||
          confirmPasswordController.text.isEmpty) {
        if (!mounted) return;
        Navigator.pop(context);
        showCustomDialog('Field is empty!!', context);
      } else if (passwordController.text.trim() !=
          confirmPasswordController.text.trim()) {
        if (!mounted) return;
        Navigator.pop(context);
        showCustomDialog('Passwords not match!!', context);
      } else {
        await AuthService.signUpUserWithEmailAndPassword(
          emailController.text.trim(),
          passwordController.text.trim(),
        );
        emailController.clear();
        passwordController.clear();

        if (!mounted) return;
        Navigator.pop(context);
      }
    } catch (e) {
      if (!mounted) return;
      Navigator.pop(context);
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
              Icons.people,
              size: SizeConfig.defaultSize! * 12,
              color: Theme.of(context).colorScheme.inversePrimary,
            ),

            // app name
            Text(
              'SoMedia : Social media for everyone :)',
              style: TextStyle(
                color: Theme.of(context).colorScheme.inversePrimary,
                fontSize: SizeConfig.defaultSize!,
              ),
            ),

            SizedBox(height: SizeConfig.defaultSize),

            // field for username
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: SizeConfig.defaultSize!,
              ),
              child: CustomTextField(
                controller: emailController,
                hint: 'Email',
                obscureText: false,
              ),
            ),

            SizedBox(height: SizeConfig.defaultSize),

            // field for password
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: SizeConfig.defaultSize!,
              ),
              child: CustomTextField(
                controller: passwordController,
                hint: 'Password',
                obscureText: true,
              ),
            ),
            SizedBox(height: SizeConfig.defaultSize),

            // field for confirm password
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: SizeConfig.defaultSize!,
              ),
              child: CustomTextField(
                controller: confirmPasswordController,
                hint: 'Confirm Password',
                obscureText: true,
              ),
            ),
            SizedBox(height: SizeConfig.defaultSize! * 2),

            // button to sign in
            CustomButton(text: 'Sign Up', onTap: signUp),
            SizedBox(height: SizeConfig.defaultSize!),

            // Login now
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('have an account? '),
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
