import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:verbose_share_world/auth/login_navigator.dart';
import 'package:verbose_share_world/components/custom_button.dart';
import 'package:verbose_share_world/components/entry_field.dart';
import 'package:verbose_share_world/generated/l10n.dart';
import 'package:verbose_share_world/provider/ViewModel/firebase_auth_viewmodel.dart';

import '../../provider/ViewModel/authentication_viewmodel.dart';

class RegistrationUi extends StatefulWidget {
  final String phoneNumber;

  RegistrationUi(this.phoneNumber);

  @override
  _RegistrationUiState createState() => _RegistrationUiState();
}

class _RegistrationUiState extends State<RegistrationUi> {
  TextEditingController _displayNameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _repeatPasswordController = TextEditingController();

  @override
  void dispose() {
    _displayNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _repeatPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Consumer<AuthenTicationVM>(builder: (context, vm, _) {
      return Scaffold(
        appBar: AppBar(
          title: Text("Sign Up", style: theme.textTheme.headline6),
        ),
        body: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height -
                AppBar().preferredSize.height -
                MediaQuery.of(context).padding.vertical,
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  S.of(context).Register_now_to_continue,
                  style: theme.textTheme.headline6!
                      .copyWith(fontSize: 12, color: theme.hintColor),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 70),
                // EntryField(
                //   controller: _displayNameController,
                //   hint: "Display Name",
                // ),
                // SizedBox(height: 20),
                EntryField(
                  controller: _displayNameController,
                  hint: "Display Name",
                ),
                SizedBox(height: 20),
                EntryField(
                  controller: _emailController,
                  hint: S.of(context).Email_address,
                ),
                SizedBox(height: 20),
                EntryField(
                  obscureText: true,
                  controller: _passwordController,
                  hint: "Password",
                ),
                SizedBox(height: 20),
                EntryField(
                  obscureText: true,
                  controller: _repeatPasswordController,
                  hint: "Repeat Password",
                ),
                Spacer(flex: 2),
                CustomButton(
                  label: S.of(context).Register_Now,
                  onTap: () {
                    vm.registerWithEmail(
                        emailAddress: _emailController.text,
                        password: _passwordController.text,
                        displayName: _displayNameController.text);
                  },
                ),
                SizedBox(height: 28),
                Text(
                  S
                      .of(context)
                      .Well_Send_You_Verification_Code_On_Above_Given_Number_To,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.subtitle2!
                      .copyWith(fontSize: 12, color: theme.hintColor),
                ),
                Spacer(),
              ],
            ),
          ),
        ),
      );
    });
  }
}
