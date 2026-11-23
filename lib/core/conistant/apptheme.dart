import 'package:flutter/material.dart';
import 'package:hos/core/conistant/app_colors.dart';

class AppTheme {
  static TextTheme _getTextTheme(String fontFamily, AppPalette palette) {
    return TextTheme(
      headlineLarge: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 32,
        fontFamily: fontFamily,
        color: palette.textPrimary,
      ),
      headlineMedium: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 28,
        fontFamily: fontFamily,
        color: palette.textPrimary,
      ),
      headlineSmall: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 20,
        fontFamily: fontFamily,
        color: palette.textPrimary,
      ),
      titleLarge: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 22,
        fontFamily: fontFamily,
        color: palette.textPrimary,
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        fontFamily: fontFamily,
        color: palette.textPrimary,
        height: 1.5,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        fontFamily: fontFamily,
        color: palette.textSecondary,
        height: 1.4,
      ),
    );
  }

  static AppBarTheme _appBar(AppPalette palette, String font) {
    return AppBarTheme(
      backgroundColor: palette.background,
      elevation: 0.0,
      scrolledUnderElevation: 0.0,
      centerTitle: true,
      iconTheme: IconThemeData(color: palette.textPrimary, size: 24),
      titleTextStyle: TextStyle(
        color: palette.textPrimary,
        fontSize: 22,
        fontFamily: font,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  static ElevatedButtonThemeData _elevatedButtonTheme(AppPalette palette) {
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: palette.primary,
        foregroundColor: palette.onPrimary,
        elevation: 0,
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
        shape: RoundedRectangleBorder(
          side: BorderSide(color: palette.separator),
          borderRadius: BorderRadius.circular(40),
        ),
      ),
    );
  }

  static CardThemeData _cardTheme(AppPalette palette, double elevation) {
    return CardThemeData(
      color: palette.surface,
      elevation: elevation,
      shadowColor: palette.shadow,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(40),
      ),
      margin: EdgeInsets.zero,
    );
  }

  static ColorScheme _colorScheme(AppPalette palette, Brightness brightness) {
    return ColorScheme(
      brightness: brightness,
      primary: palette.primary,
      onPrimary: palette.onPrimary,
      secondary: palette.tint,
      onSecondary: palette.onImage,
      error: palette.danger,
      onError: palette.onImage,
      surface: palette.surface,
      onSurface: palette.textPrimary,
    );
  }

  static ThemeData _theme({
    required AppPalette palette,
    required String fontFamily,
    required bool isDark,
  }) {
    final brightness = isDark ? Brightness.dark : Brightness.light;
    return ThemeData(
      brightness: brightness,
      scaffoldBackgroundColor: palette.background,
      canvasColor: palette.background,
      dividerColor: palette.separator,
      appBarTheme: _appBar(palette, fontFamily),
      textTheme: _getTextTheme(fontFamily, palette),
      colorScheme: _colorScheme(palette, brightness),
      elevatedButtonTheme: _elevatedButtonTheme(palette),
      cardTheme: _cardTheme(palette, isDark ? 0.0 : 2.0),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return palette.onImage;
          return palette.surfaceElevated;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return palette.tint;
          return palette.fill;
        }),
      ),
      extensions: <ThemeExtension<dynamic>>[palette],
    );
  }

  static ThemeData lightEn = _theme(
    palette: AppPalette.light,
    fontFamily: 'SFProDisplay',
    isDark: false,
  );

  static ThemeData darkEn = _theme(
    palette: AppPalette.dark,
    fontFamily: 'SFProDisplay',
    isDark: true,
  );

  static ThemeData lightAr = _theme(
    palette: AppPalette.light,
    fontFamily: 'cairo',
    isDark: false,
  );

  static ThemeData darkAr = _theme(
    palette: AppPalette.dark,
    fontFamily: 'cairo',
    isDark: true,
  );
}
