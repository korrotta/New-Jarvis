import 'package:flutter/material.dart';

ThemeData lightTheme = ThemeData(
  colorScheme: ColorScheme.light(
    primary: Colors.grey.shade500,
    secondary: Colors.grey.shade200,
    surface: Colors.white,
    tertiary: Colors.white,
    error: Colors.red,
    brightness: Brightness.light,
    inversePrimary: Colors.grey.shade900,
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.grey,
    foregroundColor: Colors.black,
  ),
);
