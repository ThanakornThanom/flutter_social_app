import 'package:amity_sdk/amity_sdk.dart';
import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:provider/provider.dart';
import 'package:verbose_share_world/app_config/app_config.dart';
import 'package:verbose_share_world/components/custom_user_avatar.dart';
import 'package:verbose_share_world/locale/language_cubit.dart';
import 'package:verbose_share_world/profile/my_profile_screen.dart';
import 'package:verbose_share_world/profile/edit_profile.dart';
import 'package:verbose_share_world/generated/l10n.dart';
import 'package:verbose_share_world/app_theme/application_colors.dart';
import 'package:verbose_share_world/profile/user_profile.dart';
import 'package:verbose_share_world/provider/ViewModel/amity_viewmodel.dart';

class MyDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final theme = Theme.of(context);
    return Container(
      width: 225,
      color: ApplicationColors.scaffoldBackgroundColor,
      height: mediaQuery.size.height,
      child: Drawer(
        child: FadedSlideAnimation(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: EdgeInsets.only(top: 40, left: 20, right: 10),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        alignment: Alignment.centerRight,
                        width: double.infinity,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: Icon(Icons.close, color: theme.primaryColor),
                        ),
                      ),
                      SizedBox(height: 20),
                      FadedScaleAnimation(
                          child: getAvatarImage(
                              Provider.of<AmityVM>(
                                context,
                              ).currentamityUser?.avatarUrl,
                              radius: 50)),
                      SizedBox(height: 20),
                      Container(
                        child: Text(
                          S.of(context).hey,
                          style: theme.textTheme.subtitle2!.copyWith(
                            color: theme.hintColor,
                          ),
                        ),
                      ),
                      Container(
                        child: Text(
                          AmityCoreClient.getCurrentUser().displayName ?? "",
                          style: theme.textTheme.subtitle2!.copyWith(
                            color: theme.hintColor,
                          ),
                        ),
                      ),
                      SizedBox(height: 50),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => UserProfileScreen(
                                  amityUser:
                                      AmityCoreClient.getCurrentUser())));
                        },
                        child: Container(
                          width: double.infinity,
                          child: Text(
                            S.of(context).viewProfile,
                            style: theme.textTheme.headline6!.copyWith(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                        ),
                      ),
                      SizedBox(height: 30),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => ProfileScreen()));
                        },
                        child: Container(
                          width: double.infinity,
                          child: Text(
                            S.of(context).editProfile,
                            style: theme.textTheme.headline6!.copyWith(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                        ),
                      ),
                      SizedBox(height: 30),
                      GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (_) {
                              return FadedSlideAnimation(
                                child: AlertDialog(
                                  title: Text(
                                    S.of(context).selectLanguage,
                                    style: theme.textTheme.headline6!.copyWith(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  ),
                                  content: Container(
                                    width: 300,
                                    child: ListView.builder(
                                        physics: BouncingScrollPhysics(),
                                        itemCount:
                                            AppConfig.languagesSupported.length,
                                        shrinkWrap: true,
                                        itemBuilder: (context, index) =>
                                            TextButton(
                                              onPressed: () {
                                                BlocProvider.of<LanguageCubit>(
                                                        context)
                                                    .selectLanguage(AppConfig
                                                        .languagesSupported.keys
                                                        .elementAt(index));
                                                Navigator.of(context).pop();
                                              },
                                              child: Text(
                                                  AppConfig.languagesSupported[
                                                      AppConfig
                                                          .languagesSupported
                                                          .keys
                                                          .elementAt(index)]!),
                                            )),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text('Cancel'),
                                    ),
                                  ],
                                ),
                                beginOffset: Offset(0, 0.3),
                                endOffset: Offset(0, 0),
                                slideCurve: Curves.linearToEaseOut,
                              );
                            },
                          );
                        },
                        // child: Container(
                        //   width: double.infinity,
                        //   child: Text(
                        //     S.of(context).changeLanguage,
                        //     style: theme.textTheme.headline6!.copyWith(
                        //         fontWeight: FontWeight.bold, fontSize: 16),
                        //   ),
                        // ),
                      ),
                      SizedBox(height: 30),
                      GestureDetector(
                        onTap: () {
                          AmityCoreClient.logout();
                          Phoenix.rebirth(context);
                        },
                        child: Container(
                          width: double.infinity,
                          child: Text(
                            S.of(context).logout,
                            style: theme.textTheme.headline6!.copyWith(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          beginOffset: Offset(0, 0.3),
          endOffset: Offset(0, 0),
          slideCurve: Curves.linearToEaseOut,
        ),
      ),
    );
  }
}
