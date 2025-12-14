import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant/core/functions.dart';
import 'package:restaurant/core/size_config.dart';
import 'package:restaurant/core/widgets/custom_button.dart';
import 'package:restaurant/core/widgets/custom_ar_tf.dart';
import 'package:restaurant/core/widgets/federated_button.dart';
import 'package:restaurant/feature/auth/common_functions.dart';
import 'package:restaurant/feature/auth/provider/auth_provider.dart';

class SignInPage extends StatefulWidget {
  final Function()? onTap;
  const SignInPage({super.key, required this.onTap});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  void signInWithEmailAndPassword() async {
    String messege = await context
        .read<AuthProvider>()
        .signInWithEmailAndPassword(
          emailController.text,
          passwordController.text,
        );

    if (!mounted) return;
    if (messege.isNotEmpty) {
      showCustomDialog(context, messege);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // logo
              Icon(Icons.food_bank, size: SizeConfig.defaultSize! * 10),
              SizedBox(height: SizeConfig.defaultSize),
              // welcome message
              Text('مرحبا بكم في مطعمنا'),
              SizedBox(height: SizeConfig.defaultSize),

              // email field
              CustomArTF(
                hint: 'الايميل',
                controller: emailController,
                obscureText: false,
              ),
              SizedBox(height: 20),

              // password field
              CustomArTF(
                hint: 'الرقم السري',
                controller: passwordController,
                obscureText: true,
              ),

              // forget password
              SizedBox(height: SizeConfig.defaultSize! * 0.25),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {},
                    child: Text(
                      'هل نسيت كلمة السر ؟',
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                ],
              ),

              SizedBox(height: SizeConfig.defaultSize!),
              // sign in button
              CustomButton(
                text: 'تسجيل الدخول',
                onTap: signInWithEmailAndPassword,
              ),
              SizedBox(height: SizeConfig.defaultSize!),

              // or sign in with other methods
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: SizeConfig.defaultSize!,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Divider(
                        color: Colors.grey.shade700,
                        thickness: 0.5,
                      ),
                    ),
                    Text('  او سجل باستخدام  '),
                    Expanded(
                      child: Divider(
                        color: Colors.grey.shade700,
                        thickness: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: SizeConfig.defaultSize! * 0.5),

              // or sign in with other methods
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FederatedButton(
                    onTap: () => signInWithGoogle(context),
                    widget: Image.asset('assets/icons/google_logo.png'),
                  ),
                  FederatedButton(
                    onTap: () {},
                    widget: Image.asset('assets/icons/Facebook_icon.png'),
                  ),
                  FederatedButton(
                    onTap: () => signInAnonymously(context),
                    widget: Icon(
                      Icons.person,
                      size: SizeConfig.defaultSize! * 2.5,
                    ),
                  ),
                ],
              ),
              SizedBox(height: SizeConfig.defaultSize!),

              // don't have an account
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: widget.onTap,
                    child: Text(
                      '  سجل الان  ',
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                  Text('اريد تسجيل حساب جديد ؟'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
