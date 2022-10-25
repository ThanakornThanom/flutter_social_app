import 'dart:convert';
import 'dart:developer';

import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

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

  String sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  Future _appleLogin() async {
    try {
      // final credential =
      //     await SignInWithApple.getAppleIDCredential(
      //   scopes: [
      //     AppleIDAuthorizationScopes.email,
      //     AppleIDAuthorizationScopes.fullName,
      //   ],
      // );

      // print(credential);
      final rawNonce = generateNonce();
      final nonce = sha256ofString(rawNonce);

      // Request credential for the currently signed in Apple account.
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        nonce: nonce,
      );

      // Create an `OAuthCredential` from the credential returned by Apple.
      final oauthCredential = OAuthProvider("apple.com").credential(
        idToken: appleCredential.identityToken,
        rawNonce: rawNonce,
      );

      // Sign in the user with Firebase. If the nonce we generated earlier does
      // not match the nonce in `appleCredential.identityToken`, sign in will fail.
      return await FirebaseAuth.instance.signInWithCredential(oauthCredential);
    } on FirebaseAuthException catch (e) {
      print(e);
    } catch (e) {
      print(e);
    }
  }

  Future loginWithAppleAccount(
      Function(GoogleSignInAccount? googleAccount, String? error)
          callback) async {
    await _appleLogin();
    if (_user != null) {
      callback(_user, null);
    } else {
      callback(null, "logIn Fail");
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
