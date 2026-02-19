import 'package:flutter/material.dart';
import 'package:hos/core/conistant/appcolor.dart';

ThemeData themeEnglish = ThemeData(
  scaffoldBackgroundColor:        Color(0xFFF5F6FA),

  // استخدام نظام ألوان متناسق
  colorScheme: ColorScheme.fromSeed(seedColor: Appcolor.primaryColor),
  snackBarTheme: SnackBarThemeData(
    backgroundColor: Appcolor.primaryColor,
    contentTextStyle: TextStyle(color: Colors.white),
  ),
  appBarTheme: AppBarTheme(
    iconTheme: IconThemeData(color: Colors.black, size: 24), // ← الحجم القياسي
    leadingWidth: 70, // ← العرض القياسي
    actionsIconTheme: IconThemeData(
      color: Colors.black,
      size: 24,
    ), // ← الحجم القياسي
    titleTextStyle: TextStyle(
      color: Appcolor.black,
      fontSize: 22, // ← حجم أنسب لعنوان الصفحة
      fontFamily: 'RobotoMono', // ← استخدم اسم الخط هنا
      fontWeight: FontWeight.bold,
    ),
    elevation: 0.0,
    // shape: const RoundedRectangleBorder(
    //   borderRadius: BorderRadius.only(
    //     bottomLeft: Radius.circular(25),
    //     bottomRight: Radius.circular(25),
    //   ),
    // ),
    centerTitle: true,
    backgroundColor:  Color(0xFFF5F6FA),
  ),

  textTheme: TextTheme(
    // مقياس نصوص هرمي وواضح
    headlineLarge: TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 32,
      fontFamily: 'RobotoMono',
    ),
    headlineMedium: TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 28,
      fontFamily: 'RobotoMono',
    ),
    headlineSmall: TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 20,
      color: Colors.black,
      fontFamily: 'RobotoMono',
    ),
    titleLarge: TextStyle(
      // يمكن استخدامه لعناوين الأقسام
      fontWeight: FontWeight.bold,
      fontSize: 22,
      fontFamily: 'RobotoMono',
    ),
    bodyLarge: TextStyle(
      // النص الأساسي
      fontSize: 16,
      fontFamily: 'RobotoMono',
      color: Appcolor.grey,
      height: 1.5, // ← ارتفاع سطر مريح للقراءة
    ),
    bodyMedium: TextStyle(
      // نص ثانوي
      fontSize: 14,
      fontFamily: 'RobotoMono',
      color: Appcolor.grey.withAlpha(204),
      height: 1.4,
    ),
  ),
);

// for Arabic
ThemeData themeArabic = ThemeData(
  scaffoldBackgroundColor:  Color(0xFFF5F6FA),
  // استخدام نظام ألوان متناسق
  colorScheme: ColorScheme.fromSeed(seedColor: Appcolor.primaryColor),

  appBarTheme: AppBarTheme(
    iconTheme: IconThemeData(color: Colors.black, size: 24), // ← الحجم القياسي
    leadingWidth: 70, // ← العرض القياسي
    actionsIconTheme: IconThemeData(
      color: Colors.black,
      size: 24,
    ), // ← الحجم القياسي
    titleTextStyle: TextStyle(
      color: Appcolor.black,
      fontSize: 22, // ← حجم أنسب لعنوان الصفحة
      fontFamily: 'cairo', // ← استخدم اسم الخط هنا
      fontWeight: FontWeight.bold,
    ),
    elevation: 0.0,
    // shape: const RoundedRectangleBorder(
    //   borderRadius: BorderRadius.only(
    //     bottomLeft: Radius.circular(25),
    //     bottomRight: Radius.circular(25),
    //   ),
    // ),
    centerTitle: true,
    backgroundColor: Color(0xFFF5F6FA),
  ),

  textTheme: TextTheme(
    // مقياس نصوص هرمي وواضح
    headlineLarge: TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 32,
      fontFamily: 'cairo',
    ),
    headlineMedium: TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 28,
      fontFamily: 'cairo',
    ),
    headlineSmall: TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 20,
      color: Colors.black,
      fontFamily: 'cairo',
    ),
    titleLarge: TextStyle(
      // يمكن استخدامه لعناوين الأقسام
      fontWeight: FontWeight.bold,
      fontSize: 22,
      fontFamily: 'cairo',
    ),
    bodyLarge: TextStyle(
      // النص الأساسي
      fontSize: 16,
      fontFamily: 'cairo',
      color: Appcolor.grey,
      height: 1.5, // ← ارتفاع سطر مريح للقراءة
    ),
    bodyMedium: TextStyle(
      // نص ثانوي
      fontSize: 14,
      fontFamily: 'cairo',
      color: Appcolor.grey.withAlpha(204),
      height: 1.4,
    ),
  ),
);
