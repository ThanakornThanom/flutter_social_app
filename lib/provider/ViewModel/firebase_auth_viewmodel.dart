import 'dart:convert';
import 'dart:developer';

import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class FirebaseAuthVM extends ChangeNotifier {
  final _googleSignIn = GoogleSignIn();

  UserCredential? _userCredential;

  UserCredential? get userCredential => _userCredential;

  void deleteCredential() {
    _userCredential = null;
  }

  Future _googleLogin() async {
    try {
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return;

      final googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);
      _userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      log(e.toString());
    } catch (e) {
      log(e.toString());
    }
  }

  String sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  Future _appleLogin() async {
    try {
      log("APPLE:_appleLogin");
      final rawNonce = generateNonce();
      final nonce = sha256ofString(rawNonce);

      // Request credential for the currently signed in Apple account.
      final _appleUser = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        nonce: nonce,
      );
      log("APPLE:_appleUser: $_appleUser");
      // Create an `OAuthCredential` from the credential returned by Apple.
      final oauthCredential = OAuthProvider("apple.com").credential(
        idToken: _appleUser.identityToken,
        rawNonce: rawNonce,
      );
      log("APPLE:oauthCredential: $oauthCredential");
      // Sign in the user with Firebase. If the nonce we generated earlier does
      // not match the nonce in `appleCredential.identityToken`, sign in will fail.
      _userCredential =
          await FirebaseAuth.instance.signInWithCredential(oauthCredential);
    } on FirebaseAuthException catch (e) {
      log("APPLE:FirebaseAuthException:$e");
    } catch (e) {
      log("APPLE:catch:$e");
    }
  }

  Future loginWithAppleAccount(
      Function(UserCredential? userCredential, String? error) callback) async {
    await _appleLogin();
    if (userCredential != null) {
      callback(userCredential, null);
    } else {
      callback(null, "logIn Fail");
    }
  }

  Future loginWithGoogleAccount(
      Function(UserCredential? userCredential, String? error) callback) async {
    await _googleLogin();
    if (userCredential != null) {
      callback(userCredential, null);
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
        log('The password provided is too weak.');
        callback(null, e.code);
      } else if (e.code == 'email-already-in-use') {
        log('The account already exists for that email.');
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
    if (_userCredential == null) {
      try {
        final credential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(
                email: emailAddress, password: password);
        _userCredential = credential;
        notifyListeners();
        callback(credential, null);
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          log('No user found for that email.');
          callback(null, e.code);
        } else if (e.code == 'wrong-password') {
          log('Wrong password provided for that user.');
          callback(null, e.code);
        } else {
          log(e.toString());
          callback(null, e.code);
        }
      }
    } else {
      log("Already logIn please logout first");

      _userCredential = null;
      notifyListeners();
      callback(null, "Already logIn please logout first");
    }
  }
}
