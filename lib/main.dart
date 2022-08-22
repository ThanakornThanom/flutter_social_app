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
import 'package:verbose_share_world/provider/ViewModel/category_viewmodel.dart';
import 'package:verbose_share_world/provider/ViewModel/chat_viewmodel/channel_list_viewmodel.dart';
import 'package:verbose_share_world/provider/ViewModel/community_Feed_viewmodel.dart';
import 'package:verbose_share_world/provider/ViewModel/community_viewmodel.dart';
import 'package:verbose_share_world/provider/ViewModel/create_post_viewmodel.dart';
import 'package:verbose_share_world/provider/ViewModel/feed_viewmodel.dart';
import 'package:verbose_share_world/provider/ViewModel/post_viewmodel.dart';
import 'package:verbose_share_world/provider/ViewModel/user_feed_viewmodel.dart';
import 'package:verbose_share_world/provider/ViewModel/user_viewmodel.dart';
import 'package:verbose_share_world/routes/routes.dart';
import 'package:verbose_share_world/provider/ViewModel/custom_image_picker.dart';
import 'package:verbose_share_world/utils/navigation_key.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  await AmityCoreClient.setup(
      option: AmityCoreClientOption(
          apiKey:
              // 'b0eeee5c33dea2364f628d1e540a1688845884e4bd32692c',
              'b3babb0b3a89f4341d31dc1a01091edcd70f8de7b23d697f',
          httpEndpoint: AmityRegionalHttpEndpoint.SG
          // AmityRegionalHttpEndpoint.US,
          ),
      sycInitialization: true);

  runApp(Phoenix(child: MyApp()));
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
