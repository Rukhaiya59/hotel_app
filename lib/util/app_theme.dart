
import 'package:flutter/material.dart';
import 'package:hotel/util/app_color.dart';

class AppTheme {
  static ThemeData light = ThemeData(
    scaffoldBackgroundColor: LightColor.background,
    primaryColor: LightColor.skyBlue,
    cardColor: LightColor.background,

    textTheme: const TextTheme(
      titleLarge: TextStyle(color: LightColor.black),
    ),

    iconTheme: const IconThemeData(color: LightColor.iconColor),
    dividerColor: LightColor.grey.withValues(alpha: 0.5),

    colorScheme: const ColorScheme.light(
      primary: LightColor.skyBlue,
      secondary: LightColor.lightBlue,
      error: LightColor.red,
      surface: LightColor.background,

      /// ⭐ OLD VALUES KO CHUA BHI NAHI
      primaryContainer: LightColor.primaryStart,
      onPrimaryContainer: LightColor.primaryEnd,
    ),

    /// ⭐ INPUT FIELD THEME (LIGHT)
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: LightColor.inputFill,
      border: InputBorder.none,
      enabledBorder: InputBorder.none,
      focusedBorder: InputBorder.none,
      errorBorder: InputBorder.none,
      focusedErrorBorder: InputBorder.none,
      contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
  ),
  );

  static ThemeData dark = ThemeData(
    scaffoldBackgroundColor: DarkColor.background,
    primaryColor: DarkColor.skyBlue,
    cardColor: DarkColor.background,

    textTheme: const TextTheme(
      titleLarge: TextStyle(color: DarkColor.black),
    ),

    iconTheme: const IconThemeData(color: DarkColor.iconColor),
    dividerColor: DarkColor.grey.withValues(alpha: 0.5),

    colorScheme: const ColorScheme.dark(
      primary: DarkColor.skyBlue,
      secondary: DarkColor.lightBlue,
      error: DarkColor.red,
      surface: DarkColor.background,

      /// ⭐ OLD VALUES KO BHI RAKHA HAI (NO CHANGE)
      primaryContainer: DarkColor.primaryStart,
      onPrimaryContainer: DarkColor.primaryEnd,
    ),

    /// ⭐ INPUT FIELD THEME (DARK)
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: DarkColor.inputFill,
      border: InputBorder.none,
      enabledBorder: InputBorder.none,
      focusedBorder: InputBorder.none,
      errorBorder: InputBorder.none,
      focusedErrorBorder: InputBorder.none,
      contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),

  ),
  );

  static LinearGradient gradient({required bool isDark}) => LinearGradient(
    colors: isDark
        ? DarkColor.gradientColors
        : LightColor.gradientColors,
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}
