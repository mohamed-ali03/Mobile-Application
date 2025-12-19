import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant/core/constants.dart';
import 'package:restaurant/core/functions.dart';
import 'package:restaurant/core/widgets/custom_button.dart';
import 'package:restaurant/core/widgets/custom_ar_tf.dart';
import 'package:restaurant/core/widgets/federated_button.dart';
import 'package:restaurant/feature/auth/common_functions.dart';
import 'package:restaurant/feature/auth/provider/auth_provider.dart';
import 'package:restaurant/feature/home/provider/fire_store_provider.dart';
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

  late FireStoreProvider fireStoreProvider;
  late AuthProvider authProvider;

  void regiserWithEmailAndPassword() async {
    final status = await authProvider.createAccountWithEmailAndPassword(
      UserModel(name: nameController.text, email: emailController.text),
      passwordController.text,
      confirmPasswordController.text,
    );

    if (status == RequestStatus.success) {
      final user = authProvider.currentUser!;
      await fireStoreProvider.addUser(user);
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
  void initState() {
    authProvider = context.read<AuthProvider>();
    fireStoreProvider = context.read<FireStoreProvider>();
    super.initState();
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
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 200),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // logo
                Icon(Icons.food_bank, size: 200),
                SizedBox(height: 10),

                // welcome message
                Text('مرحبا بكم في مطعمنا'),
                SizedBox(height: 20),

                // username field
                CustomArTF(
                  hint: 'الاسم',
                  controller: nameController,
                  obscureText: false,
                ),
                SizedBox(height: 20),

                // email field
                CustomArTF(
                  hint: 'الإيميل',
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

                SizedBox(height: 20),

                // confirm password field
                CustomArTF(
                  hint: 'تأكيد الرقم السري',
                  controller: confirmPasswordController,
                  obscureText: true,
                ),
                SizedBox(height: 20),

                // sign in button
                CustomButton(
                  text: 'تسجيل الحساب',
                  onTap: regiserWithEmailAndPassword,
                ),
                SizedBox(height: 20),

                // or sign in with other methods
                Row(
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
                SizedBox(height: 20),

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
                      widget: Icon(Icons.person, size: 50),
                    ),
                  ],
                ),
                SizedBox(height: 20),

                // don't have an account
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: widget.onTap,
                      child: Text(
                        'سجل الان',
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                    Text(' هل لديك حساب ؟'),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
