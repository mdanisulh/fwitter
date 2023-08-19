import 'package:flutter/material.dart';
import 'package:fwitter/theme/pallete.dart';

class AppTheme {
  static ThemeData theme = ThemeData.dark().copyWith(
    appBarTheme: const AppBarTheme(
      backgroundColor: Pallete.backgroundColor,
      elevation: 0,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Pallete.blue,
    ),
    scaffoldBackgroundColor: Pallete.backgroundColor,
    useMaterial3: true,
  );
}
