import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleAuthVM extends ChangeNotifier {
  final _googleSignIn = GoogleSignIn();

  GoogleSignInAccount? _user;
  UserCredential? _userCredential;

  GoogleSignInAccount? get user => _user;
  UserCredential? get userCredential => _userCredential;

  Future _googleLogin() async {
    try {
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return;

      _user = googleUser;

      final googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);

      await FirebaseAuth.instance.signInWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      print(e);
    } catch (e) {
      print(e);
    }
  }

  Future loginWithGoogleAccount(
      Function(GoogleSignInAccount? googleAccount, String? error)
          callback) async {
    await _googleLogin();
    if (_user != null) {
      callback(_user, null);
    } else {
      callback(null, "logIn Fail");
    }
  }

  Future<void> register(
      {required String emailAddress,
      required String password,
      required Function(UserCredential? userCredntial, String? error)
          callback}) async {
    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailAddress,
        password: password,
      );
      callback(credential, null);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
        callback(null, e.code);
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
        callback(null, e.code);
      } else {
        callback(null, e.code);
      }
    } catch (e) {
      callback(null, e.toString());
    }
  }

  Future loginWithEmail(
      {required String emailAddress,
      required String password,
      required Function(UserCredential? userCredential, String? error)
          callback}) async {
    if (_user == null) {
      try {
        final credential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(
                email: emailAddress, password: password);
        _userCredential = credential;
        notifyListeners();
        callback(credential, null);
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          print('No user found for that email.');
          callback(null, e.code);
        } else if (e.code == 'wrong-password') {
          log('Wrong password provided for that user.');
          callback(null, e.code);
        } else {
          print(e);
          callback(null, e.code);
        }
      }
    } else {
      log("Already logIn please logout first");
      _user = null;
      _userCredential = null;
      notifyListeners();
      callback(null, "Already logIn please logout first");
    }
  }
}
