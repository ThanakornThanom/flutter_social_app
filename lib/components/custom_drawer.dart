import 'dart:convert';

import 'package:amity_sdk/amity_sdk.dart';
import 'package:amity_uikit_beta_service/amity_sle_uikit.dart';
import 'package:amity_uikit_beta_service/components/custom_user_avatar.dart';
import 'package:amity_uikit_beta_service/view/user/edit_profile.dart';
import 'package:amity_uikit_beta_service/view/user/user_profile.dart';
import 'package:amity_uikit_beta_service/viewmodel/amity_viewmodel.dart';
import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:verbose_share_world/generated/l10n.dart';
import 'package:verbose_share_world/app_theme/application_colors.dart';
import 'package:verbose_share_world/provider/ViewModel/authentication_viewmodel.dart';

import '../auth/login_navigator.dart';
import '../provider/ViewModel/firebase_auth_viewmodel.dart';
import '../view/bot_webview_view.dart';
import 'package:http/http.dart' as http;

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
                              Provider.of<AmityVM>(context)
                                  .currentamityUser
                                  ?.avatarUrl,
                              radius: 50)),
                      SizedBox(height: 20),
                      Container(
                        child: Text(
                          "Hey,",
                          style: theme.textTheme.subtitle2!.copyWith(
                            color: theme.hintColor,
                          ),
                        ),
                      ),
                      Container(
                        child: Text(
                          Provider.of<AmityVM>(context)
                                  .currentamityUser
                                  ?.displayName ??
                              "",
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
                              builder: (context) => ProfileScreen(
                                    user: AmityCoreClient.getCurrentUser(),
                                  )));
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
                        onTap: () async {
                          // var headers = {
                          //   'Authorization':
                          //       'Bearer eyJhbGciOiJSUzI1NiIsImtpZCI6IkdTLWNDSUFib1IyQUhfQXczY29Bb0VtR1ZkdzFfaWxjc09BWGx6OXBoSFkifQ.eyJ1c2VyIjp7InVzZXJJZCI6IjYxODJlYWFlZmEyZjdlMmM2YjcyOGI0OCIsInB1YmxpY1VzZXJJZCI6ImpvaG53aWNrMiIsImRldmljZUluZm8iOnsia2luZCI6ImlvcyIsIm1vZGVsIjoic3RyaW5nIiwic2RrVmVyc2lvbiI6InN0cmluZyJ9LCJuZXR3b3JrSWQiOiI1ZmNhMGI0YWE2YTZjMThkNzYxNTg4NmMiLCJkaXNwbGF5TmFtZSI6ImpvaG53aWNrMiIsInJlZnJlc2hUb2tlbiI6ImVkMzAzZTBkMWFkNDNlNTUzMThiN2MyMGIxNGYzNmQ2MWRmYmViYmQ1OTFjYzkzNzJlZTE1Y2E5NDIyZDcxZDM5ZGRmNjBiNjExZTIzNzc3In0sInN1YiI6IjYxODJlYWFlZmEyZjdlMmM2YjcyOGI0OCIsImlzcyI6Imh0dHBzOi8vYXBpLmFtaXR5LmNvIiwiaWF0IjoxNjc1ODQ2OTA5LCJleHAiOjE2Nzg0Mzg5MDl9.QQSSVTv6g9p1nMvdKDs0ptbZZ7eorAQIS88pR0REDKUMwK09i4NGs6no6lWI-EObYKTcf9etvOzbq7GrVCKp5B4cXj-uKYU8zrzGhkuQWOzKbJGbiJGQSscdl9T8z_XzeXn4NXs9DLGCfVoHrXG8SKKvFnnmnogXaoWoIe8pRPGCik8qZTSjGcjt_oyZalca5K6sOJlgyKyWyT4UKUbTlwdPJRv-tTgvxb404argSem9j0JQM-0Xl600askQNqpqfNB5epdii4aZQIFNgSmQy3BIhjRCtsuIdclznDKhGox0P2y5wH7Ji_YfGxekvaO1c4vli-SsvcX6fxhgU9syYA',
                          //   'Content-Type': 'application/json'
                          // };
                          // var request = http.Request(
                          //     'DELETE',
                          //     Uri.parse(
                          //         'https://beta.amity.services/block/members'));
                          // request.body =
                          //     jsonEncode({"blockUserId": "testBlock"});
                          // request.headers.addAll(headers);

                          // http.StreamedResponse response = await request.send();

                          // if (response.statusCode == 200) {
                          //   print("test http");
                          //   print(await response.stream.bytesToString());
                          // } else {
                          //   print(response.reasonPhrase);
                          // }
                          Navigator.of(context).pop();
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => BotWebView()));
                        },
                        child: Container(
                          width: double.infinity,
                          child: Text(
                            "Report Problem",
                            style: theme.textTheme.headline6!.copyWith(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                        ),
                      ),
                      SizedBox(height: 30),
                      // GestureDetector(
                      //   onTap: () {
                      //     showDialog(
                      //       context: context,
                      //       barrierDismissible: false,
                      //       builder: (_) {
                      //         return FadedSlideAnimation(
                      //           child: AlertDialog(
                      //             title: Text(
                      //               S.of(context).selectLanguage,
                      //               style: theme.textTheme.headline6!.copyWith(
                      //                   fontWeight: FontWeight.bold,
                      //                   fontSize: 16),
                      //             ),
                      //             content: Container(
                      //               width: 300,
                      //               child: ListView.builder(
                      //                   physics: BouncingScrollPhysics(),
                      //                   itemCount:
                      //                       AppConfig.languagesSupported.length,
                      //                   shrinkWrap: true,
                      //                   itemBuilder: (context, index) =>
                      //                       TextButton(
                      //                         onPressed: () {
                      //                           BlocProvider.of<LanguageCubit>(
                      //                                   context)
                      //                               .selectLanguage(AppConfig
                      //                                   .languagesSupported.keys
                      //                                   .elementAt(index));
                      //                           Navigator.of(context).pop();
                      //                         },
                      //                         child: Text(
                      //                             AppConfig.languagesSupported[
                      //                                 AppConfig
                      //                                     .languagesSupported
                      //                                     .keys
                      //                                     .elementAt(index)]!),
                      //                       )),
                      //             ),
                      //             actions: [
                      //               TextButton(
                      //                 onPressed: () {
                      //                   Navigator.of(context).pop();
                      //                 },
                      //                 child: Text('Cancel'),
                      //               ),
                      //             ],
                      //           ),
                      //           beginOffset: Offset(0, 0.3),
                      //           endOffset: Offset(0, 0),
                      //           slideCurve: Curves.linearToEaseOut,
                      //         );
                      //       },
                      //     );
                      //   },
                      //   child: Container(
                      //     width: double.infinity,
                      //     child: Text(
                      //       S.of(context).changeLanguage,
                      //       style: theme.textTheme.headline6!.copyWith(
                      //           fontWeight: FontWeight.bold, fontSize: 16),
                      //     ),
                      //   ),
                      // ),
                      // SizedBox(height: 30),
                      GestureDetector(
                        onTap: () async {
                          Provider.of<FirebaseAuthVM>(context, listen: false)
                              .deleteCredential();
                          AmitySLEUIKit().unRegisterDevice();
                          await FirebaseAuth.instance.signOut();

                          // Navigator.of(context).popUntil(
                          //     (route) => !Navigator.of(context).canPop());

                          Navigator.pushNamedAndRemoveUntil(
                              navigatorKey.currentContext!,
                              LoginRoutes.loginRoot,
                              (route) => !Navigator.of(context).canPop());
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
