import 'dart:developer';

import 'package:amity_uikit_beta_service/amity_sle_uikit.dart';
import 'package:amity_uikit_beta_service/components/alert_dialog.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../../auth/login_navigator.dart';
import 'firebase_auth_viewmodel.dart';

class AuthenTicationVM extends ChangeNotifier {
  bool isLoading = false;
  Future<void> loginWithEmailAndPassWord({
    required String emailAddress,
    required String password,
  }) async {
    if (!isLoading) {
      isLoading = true;
      notifyListeners();
      Provider.of<GoogleAuthVM>(navigatorKey.currentContext!, listen: false)
          .loginWithEmail(
        emailAddress: emailAddress,
        password: password,
        callback: (userCredential, error) async {
          if (userCredential != null) {
            log("tap signIn");

            await enterTheAppWith(userId: userCredential.user!.email!);
          } else {
            AmityDialog().showAlertErrorDialog(
                title: "Error!", message: error.toString());
            isLoading = false;

            notifyListeners();
          }
        },
      );
    }
  }

  Future<void> registerPushNotification() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    String fcmToken = await messaging.getToken() ?? "";
    print("check fcmToken ${fcmToken}");
    if (fcmToken != "") {
      NotificationSettings settings = await messaging.requestPermission(
        alert: true,
        badge: true,
        provisional: false,
        sound: true,
      );

      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        print('User granted permission');
        await AmitySLEUIKit()
            .registerNotification(fcmToken, (isSuccess, error) => null);
      } else {
        print('User declined or has not accepted permission');
      }
    }
  }

  Future<void> loginWithGoogleAuth() async {
    if (!isLoading) {
      isLoading = true;
      notifyListeners();
      Provider.of<GoogleAuthVM>(navigatorKey.currentContext!, listen: false)
          .loginWithGoogleAccount((googleAccount, error) async {
        if (googleAccount != null) {
          log("tap signIn");

          await enterTheAppWith(userId: googleAccount.email);
        } else {
          isLoading = false;
          notifyListeners();
        }
      });
    }
  }

  Future<void> registerWithEmail({
    required String emailAddress,
    required String password,
  }) async {
    if (!isLoading) {
      isLoading = true;
      notifyListeners();
      Provider.of<GoogleAuthVM>(navigatorKey.currentContext!, listen: false)
          .register(
        emailAddress: emailAddress,
        password: password,
        callback: (userCredntial, error) async {
          if (userCredntial != null) {
            await enterTheAppWith(userId: userCredntial.user!.email!);
          } else {
            isLoading = false;
            notifyListeners();
            AmityDialog()
                .showAlertErrorDialog(title: "Error!", message: error!);
          }
        },
      );
    }
  }

  Future<void> enterTheAppWith({required String userId}) async {
    var context = navigatorKey.currentContext!;

    if (userId != "") {
      print("Navigating...");
      await AmitySLEUIKit().registerDevice(
        context: context,
        userId: userId,
        callback: (isSuccess, error) async {
          if (isSuccess) {
            print("login Success..");
            isLoading = false;
            notifyListeners();
            print("Navigate To app");

            await registerPushNotification();
            Navigator.pushNamed(navigatorKey.currentContext!, LoginRoutes.app);
          } else {
            print("error..");

            isLoading = false;
            notifyListeners();
            AmityDialog()
                .showAlertErrorDialog(title: "error!", message: error!);
          }
        },
      );
    }
  }
}
