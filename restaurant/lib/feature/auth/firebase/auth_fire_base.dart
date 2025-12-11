import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:restaurant/feature/home/firestore/firestore.dart';
import 'package:restaurant/feature/models/user.dart';

class AuthFireBase {
  static final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  // ================================
  // CREATE ACCOUNT WITH EMAIL & PASSWORD
  // ================================
  static Future<UserCredential> createAccountWithEmailAndPassword(
    String username,
    String email,
    String password,
  ) async {
    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await FirebaseAuth.instance.currentUser!.updateDisplayName(username);

      final user = UserModel(
        uid: userCredential.user!.uid,
        name: username,
        email: email,
        phoneNumber: userCredential.user!.phoneNumber,
        providerId: 'password',
      );

      await Firestore.addUserIfNotExists(
        user,
      ); // Add user to Firestore if not already
      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  // ================================
  // SIGN IN WITH EMAIL & PASSWORD
  // ================================
  static Future<UserCredential> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = UserModel(
        uid: userCredential.user!.uid,
        name: userCredential.user!.displayName,
        email: email,
        phoneNumber: userCredential.user!.phoneNumber,
        providerId: 'password',
      );

      await Firestore.addUserIfNotExists(
        user,
      ); // Ensure user exists in Firestore
      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  // ================================
  // SIGN IN WITH GOOGLE
  // ================================
  static Future<UserCredential> signInWithGoogle() async {
    try {
      await GoogleSignIn.instance.initialize();
      final GoogleSignInAccount googleUser = await GoogleSignIn.instance
          .authenticate();

      final GoogleSignInAuthentication googleAuth = googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithCredential(credential);

      final user = UserModel(
        name: userCredential.user!.displayName,
        email: userCredential.user!.email,
        phoneNumber: userCredential.user!.phoneNumber,
        providerId: userCredential.credential!.providerId,
        uid: userCredential.user!.uid,
      );

      await Firestore.addUserIfNotExists(
        user,
      ); // Ensure user exists in Firestore
      return userCredential;
    } on GoogleSignInException catch (e) {
      throw Exception(e.code);
    } catch (e) {
      rethrow;
    }
  }

  // ================================
  // SIGN IN ANONYMOUSLY
  // ================================
  static Future<UserCredential> signInAnonymously() async {
    final userCredential = await _firebaseAuth.signInAnonymously();

    final user = UserModel(
      uid: userCredential.user!.uid,
      name: "Guest",
      email: null,
      phoneNumber: null,
      providerId: 'anonymous',
    );

    await Firestore.addUserIfNotExists(user); // Add anonymous user to Firestore
    return userCredential;
  }

  // ================================
  // LOG OUT
  // ================================
  static Future<void> logout() async {
    await _firebaseAuth.signOut();
  }
}
