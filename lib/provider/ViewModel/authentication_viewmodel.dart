import 'dart:developer';

import 'package:amity_uikit_beta_service/amity_sle_uikit.dart';
import 'package:amity_uikit_beta_service/components/alert_dialog.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:verbose_share_world/model/version_model.dart';
import 'package:verbose_share_world/repository/version_repo_Imp.dart';

import '../../app_navigation/need_update_screen.dart';
import '../../auth/login_navigator.dart';
import '../../utils/version_checker.dart';
import 'firebase_auth_viewmodel.dart';

class AuthenTicationVM extends ChangeNotifier {
  bool isLoading = false;
  bool isChecking = true;
  var versionVM = VersionRepoImp();

  Future checkIfLoggingIn() async {
    isChecking = true;
    notifyListeners();
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      log('User is currently signed out!');
      isChecking = false;
      notifyListeners();
    } else {
      log('User is signed in!');
      enterTheAppWith(userId: user.email!);
    }
  }

  Future<void> loginWithEmailAndPassWord({
    required String emailAddress,
    required String password,
  }) async {
    if (!isLoading) {
      isLoading = true;
      notifyListeners();
      Provider.of<FirebaseAuthVM>(navigatorKey.currentContext!, listen: false)
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
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      provisional: false,
      sound: true,
    );
    log("check notification setting ${settings.authorizationStatus}");
    if (settings.authorizationStatus == AuthorizationStatus.authorized ||
        settings.authorizationStatus == AuthorizationStatus.provisional) {
      String? fcmToken =
          await messaging.getToken().onError((error, stackTrace) {
        log("❌${error.toString()}");
      });
      if (fcmToken != null) {
        print("FCM_TOKEN: $fcmToken");
        log("check fcmToken ${fcmToken}");
        if (fcmToken != "") {
          if (settings.authorizationStatus == AuthorizationStatus.authorized) {
            log('User granted permission');

            await AmitySLEUIKit().registerNotification(fcmToken,
                (isSuccess, error) {
              if (error == null) {
                log("register ASC Noti success ${isSuccess}");
              } else {
                log("register ASC Noti fail ${isSuccess}");
              }
            });
          } else {
            log('User declined or has not accepted permission');
          }
        }
      } else {
        log('Unable to get FCM token');
      }
    }
  }

  Future<void> loginWithGoogleAuth() async {
    if (!isLoading) {
      isLoading = true;
      notifyListeners();
      Provider.of<FirebaseAuthVM>(navigatorKey.currentContext!, listen: false)
          .loginWithGoogleAccount((userCredential, error) async {
        if (userCredential != null) {
          log("tap signIn");

          await enterTheAppWith(
              userId: userCredential.user!.email!,
              displayName: userCredential.user!.displayName);
        } else {
          isLoading = false;
          notifyListeners();
        }
      });
    }
  }

  Future<void> loginWithAppleAuth() async {
    log("loginWithAppleAuth...");
    if (!isLoading) {
      isLoading = true;
      notifyListeners();
      Provider.of<FirebaseAuthVM>(navigatorKey.currentContext!, listen: false)
          .loginWithAppleAccount((userCredential, error) async {
        if (userCredential != null) {
          log("tap signIn");
          log("GIVEN NAME:${userCredential.user!.displayName}");

          await enterTheAppWith(
              userId: userCredential.user!.email!,
              displayName: userCredential.user!.displayName);
        } else {
          isLoading = false;
          notifyListeners();
        }
      });
    }
  }

  Future<void> registerWithEmail(
      {required String emailAddress,
      required String password,
      String? displayName}) async {
    if (!isLoading) {
      isLoading = true;
      notifyListeners();
      Provider.of<FirebaseAuthVM>(navigatorKey.currentContext!, listen: false)
          .register(
        emailAddress: emailAddress,
        password: password,
        callback: (userCredntial, error) async {
          if (userCredntial != null) {
            await enterTheAppWith(
                userId: userCredntial.user!.email!, displayName: displayName);
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

  Future<VersionModel?> getVersionInfo() async {
    return await versionVM.getVersion();
  }

  Future<void> enterTheAppWith(
      {required String userId, String? displayName}) async {
    var context = navigatorKey.currentContext!;
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    VersionModel? versionInfo = await getVersionInfo();
    var appVersion = versionInfo;
    var currentVersion = packageInfo.version;

    print(appVersion);
    if (isVersionGreaterThan(appVersion?.version ?? "0.0.0", currentVersion)) {
      Navigator.pushAndRemoveUntil(
          navigatorKey.currentContext!,
          MaterialPageRoute<void>(
              builder: (BuildContext context) => NeedUpdateScreen(
                    url: versionInfo!.downloadUrl,
                  )),
          (route) => !Navigator.of(context).canPop());
    } else {
      if (userId != "") {
        log("Navigating...with Displayname: ${displayName}");
        await AmitySLEUIKit().registerDevice(
          context: context,
          userId: userId,
          displayName: displayName,
          callback: (isSuccess, error) async {
            if (isSuccess) {
              log("login Success..");
              isLoading = false;
              notifyListeners();
              log("Navigate To app");
              await AmitySLEUIKit()
                  .joinInitialCommunity(["63563d38d3070ea63b95c92e"]);
              try {
                await registerPushNotification();
              } catch (e) {
                print(e);
              }
              log("Navigate to the app ✅ ");
              Navigator.pushNamedAndRemoveUntil(navigatorKey.currentContext!,
                  LoginRoutes.app, (route) => !Navigator.of(context).canPop());
            } else {
              log("error..");

              isLoading = false;
              isChecking = false;

              notifyListeners();
              AmityDialog()
                  .showAlertErrorDialog(title: "error!", message: error!);
            }
          },
        );
      }
    }
  }
}
