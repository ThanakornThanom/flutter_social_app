import 'package:flutter/material.dart';

class AppTheme {
  static final ThemeData lightTheme = ThemeData(
    scaffoldBackgroundColor: Colors.white,
    primaryColor: Color(0xffe80202),
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
