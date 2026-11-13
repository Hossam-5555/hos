import 'package:flutter/material.dart';

/// Central palette: edit colors here to update the profile screen.
class AppColors {
  AppColors._();
    static const primary = Color(0xFF3F6FFF);
    static const Color iconscolor=Color(0xFFE0E3E8);
  static const purple = Color(0xFF9B59B6);
  static const success = Color(0xFF2ECC71);
  static const warning = Color(0xFFFFA500);
  static const danger = Color(0xFFFF5252);
  static const orange = Color(0xFFFF9F43);
 static Color grey = const Color.fromARGB(255, 113, 113, 113);
  static Color primaryColor = Colors.lightBlue;
  static Color black = Colors.black;
  static Color white = Colors.white;
  static Color deepPurple = Colors.deepPurple;
  static Color glass = const Color.fromARGB(218, 140, 196, 218);
  static Color blackblue = const Color.fromARGB(166, 3, 14, 27);
  static const favoriteStart = Color(0xFFF30909);
  static const favoriteEnd = Color(0xFFE53935);
  static const languageStart = Color(0xFFFFB74D);
  static const languageEnd = Color(0xFFF57C00);
  static const aboutStart = Color(0xFF4DB6AC);
  static const aboutEnd = Color(0xFF00796B);
  static const contactStart = Color(0xFF4DD0E1);
  static const contactEnd = Color(0xFF0097A7);
  static const logoutStart = Color(0xFFE57373);
  static const logoutEnd = Color(0xFFC62828);
  static const logout = Color(0xFFE53935);
  static const primaryStart = Color(0xFF64B5F6);
  static const primaryEnd = Color(0xFF1976D2);
  static const themeStart = Color(0xFFBA68C8);
  static const themeEnd = Color(0xFF7B1FA2);
  static const arabic = Color(0xFF2E7D32);
  static const english = Color(0xFF1976D2);
  static const editBackground = Color(0xFFE0E3E8);
  static const themeLightIcon = Color(0xFFFF9800);
  static const darkBorder = Color(0x1AFFFFFF);
  static const lightBorder = Color(0x17000000);
  static const darkShadow = Color(0x59000000);
  static const lightShadow = Color(0x1F000000);
  static const darkImageSurface = Color(0x0AFFFFFF);
  static const lightImageSurface = Color(0x06000000);
  static const darkCardSurface = Color(0x2E000000);
  static const lightCardSurface = Color(0x73FFFFFF);
  static const mutedText = Color(0xFF888888);
  static const border = Color(0x33757575);
  static const shadow = Color(0x14000000);

  static const darkSurface = Color(0xFF111314);
  static const lightSurface = Color(0xFFFFFFFF);
}

class AppGradients {
  AppGradients._();

  static const darkTitanium = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF4A4B4D), Color(0xFF232526), AppColors.darkSurface],
  );

  static const lightPlatinum = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [AppColors.lightSurface, Color(0xFFF1F3F5), Color(0xFFDDE1E6)],
  );
}
