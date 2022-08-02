import 'dart:developer';

import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:verbose_share_world/auth/login_navigator.dart';
import 'package:verbose_share_world/components/custom_button.dart';
import 'package:verbose_share_world/components/entry_field.dart';
import 'package:verbose_share_world/generated/l10n.dart';
import 'package:verbose_share_world/provider/ViewModel/amity_viewmodel.dart';
import 'package:verbose_share_world/provider/ViewModel/feed_viewmodel.dart';

import '../../routes/routes.dart';

class LoginUi extends StatefulWidget {
  @override
  _LoginUiState createState() => _LoginUiState();
}

class _LoginUiState extends State<LoginUi> {
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
              SizedBox(height: 20),
              EntryField(
                controller: _userIDController,
                hint: 'enter userID',
              ),
              SizedBox(height: 40),
              CustomButton(
                  label: S.of(context).signIn,
                  onTap: () async {
                    log("tap signIn");
                    await Provider.of<AmityVM>(context, listen: false)
                        .login(_userIDController.text);

                    Navigator.pushNamed(context, LoginRoutes.app);
                  }),
              Spacer(),
              // Text(S.of(context).or_Continue_With,
              //     style: theme.textTheme.headline6!.copyWith(fontSize: 14)),
              // SizedBox(height: 32),
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
              // CustomButton(
              //   label: 'Google',
              //   radius: 12,
              //   borderColor: Colors.black,
              //   onTap: () {
              //     Navigator.pushNamed(context, LoginRoutes.registration);
              //   },
              //   icon: Image.asset('assets/Icons/ic_login_google.png', scale: 3),
              //   color: Theme.of(context).scaffoldBackgroundColor,
              //   textColor: Colors.black,
              // ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
