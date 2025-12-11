import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant/core/functions.dart';
import 'package:restaurant/core/size_config.dart';
import 'package:restaurant/core/widgets/custom_button.dart';
import 'package:restaurant/core/widgets/custom_textfield.dart';
import 'package:restaurant/core/widgets/federated_button.dart';
import 'package:restaurant/feature/auth/common_functions.dart';
import 'package:restaurant/feature/auth/provider/auth_provider.dart';
import 'package:restaurant/feature/models/user.dart';

class RegisterPage extends StatefulWidget {
  final Function()? onTap;
  const RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterState();
}

class _RegisterState extends State<RegisterPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  void regiserWithEmailAndPassword() async {
    UserModel user = UserModel(
      name: nameController.text,
      email: emailController.text,
    );
    String message = await context
        .read<AuthProvider>()
        .createAccountWithEmailAndPassword(
          user,
          passwordController.text,
          confirmPasswordController.text,
        );

    if (!mounted) return;
    if (message.isNotEmpty) {
      showCustomDialog(message, context);
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // logo
            Icon(Icons.food_bank, size: SizeConfig.defaultSize! * 10),
            SizedBox(height: SizeConfig.defaultSize!),

            // welcome message
            Text('مرحبا بكم في مطعمنا'),
            SizedBox(height: SizeConfig.defaultSize!),

            // username field
            CustomTextField(
              hint: 'الاسم',
              controller: nameController,
              obscureText: false,
            ),
            SizedBox(height: SizeConfig.defaultSize!),

            // email field
            CustomTextField(
              hint: 'الإيميل',
              controller: emailController,
              obscureText: false,
            ),
            SizedBox(height: SizeConfig.defaultSize!),

            // password field
            CustomTextField(
              hint: 'الرقم السري',
              controller: passwordController,
              obscureText: true,
            ),

            SizedBox(height: SizeConfig.defaultSize!),

            // confirm password field
            CustomTextField(
              hint: 'تأكيد الرقم السري',
              controller: confirmPasswordController,
              obscureText: true,
            ),
            SizedBox(height: SizeConfig.defaultSize!),

            // sign in button
            CustomButton(
              text: 'تسجيل الحساب',
              onTap: regiserWithEmailAndPassword,
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
                    child: Divider(color: Colors.grey.shade700, thickness: 0.5),
                  ),
                  Text('  او سجل باستخدام  '),
                  Expanded(
                    child: Divider(color: Colors.grey.shade700, thickness: 0.5),
                  ),
                ],
              ),
            ),
            SizedBox(height: SizeConfig.defaultSize! * 0.5),

            // other federated identities
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
                  child: Text('سجل الان', style: TextStyle(color: Colors.blue)),
                ),
                Text(' هل لديك حساب ؟'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
