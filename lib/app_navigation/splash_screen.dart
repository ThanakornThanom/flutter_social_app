import 'package:flutter/material.dart';
import 'package:verbose_share_world/app_theme/application_colors.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        color: ApplicationColors.white,
        alignment: Alignment.center,
        padding: EdgeInsets.all(20),
        child: Image.asset('assets/images/ShareWorldLogo.png'),
      ),
    );
  }
}
