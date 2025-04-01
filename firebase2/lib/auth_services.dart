import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthServices with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _signInAccount = GoogleSignIn();
  User? _user;

  User? get user => _user;
  AuthServices() {
    _auth.authStateChanges().listen((User? user) {
      _user = user;
    });
  }

  Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _signInAccount.signIn();
      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final AuthCredential authCredential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      UserCredential userCredential = await _auth.signInWithCredential(
        authCredential,
      );
      return userCredential.user;
    } catch (e) {
      return null;
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
    await _signInAccount.signOut();
  }
}
