import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:restaurant/core/constants.dart';
import 'package:restaurant/feature/auth/firebase/auth_fire_base.dart';
import 'package:restaurant/feature/home/firestore/firestore.dart';
import 'package:restaurant/feature/models/user.dart';

class AuthProvider extends ChangeNotifier {
  UserModel? user;
  Future<User?> getCurrentUser() async {
    return FirebaseAuth.instance.currentUser;
  }

  // create new account using email and password
  Future<RequestStatus> createAccountWithEmailAndPassword(
    UserModel user,
    String password,
    String confirmedPassword,
  ) async {
    try {
      if (password.trim() != confirmedPassword.trim()) {
        return RequestStatus.error;
      } else if (user.email!.isEmpty ||
          user.name!.isEmpty ||
          password.isEmpty ||
          confirmedPassword.isEmpty) {
        return RequestStatus.empty;
      } else {
        this.user = await AuthFireBase.createAccountWithEmailAndPassword(
          user.name!.trim(),
          user.email!.trim(),
          password.trim(),
        );

        return RequestStatus.success;
      }
    } catch (e) {
      debugPrint('SignUp with password error: $e');
      return RequestStatus.error;
    }
  }

  // sign in using email and password
  Future<RequestStatus> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      if (email.trim().isNotEmpty && password.trim().isNotEmpty) {
        user = await AuthFireBase.signInWithEmailAndPassword(
          email.trim(),
          password.trim(),
        );
        return RequestStatus.success;
      } else {
        return RequestStatus.empty;
      }
    } catch (e) {
      debugPrint('Signin with password error: $e');
      return RequestStatus.error;
    }
  }

  // create new account or sign in using google
  Future<RequestStatus> signInWithGoogle() async {
    try {
      user = await AuthFireBase.signInWithGoogle();

      return RequestStatus.success;
    } catch (e) {
      debugPrint('Signin with google error: $e');
      return RequestStatus.error;
    }
  }

  // create new account or sign in using facebook

  // access as anonymous
  Future<RequestStatus> signInAnonymously() async {
    try {
      user = await AuthFireBase.signInAnonymously();
      return RequestStatus.success;
    } catch (e) {
      debugPrint('Signin Anonymously error: $e');
      return RequestStatus.error;
    }
  }

  // logout
  Future<void> logout() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null && user.isAnonymous) {
        await Firestore.deleteUser(user.uid);
        await FirebaseAuth.instance.currentUser?.delete();
      }
      await AuthFireBase.logout();
      this.user = null;
    } catch (e) {
      debugPrint('Logout error: $e');
    }
  }
}
