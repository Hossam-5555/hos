import 'package:flutter/material.dart';
import 'package:hos/core/conistant/appcolor.dart';

ThemeData themeEnglish = ThemeData(
  scaffoldBackgroundColor: Color(0xFF121212),
  // استخدام نظام ألوان متناسق
  colorScheme: ColorScheme.fromSeed(seedColor: Appcolor.primaryColor),

  appBarTheme: AppBarTheme(
    iconTheme: IconThemeData(color: Colors.black, size: 24), // ← الحجم القياسي
    leadingWidth: 56, // ← العرض القياسي
    actionsIconTheme: IconThemeData(
      color: Colors.black,
      size: 24,
    ), // ← الحجم القياسي
    titleTextStyle: TextStyle(
      color: Appcolor.grey,
      fontSize: 22, // ← حجم أنسب لعنوان الصفحة
      fontFamily: 'Italic', // ← استخدم اسم الخط هنا
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
    backgroundColor:Color.fromARGB(206, 56, 73, 93)
  ),

  textTheme: TextTheme(
    // مقياس نصوص هرمي وواضح
    headlineLarge: TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 32,
      fontFamily: 'Italic',
    ),
    headlineMedium: TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 28,
      fontFamily: 'Italic',
    ),
    headlineSmall: TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 20,
      color: Colors.white,
      fontFamily: 'Italic',
    ),
    titleLarge: TextStyle(
      // يمكن استخدامه لعناوين الأقسام
      fontWeight: FontWeight.bold,
      fontSize: 22,
      fontFamily: 'Italic',
    ),
    bodyLarge: TextStyle(
      // النص الأساسي
      fontSize: 16,
      fontFamily: 'Italic',
      color: Appcolor.grey,
      height: 1.5, // ← ارتفاع سطر مريح للقراءة
    ),
    bodyMedium: TextStyle(
      // نص ثانوي
      fontSize: 14,
      fontFamily: 'Italic',
      color: Appcolor.grey.withOpacity(0.8),
      height: 1.4,
    ),
  ),
);

// for Arabic

ThemeData themeArabic = ThemeData(
  scaffoldBackgroundColor: Color(0xffede6fb),
  // استخدام نظام ألوان متناسق
  colorScheme: ColorScheme.fromSeed(seedColor: Appcolor.primaryColor),

  appBarTheme: AppBarTheme(
    iconTheme: IconThemeData(color: Colors.black, size: 24), // ← الحجم القياسي
    leadingWidth: 56, // ← العرض القياسي
    actionsIconTheme: IconThemeData(
      color: Colors.black,
      size: 24,
    ), // ← الحجم القياسي
    titleTextStyle: TextStyle(
      color: Appcolor.grey,
      fontSize: 22, // ← حجم أنسب لعنوان الصفحة
      fontFamily: 'cairo', // ← استخدم اسم الخط هنا
      fontWeight: FontWeight.bold,
    ),
    elevation: 0.0,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        bottomLeft: Radius.circular(25),
        bottomRight: Radius.circular(25),
      ),
    ),
    centerTitle: true,
    backgroundColor: Color(0xffede6fb),
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
      fontSize: 24,
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
      color: Appcolor.grey.withOpacity(0.8),
      height: 1.4,
    ),
  ),
);
