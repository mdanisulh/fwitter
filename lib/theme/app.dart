import 'package:flutter/material.dart';
import 'package:fwitter/theme/pallete.dart';

class AppTheme {
  static ThemeData theme = ThemeData.dark().copyWith(
    appBarTheme: const AppBarTheme(
      backgroundColor: Pallete.black,
      elevation: 0,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Pallete.blue,
    ),
    scaffoldBackgroundColor: Pallete.black,
  );
}
