import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:restaurant/feature/auth/firebase/auth_fire_base.dart';
import 'package:restaurant/feature/models/user.dart';

class AuthProvider extends ChangeNotifier {
  late UserCredential userCredential;
  Future<User?> getCurrentUser() async {
    return FirebaseAuth.instance.currentUser;
  }

  // create new account using email and password
  Future<String> createAccountWithEmailAndPassword(
    UserModel user,
    String password,
    String confirmedPassword,
  ) async {
    try {
      if (password.trim() != confirmedPassword.trim()) {
        return 'الباسورد غير متطابق';
      } else if (user.email!.isEmpty ||
          user.name!.isEmpty ||
          password.isEmpty ||
          confirmedPassword.isEmpty) {
        return 'يجب ملئ الخانات قبل التسجيل';
      } else {
        userCredential = await AuthFireBase.createAccountWithEmailAndPassword(
          user.name!.trim(),
          user.email!.trim(),
          password.trim(),
        );
        return '';
      }
    } catch (e) {
      return (e.toString());
    }
  }

  // sign in using email and password
  Future<String> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      if (email.trim().isNotEmpty && password.trim().isNotEmpty) {
        userCredential = await AuthFireBase.signInWithEmailAndPassword(
          email.trim(),
          password.trim(),
        );
        return '';
      } else {
        return '!!يجب ملئ الخانات قبل تسجيل الدخول';
      }
    } catch (e) {
      return e.toString();
    }
  }

  // create new account or sign in using google
  Future<String> signInWithGoogle() async {
    try {
      userCredential = await AuthFireBase.signInWithGoogle();
      // TODO : add user data to database

      return '';
    } catch (e) {
      return e.toString();
    }
  }

  // create new account or sign in using facebook

  // access as anonymous
  Future<String> signInAnonymously() async {
    try {
      userCredential = await AuthFireBase.signInAnonymously();
      return '';
    } catch (e) {
      return e.toString();
    }
  }

  // logout
  Future<void> logout() async {
    await AuthFireBase.logout();
  }
}
