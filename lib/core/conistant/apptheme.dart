// import 'package:flutter/material.dart';
// import 'package:hos/core/conistant/appcolor.dart';

// class AppTheme {
//   // دالة مساعدة لإنشاء مقاسات النصوص الموحدة
//   static TextTheme _getTextTheme(String fontFamily, bool isDark) {
//     Color textColor = isDark ? Colors.grey[100]! : Colors.black;
//     Color bodyColor = isDark ? Colors.white : Appcolor.grey;

//     return TextTheme(
//       headlineLarge: TextStyle(
//         fontWeight: FontWeight.bold,
//         fontSize: 32,
//         fontFamily: fontFamily,
//         color: textColor,
//       ),
//       headlineMedium: TextStyle(
//         fontWeight: FontWeight.bold,
//         fontSize: 28,
//         fontFamily: fontFamily,
//         color: textColor,
//       ),
//       headlineSmall: TextStyle(
//         fontWeight: FontWeight.bold,
//         fontSize: 20,
//         fontFamily: fontFamily,
//         color: textColor,
//       ),
//       titleLarge: TextStyle(
//         fontWeight: FontWeight.bold,
//         fontSize: 22,
//         fontFamily: fontFamily,
//         color: textColor,
//       ),
//       bodyLarge: TextStyle(
//         fontSize: 16,
//         fontFamily: fontFamily,
//         color: bodyColor,
//         height: 1.5,
//       ),
//       bodyMedium: TextStyle(
//         fontSize: 14,
//         fontFamily: fontFamily,
//         color: bodyColor.withAlpha(204),
//         height: 1.4,
//       ),
//     );
//   }

//   static AppBarTheme _appBar(Color bg, Color content, String font) {
//     return AppBarTheme(
//       backgroundColor: bg,
//       elevation: 0.0,
//       centerTitle: true,
//       iconTheme: IconThemeData(color: content, size: 24),
//       titleTextStyle: TextStyle(
//         color: content,
//         fontSize: 22,
//         fontFamily: font,
//         fontWeight: FontWeight.bold,
//       ),
//     );
//   }

//   // الـ 4 قوالب الأساسية
//   static ThemeData lightEn = ThemeData(
//     brightness: Brightness.light,
//     scaffoldBackgroundColor: Color(0xFFF7F9FF),
//     appBarTheme: _appBar(Color(0xFFF7F9FF), Colors.black, 'RobotoMono'),
//     textTheme: _getTextTheme('RobotoMono', false),
//     colorScheme: ColorScheme.fromSeed(seedColor: Appcolor.primaryColor),
//   );

//   static ThemeData darkEn = ThemeData(
//     brightness: Brightness.dark,
//     scaffoldBackgroundColor: const Color(0xFF121212),
//     appBarTheme: _appBar(const Color(0xFF121212), Colors.white, 'RobotoMono'),
//     textTheme: _getTextTheme('RobotoMono', true),
//     colorScheme: ColorScheme.fromSeed(
//       seedColor: Appcolor.primaryColor,
//       brightness: Brightness.dark,
//     ),
//   );

//   static ThemeData lightAr = ThemeData(
//     brightness: Brightness.light,
//     scaffoldBackgroundColor: Color(0xFFF7F9FF),
//     appBarTheme: _appBar(Color(0xFFF7F9FF), Colors.black, 'cairo'),
//     textTheme: _getTextTheme('cairo', false),
//     colorScheme: ColorScheme.fromSeed(seedColor: Appcolor.primaryColor),
//   );

//   static ThemeData darkAr = ThemeData(
//     brightness: Brightness.dark,
//     scaffoldBackgroundColor: const Color(0xFF121212),
//     appBarTheme: _appBar(const Color(0xFF121212), Colors.white, 'cairo'),
//     textTheme: _getTextTheme('cairo', true),
//     colorScheme: ColorScheme.fromSeed(
//       seedColor: Appcolor.primaryColor,
//       brightness: Brightness.dark,
//     ),
//   );
// }
import 'package:flutter/material.dart';
import 'package:hos/core/conistant/appcolor.dart';

class AppTheme {
  // 1. ألوان احترافية للثيم الفاتح (Light Palette)
  static const Color _lightBg = Color(0xFFF9FAFB); // خلفية مريحة جداً تبرز المنتجات
  static const Color _lightSurface = Color(0xFFFFFFFF); // لون البطاقات أبيض نقي
  static const Color _lightTextMain = Color(0xFF111827); // أسود مطفأ (لا يرهق العين)
  static const Color _lightTextSec = Color(0xFF6B7280); // رمادي للنصوص الثانوية والأسعار القديمة

  // 2. ألوان احترافية للثيم الداكن (Dark Palette)
  static const Color _darkBg = Color(0xFF1F1F1F); // أسود فخم وعميق للخلفية
  static const Color _darkSurface = Color(0xFF161616); // درجة أفتح للبطاقات لخلق عمق
  static const Color _darkTextMain = Color(0xFFF5F5F7); // أبيض عاجي يمنع التشتت
  static const Color _darkTextSec = Color(0xFF8E8E93); // رمادي فاتح للنصوص الثانوية

