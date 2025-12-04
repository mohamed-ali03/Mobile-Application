import 'package:authentication/components/custom_button.dart';
import 'package:authentication/components/custom_text_field.dart';
import 'package:authentication/components/logo_container.dart';
import 'package:authentication/functions/show_error.dart';
import 'package:authentication/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  TextEditingController emailController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  TextEditingController confirmedPasswordController = TextEditingController();

  // Sing in button pressed
  void signInFunc() async {
    // loading circle
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      if (passwordController.text.trim() ==
          confirmedPasswordController.text.trim()) {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        );
      } else {
        showErrorToUser('Passwords don\'t match!', context);
      }
      if (!mounted) return;
      Navigator.of(context, rootNavigator: true).pop();
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      Navigator.of(context, rootNavigator: true).pop();

      showErrorToUser(e.code, context);
    }

    emailController.clear();
    passwordController.clear();
  }

  void haveAccountFunc() {
    Navigator.pushNamed(context, '/loginpage');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 100),
              // logo
              Icon(Icons.lock, size: 150),

              SizedBox(height: 20),

              // welcome back you've been missed
              Text(
                'Welcome back you\'ve been missed',
                style: TextStyle(fontSize: 20, color: Colors.grey.shade700),
              ),
              SizedBox(height: 20),
              // email name field
              CustomTextField(
                hint: 'Email',
                controller: emailController,
                obscureText: false,
              ),

              SizedBox(height: 20),

              // password field
              CustomTextField(
                hint: 'password',
                controller: passwordController,
                obscureText: true,
              ),

              SizedBox(height: 20),
              // confermed password field
              CustomTextField(
                hint: 'confirm password',
                controller: confirmedPasswordController,
                obscureText: true,
              ),
              SizedBox(height: 20),
              // sign in button
              CustomButton(onTap: signInFunc, text: 'Sign Up'),

              SizedBox(height: 20),

              // or continue with
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Divider(
                        color: Colors.grey.shade500,
                        thickness: 0.5,
                      ),
                    ),

                    Text(' or continue with '),

                    Expanded(
                      child: Divider(
                        color: Colors.grey.shade500,
                        thickness: 0.5,
                      ),
                    ),
                  ],
                ),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // google and apple logo
                  LogoContainer(
                    imagePath: 'assets/images/google_logo.png',
                    onTap: () => AuthService().signInWithGoogle(),
                  ),

                  SizedBox(width: 10),

                  LogoContainer(
                    imagePath: 'assets/images/Apple_logo.png',
                    onTap: () {},
                  ),
                ],
              ),

              SizedBox(height: 20),
              // not a member register now
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Have an account? '),
                  GestureDetector(
                    onTap: haveAccountFunc,
                    child: Text(
                      'Sign in Now',
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
