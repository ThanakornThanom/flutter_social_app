import 'dart:async';
import 'dart:developer';

import 'package:amity_sdk/amity_sdk.dart';
import 'package:country_code_picker/country_localizations.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
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
import 'package:verbose_share_world/provider/ViewModel/amity_viewmodel.dart';
import 'package:verbose_share_world/provider/ViewModel/category_viewmodel.dart';
import 'package:verbose_share_world/provider/ViewModel/chat_viewmodel/channel_list_viewmodel.dart';
import 'package:verbose_share_world/provider/ViewModel/community_Feed_viewmodel.dart';
import 'package:verbose_share_world/provider/ViewModel/community_viewmodel.dart';
import 'package:verbose_share_world/provider/ViewModel/create_post_viewmodel.dart';
import 'package:verbose_share_world/provider/ViewModel/feed_viewmodel.dart';
import 'package:verbose_share_world/provider/ViewModel/firebase_auth_viewmodel.dart';
import 'package:verbose_share_world/provider/ViewModel/post_viewmodel.dart';
import 'package:verbose_share_world/provider/ViewModel/user_feed_viewmodel.dart';
import 'package:verbose_share_world/provider/ViewModel/user_viewmodel.dart';
import 'package:verbose_share_world/routes/routes.dart';
import 'package:verbose_share_world/provider/ViewModel/custom_image_picker.dart';
import 'package:verbose_share_world/utils/navigation_key.dart';

Future<void> main() async {
  await runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    await dotenv.load(fileName: "assets/.env");
    AmityRegionalHttpEndpoint? amityEndpoint;
    if (dotenv.env["REGION"] != null) {
      var region = dotenv.env["REGION"]!.toLowerCase().trim();

      if (dotenv.env["REGION"]!.isNotEmpty) {
        switch (region) {
          case "":
            {
              log("REGION is not specify Please check .env file");
            }
            ;
            break;
          case "sg":
            {
              amityEndpoint = AmityRegionalHttpEndpoint.SG;
            }
            ;
            break;
          case "us":
            {
              amityEndpoint = AmityRegionalHttpEndpoint.US;
            }
            ;
            break;
          case "eu":
            {
              amityEndpoint = AmityRegionalHttpEndpoint.EU;
            }
            ;
        }
      } else {
        throw "REGION is not specify Please check .env file";
      }
    } else {
      throw "REGION is not specify Please check .env file";
    }

    await AmityCoreClient.setup(
        option: AmityCoreClientOption(
            apiKey: dotenv.env["API_KEY"]!, httpEndpoint: amityEndpoint!),
        sycInitialization: true);

    runApp(Phoenix(child: MyApp()));
  }, (error, stackTrace) {
    FirebaseCrashlytics.instance.recordError(error, stackTrace);
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<UserVM>(create: ((context) => UserVM())),
        ChangeNotifierProvider<AmityVM>(create: ((context) => AmityVM())),
        ChangeNotifierProvider<FeedVM>(create: ((context) => FeedVM())),
        ChangeNotifierProvider<CommunityVM>(
            create: ((context) => CommunityVM())),
        ChangeNotifierProvider<PostVM>(create: ((context) => PostVM())),
        ChangeNotifierProvider<UserFeedVM>(create: ((context) => UserFeedVM())),
        ChangeNotifierProvider<ImagePickerVM>(
            create: ((context) => ImagePickerVM())),
        ChangeNotifierProvider<CreatePostVM>(
            create: ((context) => CreatePostVM())),
        ChangeNotifierProvider<ChannelVM>(create: ((context) => ChannelVM())),
        ChangeNotifierProvider<GoogleSignInProvider>(
          create: (context) => GoogleSignInProvider(),
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
  }
}
