import 'dart:developer';

import 'package:amity_uikit_beta_service/amity_sle_uikit.dart';
import 'package:amity_uikit_beta_service/components/alert_dialog.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:verbose_share_world/auth/login_navigator.dart';
import 'package:verbose_share_world/components/custom_button.dart';
import 'package:verbose_share_world/components/entry_field.dart';
import 'package:verbose_share_world/generated/l10n.dart';

import 'package:verbose_share_world/provider/ViewModel/firebase_auth_viewmodel.dart';

class LoginUi extends StatefulWidget {
  @override
  _LoginUiState createState() => _LoginUiState();
}

class _LoginUiState extends State<LoginUi> {
  bool isLoggingIn = false;
  TextEditingController _userIDController =
      TextEditingController(text: "johnwick2");
  // TextEditingController _countryController = TextEditingController();
  String? isoCode;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    var mediaQuery = MediaQuery.of(context);
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: mediaQuery.size.height,
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Spacer(),
              //Image.asset('assets/images/ShareWorldLogo.png', height: 30),
              Spacer(),
              Image.asset('assets/Icons/amity-logo-banner.png', height: 100),
              SizedBox(height: 20),
              EntryField(
                controller: _userIDController,
                hint: 'enter userID',
              ),
              SizedBox(height: 40),
              CustomButton(
                  label: S.of(context).signIn,
                  isLoading: isLoggingIn,
                  onTap: () async {
                    if (!isLoggingIn) {
                      setState(() {
                        isLoggingIn = true;
                      });

                      await AmitySLEUIKit().registerDevice(
                        context: context,
                        userId: _userIDController.text,
                        callback: (isSuccess, error) {
                          if (isSuccess) {
                            print("login Success..");
                            Navigator.pushNamed(context, LoginRoutes.app);
                            setState(() {
                              isLoggingIn = false;
                            });
                          } else {
                            print("error..");
                            setState(() {
                              isSuccess = false;
                            });
                            AmityDialog().showAlertErrorDialog(
                                title: "error!", message: error!);
                          }
                        },
                      );
                    }
                  }),
              Spacer(),
              Text(S.of(context).or_Continue_With,
                  style: theme.textTheme.headline6!.copyWith(fontSize: 14)),
              SizedBox(height: 32),
              // CustomButton(
              //   icon: Image.asset('assets/Icons/ic_fb.png', scale: 2),
              //   radius: 12,
              //   color: Color(0xff3b45c1),
              //   onTap: () {
              //     Navigator.pushNamed(context, LoginRoutes.registration);
              //   },
              //   label: 'Facebook',
              //   textColor: Colors.white,
              // ),
              // SizedBox(height: 20),

              CustomButton(
                label: 'Google',
                radius: 12,
                borderColor: Colors.black,
                onTap: () {
                  if (!isLoggingIn) {
                    setState(() {
                      isLoggingIn = true;
                    });
                    Provider.of<GoogleSignInProvider>(context, listen: false)
                        .login((isSuccess, error) async {
                      if (isSuccess) {
                        log("tap signIn");

                        await AmitySLEUIKit().registerDevice(
                          context: context,
                          userId: Provider.of<GoogleSignInProvider>(context,
                                  listen: false)
                              .user!
                              .email,
                          callback: (isSuccess, error) {
                            if (isSuccess) {
                              print("login Success..");
                              Navigator.pushNamed(context, LoginRoutes.app);
                              setState(() {
                                isLoggingIn = false;
                              });
                            } else {
                              print("error..");
                              setState(() {
                                isSuccess = false;
                              });
                              AmityDialog().showAlertErrorDialog(
                                  title: "error!", message: error!);
                            }
                          },
                        );
                      } else {
                        setState(() {
                          isLoggingIn = false;
                        });
                      }
                    });
                  }
                },
                icon: Image.asset('assets/Icons/ic_login_google.png', scale: 3),
                color: Theme.of(context).scaffoldBackgroundColor,
                textColor: Colors.black,
              ),
              Spacer(),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
