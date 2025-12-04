import 'package:authentication/components/custom_button.dart';
import 'package:authentication/components/custom_text_field.dart';
import 'package:authentication/components/logo_container.dart';
import 'package:authentication/functions/show_error.dart';
import 'package:authentication/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  final void Function()? newRegisteration;
  const LoginPage({super.key, required this.newRegisteration});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  // user forget the password
  void forgetPasswordFunc() {}
  // Sing in button pressed
  void signInFunc() async {
    // loading circle
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

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

  // sign in with Apple acount
  void signInWithApple() {}

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
              // forget password
              SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: forgetPasswordFunc,
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
              CustomButton(onTap: signInFunc, text: 'Sign in'),

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
                    onTap: signInWithApple,
                  ),
                ],
              ),

              SizedBox(height: 20),
              // not a member register now
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Not a member? '),
                  GestureDetector(
                    onTap: widget.newRegisteration,
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
      ),
    );
  }
}
