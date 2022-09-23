import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:verbose_share_world/auth/login_navigator.dart';
import 'package:verbose_share_world/components/custom_button.dart';
import 'package:verbose_share_world/components/entry_field.dart';
import 'package:verbose_share_world/generated/l10n.dart';
import 'package:verbose_share_world/provider/ViewModel/authentication_viewmodel.dart';

class LoginUi extends StatefulWidget {
  @override
  _LoginUiState createState() => _LoginUiState();
}

class _LoginUiState extends State<LoginUi> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  // TextEditingController _countryController = TextEditingController();
  String? isoCode;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    var mediaQuery = MediaQuery.of(context);
    return Consumer<AuthenTicationVM>(builder: (context, vm, _) {
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
                GestureDetector(
                    onTap: () {
                      vm.enterTheAppWith(userId: "johnwick2");
                    },
                    child: Image.asset('assets/Icons/amity-logo-banner.png',
                        height: 100)),
                SizedBox(height: 20),
                EntryField(
                  controller: _emailController,
                  hint: 'UserID',
                ),
                SizedBox(
                  height: 20,
                ),
                EntryField(
                  controller: _passwordController,
                  obscureText: true,
                  hint: 'Password',
                ),
                SizedBox(height: 40),
                CustomButton(
                    label: S.of(context).signIn,
                    isLoading: vm.isLoading,
                    onTap: () async {
                      vm.loginWithEmailAndPassWord(
                          emailAddress: _emailController.text,
                          password: _passwordController.text);
                    }),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                        onTap: () {
                          if (!vm.isLoading) {
                            Navigator.pushNamed(
                                context, LoginRoutes.registration);
                          }
                        },
                        child: Text("Sign up")),
                  ],
                ),
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
                    vm.loginWithGoogleAuth();
                  },
                  icon:
                      Image.asset('assets/Icons/ic_login_google.png', scale: 3),
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
    });
  }
}
