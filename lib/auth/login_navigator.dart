import 'package:flutter/material.dart';
import 'package:verbose_share_world/auth/login/login_ui.dart';
import 'package:verbose_share_world/auth/registration/registration_ui.dart';
import 'package:verbose_share_world/auth/verification/verification.dart';
import 'package:verbose_share_world/routes/routes.dart';

import '../app_navigation/app_navigation.dart';

GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class LoginRoutes {
  static const String loginRoot = 'login/';
  static const String registration = 'login/registration';
  static const String verification = 'login/verification';
  static const String app = 'app';
}

class LoginNavigator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        var canPop = navigatorKey.currentState!.canPop();
        if (canPop) {
          navigatorKey.currentState!.pop();
        }
        return !canPop;
      },
      child: Navigator(
        key: navigatorKey,
        initialRoute: LoginRoutes.loginRoot,
        onGenerateRoute: (RouteSettings settings) {
          late WidgetBuilder builder;
          switch (settings.name) {
            case LoginRoutes.loginRoot:
              builder = (BuildContext _) => LoginUi();
              break;
            case LoginRoutes.registration:
              builder = (BuildContext _) => RegistrationUi('');
              break;
            case LoginRoutes.verification:
              builder = (BuildContext _) => VerificationUi(() =>
                  Navigator.popAndPushNamed(context, PageRoutes.appNavigation));
              break;
            case LoginRoutes.app:
              builder = ((context) => AppNavigation());
              break;
          }
          return MaterialPageRoute(builder: builder, settings: settings);
        },
        onPopPage: (Route<dynamic> route, dynamic result) {
          return route.didPop(result);
        },
      ),
    );
  }
}
