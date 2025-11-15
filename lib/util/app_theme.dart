import 'package:flutter/material.dart';
import 'package:hotel/util/app_color.dart';
class AppTheme {
  static ThemeData light = ThemeData(
    scaffoldBackgroundColor: LightColor.background,
    primaryColor: LightColor.skyBlue,
    cardColor: LightColor.background,
    textTheme: const TextTheme(titleLarge: TextStyle(color: LightColor.black)),
    iconTheme: const IconThemeData(color: LightColor.iconColor),
    dividerColor: LightColor.grey.withValues(alpha: 0.5),
    colorScheme: const ColorScheme.light(
      primary: LightColor.skyBlue,
      secondary: LightColor.lightBlue,
      error: LightColor.red,
      surface: LightColor.background,
    ).copyWith(surface: LightColor.background),

  );

  static ThemeData dark = ThemeData(
    scaffoldBackgroundColor: DarkColor.background,
    primaryColor: DarkColor.skyBlue,
    cardColor: DarkColor.background,
    textTheme: const TextTheme(titleLarge: TextStyle(color: DarkColor.black)),
    iconTheme: const IconThemeData(color: DarkColor.iconColor),
    dividerColor: DarkColor.grey.withValues(alpha: 0.5),
    colorScheme: const ColorScheme.dark(
      primary: DarkColor.skyBlue,
      secondary: DarkColor.lightBlue,
      error: DarkColor.red,
      surface: DarkColor.background,
    ).copyWith(surface: DarkColor.background),
  );

  static LinearGradient gradient({required bool isDark}) => LinearGradient(
    colors:
    isDark ? DarkColor.gradientColors : LightColor.gradientColors,
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}
