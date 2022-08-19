import 'package:flutter/material.dart';
import 'package:verbose_share_world/app_theme/application_colors.dart';

class AppTheme {
  static final ThemeData lightTheme = ThemeData(
    scaffoldBackgroundColor: Colors.white,
    primaryColor: ApplicationColors.primaryColor,
    fontFamily: 'Poppins',
    appBarTheme: AppBarTheme(
      color: Colors.white,
      elevation: 0,
    ),
    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
        foregroundColor: MaterialStateProperty.all(Colors.black),
      ),
    ),
    textTheme: TextTheme(
      headline6: TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.bold,
      ),
      button: TextStyle(
        color: Colors.white,
        fontSize: 16,
      ),
    ),
    iconTheme: IconThemeData(color: Colors.white),
    primaryIconTheme: IconThemeData(color: Colors.black, size: 30),
  );
}
