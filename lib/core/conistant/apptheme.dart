import 'package:flutter/material.dart';
import 'package:hos/core/conistant/appcolor.dart';

class AppTheme {
  // دالة مساعدة لإنشاء مقاسات النصوص الموحدة
  static TextTheme _getTextTheme(String fontFamily, bool isDark) {
    Color textColor = isDark ? Colors.white : Colors.black;
    Color bodyColor = isDark ? Colors.grey[400]! : Appcolor.grey;

    return TextTheme(
      headlineLarge: TextStyle(fontWeight: FontWeight.bold, fontSize: 32, fontFamily: fontFamily, color: textColor),
      headlineMedium: TextStyle(fontWeight: FontWeight.bold, fontSize: 28, fontFamily: fontFamily, color: textColor),
      headlineSmall: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, fontFamily: fontFamily, color: textColor),
      titleLarge: TextStyle(fontWeight: FontWeight.bold, fontSize: 22, fontFamily: fontFamily, color: textColor),
      bodyLarge: TextStyle(fontSize: 16, fontFamily: fontFamily, color: bodyColor, height: 1.5),
      bodyMedium: TextStyle(fontSize: 14, fontFamily: fontFamily, color: bodyColor.withAlpha(204), height: 1.4),
    );
  }

  static AppBarTheme _appBar(Color bg, Color content, String font) {
    return AppBarTheme(
      backgroundColor: bg,
      elevation: 0.0,
      centerTitle: true,
      iconTheme: IconThemeData(color: content, size: 24),
      titleTextStyle: TextStyle(color: content, fontSize: 22, fontFamily: font, fontWeight: FontWeight.bold),
    );
  }

  // الـ 4 قوالب الأساسية
  static ThemeData lightEn = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: _appBar(Colors.white, Colors.black, 'RobotoMono'),
    textTheme: _getTextTheme('RobotoMono', false),
    colorScheme: ColorScheme.fromSeed(seedColor: Appcolor.primaryColor),
  );

  static ThemeData darkEn = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: const Color(0xFF121212),
    appBarTheme: _appBar(const Color(0xFF121212), Colors.white, 'RobotoMono'),
    textTheme: _getTextTheme('RobotoMono', true),
    colorScheme: ColorScheme.fromSeed(seedColor: Appcolor.primaryColor, brightness: Brightness.dark),
  );

  static ThemeData lightAr = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: _appBar(Colors.white, Colors.black, 'cairo'),
    textTheme: _getTextTheme('cairo', false),
    colorScheme: ColorScheme.fromSeed(seedColor: Appcolor.primaryColor),
  );

  static ThemeData darkAr = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: const Color(0xFF121212),
    appBarTheme: _appBar(const Color(0xFF121212), Colors.white, 'cairo'),
    textTheme: _getTextTheme('cairo', true),
    colorScheme: ColorScheme.fromSeed(seedColor: Appcolor.primaryColor, brightness: Brightness.dark),
  );
}