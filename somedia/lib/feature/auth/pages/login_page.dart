import 'package:flutter/material.dart';
import 'package:somedia/core/common_functions.dart';
import 'package:somedia/core/utils/size_config.dart';
import 'package:somedia/core/widgets/custom_button.dart';
import 'package:somedia/core/widgets/custom_text_field.dart';
import 'package:somedia/feature/auth/auth_service/auth_service.dart';

class LoginPage extends StatefulWidget {
  final Function()? onTap;
  const LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void signIn() async {
    // show loading circle
    showDialog(
      context: context,
      builder: (_) => Center(child: CircularProgressIndicator()),
    );

    // try to sign in
    try {
      if (emailController.text.isNotEmpty &&
          passwordController.text.isNotEmpty) {
        await AuthService.signInUserWithEmailAndPassword(
          emailController.text.trim(),
          passwordController.text.trim(),
        );
        emailController.clear();
        passwordController.clear();

        if (!mounted) return;
        Navigator.pop(context);
      } else {
        if (!mounted) return;
        Navigator.pop(context);
        showCustomDialog('Field is empty!!', context);
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
            SizedBox(height: SizeConfig.defaultSize! * 0.3),

            // forget the password
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
                Padding(
                  padding: EdgeInsets.only(right: SizeConfig.defaultSize!),
                ),
              ],
            ),

            SizedBox(height: SizeConfig.defaultSize!),
            // button to sign in
            CustomButton(text: 'Sign In', onTap: signIn),
            SizedBox(height: SizeConfig.defaultSize!),

            // register now
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Don\'t have an account? '),
                GestureDetector(
                  onTap: widget.onTap,
                  child: Text(
                    'Regiter Now',
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
