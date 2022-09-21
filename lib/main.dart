import 'dart:async';
import 'dart:developer';

import 'package:amity_uikit_beta_service/amity_sle_uikit.dart';
import 'package:country_code_picker/country_localizations.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:provider/provider.dart';
import 'package:verbose_share_world/app_theme/app_theme.dart';
import 'package:verbose_share_world/auth/login_navigator.dart';
import 'package:verbose_share_world/generated/l10n.dart';
import 'package:verbose_share_world/locale/language_cubit.dart';
import 'package:verbose_share_world/provider/ViewModel/authentication_viewmodel.dart';

import 'package:verbose_share_world/provider/ViewModel/firebase_auth_viewmodel.dart';
import 'package:verbose_share_world/routes/routes.dart';
import 'package:verbose_share_world/utils/navigation_key.dart';

Future<void> main() async {
  await runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    await dotenv.load(fileName: "assets/.env");

    if (dotenv.env["REGION"] != null) {
      var region = dotenv.env["REGION"]!.toLowerCase().trim();

      if (dotenv.env["REGION"]!.isNotEmpty) {
        /// Step1 Initialize uikit
        AmitySLEUIKit().initUIKit(dotenv.env["API_KEY"]!, region);
      } else {
        throw "REGION is not specify Please check .env file";
      }
    } else {
      throw "REGION is not specify Please check .env file";
    }

    if (kDebugMode) {
      log("FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);");
      await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
    }
    runApp(Phoenix(child: MyApp()));
  }, ((error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack);
  }));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AmitySLEProvider(
      child: Builder(builder: (context) {
        AmitySLEUIKit().configAmityThemeColor(context, (config) {
          config.primaryColor = AppTheme.lightTheme.primaryColor;
        });
        return MultiProvider(
          providers: [
            ChangeNotifierProvider<GoogleAuthVM>(
              create: (context) => GoogleAuthVM(),
            ),
            ChangeNotifierProvider<AuthenTicationVM>(
              create: (context) => AuthenTicationVM(),
            )
          ],
          child: BlocProvider<LanguageCubit>(
            create: (context) => LanguageCubit()..getCurrentLanguage(),
            child: BlocBuilder<LanguageCubit, Locale>(
              builder: (context, locale) {
                return MaterialApp(
                  navigatorKey: NavigationService.navigatorKey,
                  localizationsDelegates: [
                    S.delegate,
                    CountryLocalizations.delegate,
                    GlobalMaterialLocalizations.delegate,
                    GlobalWidgetsLocalizations.delegate,
                  ],
                  locale: locale,
                  supportedLocales: S.delegate.supportedLocales,
                  debugShowCheckedModeBanner: false,
                  theme: AppTheme.lightTheme,
                  home: LoginNavigator(),
                  routes: PageRoutes().routes(),
                );
              },
            ),
          ),
        );
      }),
    );
  }
}
