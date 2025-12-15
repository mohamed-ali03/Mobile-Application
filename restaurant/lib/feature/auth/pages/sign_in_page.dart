import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant/core/constants.dart';
import 'package:restaurant/core/functions.dart';
import 'package:restaurant/core/size_config.dart';
import 'package:restaurant/core/widgets/custom_button.dart';
import 'package:restaurant/core/widgets/custom_ar_tf.dart';
import 'package:restaurant/core/widgets/federated_button.dart';
import 'package:restaurant/feature/auth/common_functions.dart';
import 'package:restaurant/feature/auth/provider/auth_provider.dart';
import 'package:restaurant/feature/home/provider/app_provider.dart';

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
    final authProvider = context.read<AuthProvider>();
    final appProvider = context.read<AppProvider>();

    RequestStatus status = await context
        .read<AuthProvider>()
        .signInWithEmailAndPassword(
          emailController.text,
          passwordController.text,
        );

    if (status == RequestStatus.success) {
      final user = authProvider.user!;
      await appProvider.addUser(user);
      // 🔥 DO NOT navigate manually
      // AuthGate will handle routing
    } else if (status == RequestStatus.error) {
      if (!mounted) return;
      showCustomDialog(context, 'Error!! please try again');
    } else if (status == RequestStatus.empty) {
      if (!mounted) return;
      showCustomDialog(context, 'Invalid empty field!!');
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
              SizedBox(height: 10),
              // welcome message
              Text('مرحبا بكم في مطعمنا'),
              SizedBox(height: 20),

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

              SizedBox(height: 5),
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

              SizedBox(height: 20),
              // sign in button
              CustomButton(
                text: 'تسجيل الدخول',
                onTap: signInWithEmailAndPassword,
              ),
              SizedBox(height: 30),

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
              SizedBox(height: 10),

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
              SizedBox(height: 10),

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
