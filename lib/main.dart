import 'package:amity_sdk/amity_sdk.dart';
import 'package:country_code_picker/country_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:provider/provider.dart';
import 'package:verbose_share_world/app_theme/app_theme.dart';
import 'package:verbose_share_world/auth/login_navigator.dart';
import 'package:verbose_share_world/generated/l10n.dart';
import 'package:verbose_share_world/locale/language_cubit.dart';
import 'package:verbose_share_world/provider/ViewModel/amity_viewmodel.dart';
import 'package:verbose_share_world/provider/ViewModel/feed_viewmodel.dart';
import 'package:verbose_share_world/provider/ViewModel/post_viewmodel.dart';
import 'package:verbose_share_world/routes/routes.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  await AmityCoreClient.setup(
      option: AmityCoreClientOption(
        apiKey: 'b3babb0b3a89f4341d31dc1a01091edcd70f8de7b23d697f',
        httpEndpoint: AmityRegionalHttpEndpoint.SG,
      ),
      sycInitialization: true);

  runApp(Phoenix(child: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AmityVM>(create: ((context) => AmityVM())),
        ChangeNotifierProvider<FeedVM>(create: ((context) => FeedVM())),
        ChangeNotifierProvider<PostVM>(create: ((context) => PostVM())),
      ],
      child: BlocProvider<LanguageCubit>(
        create: (context) => LanguageCubit()..getCurrentLanguage(),
        child: BlocBuilder<LanguageCubit, Locale>(
          builder: (context, locale) {
            return MaterialApp(
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