  // دالة مساعدة لإنشاء مقاسات النصوص الموحدة
  static TextTheme _getTextTheme(String fontFamily, bool isDark) {
    Color mainColor = isDark ? _darkTextMain : _lightTextMain;
    Color secColor = isDark ? _darkTextSec : _lightTextSec;

    return TextTheme(
      headlineLarge: TextStyle(fontWeight: FontWeight.bold, fontSize: 32, fontFamily: fontFamily, color: mainColor),
      headlineMedium: TextStyle(fontWeight: FontWeight.bold, fontSize: 28, fontFamily: fontFamily, color: mainColor),
      headlineSmall: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, fontFamily: fontFamily, color: mainColor),
      titleLarge: TextStyle(fontWeight: FontWeight.bold, fontSize: 22, fontFamily: fontFamily, color: mainColor),
      bodyLarge: TextStyle(fontSize: 16, fontFamily: fontFamily, color: mainColor, height: 1.5),
      bodyMedium: TextStyle(fontSize: 14, fontFamily: fontFamily, color: secColor, height: 1.4),
    );
  }

  // دالة مساعدة للـ AppBar
  static AppBarTheme _appBar(Color bg, Color content, String font) {
    return AppBarTheme(
      backgroundColor: bg,
      elevation: 0.0,
      scrolledUnderElevation: 0.0, // تمنع تغير اللون عند الـ Scroll
      centerTitle: true,
      iconTheme: IconThemeData(color: content, size: 24),
      titleTextStyle: TextStyle(color: content, fontSize: 22, fontFamily: font, fontWeight: FontWeight.bold),
    );
  }

  // دالة مساعدة لتوحيد شكل أزرار التطبيق (مثل زر إضافة للسلة)
  static ElevatedButtonThemeData _elevatedButtonTheme() {
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Appcolor.black, // لون أزرق داكن أنيق للأزرار
        foregroundColor: Colors.white, // نص الزر أبيض ليكون واضحاً
        elevation: 0,
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
        shape: RoundedRectangleBorder(side: BorderSide(color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(40),
        ),
      ),
    );
  }

  // دالة مساعدة لتوحيد شكل بطاقات المنتجات (Cards)
  static CardThemeData _cardTheme(Color color, double elevation) {
    return CardThemeData(
      color: color,
      elevation: elevation,
      shadowColor: Colors.black.withOpacity(0.05), // ظل خفيف جداً وأنيق
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(40),
      ),
      margin: EdgeInsets.zero,
    );
  }

  // ==========================================
  // الـ 4 قوالب الأساسية للتطبيق (لا تغيير في الأسماء)
  // ==========================================

  static ThemeData lightEn = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: _lightBg,
    appBarTheme: _appBar(_lightBg, _lightTextMain, 'RobotoMono'),
    textTheme: _getTextTheme('RobotoMono', false),
    colorScheme: ColorScheme.fromSeed(
      seedColor: Appcolor.primaryColor,
      surface: _lightSurface,
    ),
    elevatedButtonTheme: _elevatedButtonTheme(),
    cardTheme: _cardTheme(_lightSurface, 2.0), // إضافة ظل خفيف للكروت في الفاتح
  );

  static ThemeData darkEn = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: _darkBg,
    appBarTheme: _appBar(_darkBg, _darkTextMain, 'RobotoMono'),
    textTheme: _getTextTheme('RobotoMono', true),
    colorScheme: ColorScheme.fromSeed(
      seedColor: Appcolor.primaryColor,
      brightness: Brightness.dark,
      surface: _darkSurface,
    ),
    elevatedButtonTheme: _elevatedButtonTheme(),
    cardTheme: _cardTheme(_darkSurface, 0.0), // بدون ظل في الداكن (العمق يأتي من اللون)
  );

  static ThemeData lightAr = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: _lightBg,
    appBarTheme: _appBar(_lightBg, _lightTextMain, 'cairo'),
    textTheme: _getTextTheme('cairo', false),
    colorScheme: ColorScheme.fromSeed(
      seedColor: Appcolor.primaryColor,
      surface: _lightSurface,
    ),
    elevatedButtonTheme: _elevatedButtonTheme(),
    cardTheme: _cardTheme(_lightSurface, 2.0),
  );

  static ThemeData darkAr = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: _darkBg,
    appBarTheme: _appBar(_darkBg, _darkTextMain, 'cairo'),
    textTheme: _getTextTheme('cairo', true),
    colorScheme: ColorScheme.fromSeed(
      seedColor: Appcolor.primaryColor,
      brightness: Brightness.dark,
      surface: _darkSurface,
    ),
    elevatedButtonTheme: _elevatedButtonTheme(),
    cardTheme: _cardTheme(_darkSurface, 0.0),
  );
}