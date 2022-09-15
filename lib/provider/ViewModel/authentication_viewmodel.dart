import 'dart:developer';

import 'package:amity_uikit_beta_service/amity_sle_uikit.dart';
import 'package:amity_uikit_beta_service/components/alert_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../../auth/login_navigator.dart';
import 'firebase_auth_viewmodel.dart';

class AuthenTicationVM extends ChangeNotifier {
  bool isLoading = false;
  Future<void> loginWithEmailAndPassWord() async {}
  Future<void> loginWithGoogleAuth() async {
    if (!isLoading) {
      isLoading = true;
      notifyListeners();
      Provider.of<GoogleSignInProvider>(navigatorKey.currentContext!,
              listen: false)
          .login((isSuccess, error) async {
        if (isSuccess) {
          log("tap signIn");

          await enterTheAppWith(
              userId: Provider.of<GoogleSignInProvider>(
                      navigatorKey.currentContext!,
                      listen: false)
                  .user!
                  .email);
        } else {
          isLoading = false;
          notifyListeners();
        }
      });
    }
  }

  Future<void> enterTheAppWith({required String userId}) async {
    var context = navigatorKey.currentContext!;

    if (userId != "") {
      print("Navigating...");
      await AmitySLEUIKit().registerDevice(
        context: context,
        userId: userId,
        callback: (isSuccess, error) {
          if (isSuccess) {
            print("login Success..");
            isLoading = false;
            notifyListeners();
            print("Navigate To app");
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
