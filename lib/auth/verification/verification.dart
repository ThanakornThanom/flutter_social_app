import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:verbose_share_world/app_theme/application_colors.dart';
import 'package:verbose_share_world/components/custom_button.dart';
import 'package:verbose_share_world/generated/l10n.dart';

class VerificationUi extends StatefulWidget {
  final Function onLoggedIn;

  VerificationUi(this.onLoggedIn);

  @override
  _VerificationUiState createState() => _VerificationUiState();
}

class _VerificationUiState extends State<VerificationUi> {
  TextEditingController _otpController = TextEditingController();

  @override
  void dispose() {
    // _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title:
            Text(S.of(context).verification, style: theme.textTheme.headline6),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: EdgeInsetsDirectional.only(start: 56),
                child: Text(
                  'Add verification code sent on your number.',
                  style: theme.textTheme.headline6!.copyWith(
                      color: ApplicationColors.textGrey, fontSize: 11),
                ),
              ),
              SizedBox(height: 70),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: PinCodeTextField(
                  controller: _otpController,
                  length: 4,
                  keyboardType: TextInputType.number,
                  obscureText: false,
                  animationType: AnimationType.fade,
                  textStyle: theme.textTheme.bodyText1!
                      .copyWith(fontSize: 23, fontWeight: FontWeight.w500),
                  pinTheme: PinTheme(
                      shape: PinCodeFieldShape.underline,
                      fieldWidth: 48,
                      inactiveColor: ApplicationColors.textGrey,
                      activeColor: theme.primaryColor,
                      selectedColor: theme.primaryColor,
                      inactiveFillColor: Colors.white,
                      selectedFillColor: Colors.white,
                      activeFillColor: Colors.white,
                      borderWidth: 1),
                  animationDuration: Duration(milliseconds: 300),
                  enableActiveFill: true,
                  onCompleted: (v) {
                    print("Completed");
                  },
                  onChanged: (value) {
                    print(value);
                    setState(() {});
                  },
                  beforeTextPaste: (text) {
                    print("Allowing to paste $text");
                    return true;
                  },
                  appContext: context,
                ),
              ),
              SizedBox(height: 60),
              CustomButton(
                label: S.of(context).verify_Now,
                onTap: widget.onLoggedIn,
              ),
              SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    child: Text(
                      S.of(context).xxx_Min_Left,
                      style: theme.textTheme.bodyText1,
                    ),
                  ),
                  GestureDetector(
                    child: Text(
                      S.of(context).resend,
                      style: theme.textTheme.button!
                          .copyWith(color: theme.primaryColor),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
