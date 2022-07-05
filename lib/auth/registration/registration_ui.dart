import 'package:flutter/material.dart';
import 'package:verbose_share_world/auth/login_navigator.dart';
import 'package:verbose_share_world/components/custom_button.dart';
import 'package:verbose_share_world/components/entry_field.dart';
import 'package:verbose_share_world/generated/l10n.dart';

class RegistrationUi extends StatefulWidget {
  final String phoneNumber;

  RegistrationUi(this.phoneNumber);

  @override
  _RegistrationUiState createState() => _RegistrationUiState();
}

class _RegistrationUiState extends State<RegistrationUi> {
  TextEditingController _fullNameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).New_User, style: theme.textTheme.headline6),
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
              Padding(
                padding: EdgeInsetsDirectional.only(start: 56),
                child: Text(
                  S.of(context).Register_now_to_continue,
                  style: theme.textTheme.headline6!
                      .copyWith(fontSize: 12, color: theme.hintColor),
                ),
              ),
              SizedBox(height: 70),
              EntryField(
                controller: _fullNameController,
                hint: S.of(context).Full_name,
              ),
              SizedBox(height: 20),
              EntryField(
                controller: _emailController,
                hint: S.of(context).Email_address,
              ),
              SizedBox(height: 20),
              EntryField(
                initialValue: widget.phoneNumber,
                hint: S.of(context).Phone_Number,
              ),
              Spacer(flex: 2),
              CustomButton(
                label: S.of(context).Register_Now,
                onTap: () => Navigator.pushNamed(context, LoginRoutes.app),
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
  }
}
