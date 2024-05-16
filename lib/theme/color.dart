import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData themeData = ThemeData(
  scaffoldBackgroundColor:const Color(0xfff3efff),
  primaryColor: const Color(0xff635FEA),
  canvasColor: const Color(0xff635FEA),
  secondaryHeaderColor: const Color(0xffEE6E6E),
  disabledColor: const Color(0xffa2a7ad),
  brightness: Brightness.dark,
  hintColor: const Color(0xFFbebebe),
  cardColor: const Color(0xffffffff),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: const Color(0xffFF0000),
    ),
  ),
  textTheme: GoogleFonts.montserratTextTheme().copyWith(
    displayLarge: const TextStyle(letterSpacing: 0.3),
    displayMedium: const TextStyle(letterSpacing: 0.3),
    displaySmall: const TextStyle(letterSpacing: 0.3),
    headlineMedium: const TextStyle(letterSpacing: 0.3),
    headlineSmall: const TextStyle(letterSpacing: 0.3),
    titleLarge: const TextStyle(letterSpacing: 0.3),
    titleMedium: const TextStyle(letterSpacing: 0.3),
    titleSmall: const TextStyle(letterSpacing: 0.3),
    bodyLarge: const TextStyle(letterSpacing: 0.3),
    bodyMedium: const TextStyle(letterSpacing: 0.3),
    labelLarge: const TextStyle(letterSpacing: 0.3),
    bodySmall: const TextStyle(letterSpacing: 0.3),
    labelSmall: const TextStyle(letterSpacing: 0.3),
  ),
);
