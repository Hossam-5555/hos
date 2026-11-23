import 'package:flutter/material.dart';

/// Raw HIG tokens. Aliases and [AppPalette] both reference these so they stay `const`.
abstract final class _Tok {
  static const lightBackground = Color(0xFFF2F2F7);
  static const darkBackground = Color(0xFF000000);
  static const lightSurface = Color(0xFFFFFFFF);
  static const darkSurface = Color(0xFF1C1C1E);
  static const lightSurfaceElevated = Color(0xFFFFFFFF);
  static const darkSurfaceElevated = Color(0xFF2C2C2E);
  static const lightTextPrimary = Color(0xFF000000);
  static const darkTextPrimary = Color(0xFFFFFFFF);
  static const lightTextSecondary = Color.fromARGB(153, 108, 108, 112);
  static const darkTextSecondary = Color(0x99EBEBF5);
  static const lightTextTertiary = Color(0x4D3C3C43);
  static const darkTextTertiary = Color(0x4DEBEBF5);
  static const lightSeparator = Color(0x4A3C3C43);
  static const darkSeparator = Color(0x99545458);
  static const lightFill = Color(0x33787880);
  static const darkFill = Color(0x5C787880);
  static const lightPrimary = Color(0xFF1C1C1E);
  static const darkPrimary = Color(0xFFFFFFFF);
  static const lightOnPrimary = Color(0xFFFFFFFF);
  static const darkOnPrimary = Color(0xFF1C1C1E);
  static const lightTint = Color(0xFF007AFF);
  static const darkTint = Color(0xFF0A84FF);
  static const lightSuccess = Color(0xFF34C759);
  static const darkSuccess = Color(0xFF30D158);
  static const lightDanger = Color(0xFFFF3B30);
  static const darkDanger = Color(0xFFFF453A);
  static const lightWarning = Color(0xFFFF9500);
  static const darkWarning = Color(0xFFFF9F0A);
  static const lightShipped = Color(0xFF5856D6);
  static const darkShipped = Color(0xFF5E5CE6);
  static const gray = Color(0xFF8E8E93);
  static const lightGray2 = Color(0xFFAEAEB2);
  static const darkGray2 = Color(0xFF636366);
  static const lightGray3 = Color(0xFFC7C7CC);
  static const darkGray3 = Color(0xFF48484A);
  static const lightGray4 = Color(0xFFD1D1D6);
  static const darkGray4 = Color(0xFF3A3A3C);
  static const lightGray5 = Color(0xFFE5E5EA);
  static const darkGray5 = Color(0xFF2C2C2E);
  static const onImage = Color(0xFFFFFFFF);
  static const scrim = Color(0x99000000);
  static const lightShadow = Color(0x14000000);
  static const darkShadow = Color(0x00000000);
  static const languageEnd = Color(0xFFF57C00);
  static const aboutEnd = Color(0xFF248A3D);
  static const contactEnd = Color(0xFF0040DD);
  static const logoutEnd = Color(0xFFD70015);
  static const themeEnd = Color(0xFF3634A3);
}

/// Apple HIG semantic palette (Light / Dark). Access via [AppColors.of].
@immutable
class AppPalette extends ThemeExtension<AppPalette> {
  const AppPalette({
    required this.background,
    required this.surface,
    required this.surfaceElevated,
    required this.textPrimary,
    required this.textSecondary,
    required this.textTertiary,
    required this.separator,
    required this.fill,
    required this.primary,
    required this.onPrimary,
    required this.tint,
    required this.success,
    required this.danger,
    required this.warning,
    required this.shipped,
    required this.gray,
    required this.gray2,
    required this.gray3,
    required this.gray4,
    required this.gray5,
    required this.onImage,
    required this.scrim,
    required this.shadow,
  });

  final Color background;
  final Color surface;
  final Color surfaceElevated;
  final Color textPrimary;
  final Color textSecondary;
  final Color textTertiary;
  final Color separator;
  final Color fill;
  final Color primary;
  final Color onPrimary;
  final Color tint;
  final Color success;
  final Color danger;
  final Color warning;
  final Color shipped;
  final Color gray;
  final Color gray2;
  final Color gray3;
  final Color gray4;
  final Color gray5;
  final Color onImage;
  final Color scrim;
  final Color shadow;

  Color get statusPending => warning;
  Color get statusProcessing => tint;
  Color get statusShipped => shipped;
  Color get statusDelivered => success;
  Color get statusCancelled => danger;

  static const light = AppPalette(
    background: _Tok.lightBackground,
    surface: _Tok.lightSurface,
    surfaceElevated: _Tok.lightSurfaceElevated,
    textPrimary: _Tok.lightTextPrimary,
    textSecondary: _Tok.lightTextSecondary,
    textTertiary: _Tok.lightTextTertiary,
    separator: _Tok.lightSeparator,
    fill: _Tok.lightFill,
    primary: _Tok.lightPrimary,
    onPrimary: _Tok.lightOnPrimary,
    tint: _Tok.lightTint,
    success: _Tok.lightSuccess,
    danger: _Tok.lightDanger,
    warning: _Tok.lightWarning,
    shipped: _Tok.lightShipped,
    gray: _Tok.gray,
    gray2: _Tok.lightGray2,
    gray3: _Tok.lightGray3,
    gray4: _Tok.lightGray4,
    gray5: _Tok.lightGray5,
    onImage: _Tok.onImage,
    scrim: _Tok.scrim,
    shadow: _Tok.lightShadow,
  );

  static const dark = AppPalette(
    background: _Tok.darkBackground,
    surface: _Tok.darkSurface,
    surfaceElevated: _Tok.darkSurfaceElevated,
    textPrimary: _Tok.darkTextPrimary,
    textSecondary: _Tok.darkTextSecondary,
    textTertiary: _Tok.darkTextTertiary,
    separator: _Tok.darkSeparator,
    fill: _Tok.darkFill,
    primary: _Tok.darkPrimary,
    onPrimary: _Tok.darkOnPrimary,
    tint: _Tok.darkTint,
    success: _Tok.darkSuccess,
    danger: _Tok.darkDanger,
    warning: _Tok.darkWarning,
    shipped: _Tok.darkShipped,
    gray: _Tok.gray,
    gray2: _Tok.darkGray2,
    gray3: _Tok.darkGray3,
    gray4: _Tok.darkGray4,
    gray5: _Tok.darkGray5,
    onImage: _Tok.onImage,
    scrim: _Tok.scrim,
    shadow: _Tok.darkShadow,
  );

  @override
  AppPalette copyWith({
    Color? background,
    Color? surface,
    Color? surfaceElevated,
    Color? textPrimary,
    Color? textSecondary,
    Color? textTertiary,
    Color? separator,
    Color? fill,
    Color? primary,
    Color? onPrimary,
    Color? tint,
    Color? success,
    Color? danger,
    Color? warning,
    Color? shipped,
    Color? gray,
    Color? gray2,
    Color? gray3,
    Color? gray4,
    Color? gray5,
    Color? onImage,
    Color? scrim,
    Color? shadow,
  }) {
    return AppPalette(
      background: background ?? this.background,
      surface: surface ?? this.surface,
      surfaceElevated: surfaceElevated ?? this.surfaceElevated,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      textTertiary: textTertiary ?? this.textTertiary,
      separator: separator ?? this.separator,
      fill: fill ?? this.fill,
      primary: primary ?? this.primary,
      onPrimary: onPrimary ?? this.onPrimary,
      tint: tint ?? this.tint,
      success: success ?? this.success,
      danger: danger ?? this.danger,
      warning: warning ?? this.warning,
      shipped: shipped ?? this.shipped,
      gray: gray ?? this.gray,
      gray2: gray2 ?? this.gray2,
      gray3: gray3 ?? this.gray3,
      gray4: gray4 ?? this.gray4,
      gray5: gray5 ?? this.gray5,
      onImage: onImage ?? this.onImage,
      scrim: scrim ?? this.scrim,
      shadow: shadow ?? this.shadow,
    );
  }

  @override
  AppPalette lerp(ThemeExtension<AppPalette>? other, double t) {
    if (other is! AppPalette) return this;
    Color l(Color a, Color b) => Color.lerp(a, b, t)!;
    return AppPalette(
      background: l(background, other.background),
      surface: l(surface, other.surface),
      surfaceElevated: l(surfaceElevated, other.surfaceElevated),
      textPrimary: l(textPrimary, other.textPrimary),
      textSecondary: l(textSecondary, other.textSecondary),
      textTertiary: l(textTertiary, other.textTertiary),
      separator: l(separator, other.separator),
      fill: l(fill, other.fill),
      primary: l(primary, other.primary),
      onPrimary: l(onPrimary, other.onPrimary),
      tint: l(tint, other.tint),
      success: l(success, other.success),
      danger: l(danger, other.danger),
      warning: l(warning, other.warning),
      shipped: l(shipped, other.shipped),
      gray: l(gray, other.gray),
      gray2: l(gray2, other.gray2),
      gray3: l(gray3, other.gray3),
      gray4: l(gray4, other.gray4),
      gray5: l(gray5, other.gray5),
      onImage: l(onImage, other.onImage),
      scrim: l(scrim, other.scrim),
      shadow: l(shadow, other.shadow),
    );
  }
}

/// Central palette. Theme-aware tokens: [AppColors.of]. Static names are aliases.
class AppColors {
  AppColors._();

  static AppPalette of(BuildContext context) {
    return Theme.of(context).extension<AppPalette>() ??
        (Theme.of(context).brightness == Brightness.dark
            ? AppPalette.dark
            : AppPalette.light);
  }

  // --- Existing names (aliases). Values updated; names unchanged. ---
  static const primary = _Tok.lightPrimary;
  static const Color iconscolor = _Tok.lightGray5;
  static const purple = _Tok.lightShipped;
  static const success = _Tok.lightSuccess;
  static const warning = _Tok.lightWarning;
  static const danger = _Tok.lightDanger;
  static const orange = _Tok.lightWarning;
  static const Color grey = _Tok.gray;
  static const Color primaryColor = _Tok.lightTint;
  static const Color black = _Tok.lightTextPrimary;
  static const Color white = _Tok.onImage;
  static const Color deepPurple = _Tok.lightShipped;
  static const Color glass = _Tok.lightFill;
  static const Color blackblue = _Tok.scrim;
  static const favoriteStart = _Tok.lightDanger;
  static const favoriteEnd = _Tok.lightDanger;
  static const languageStart = _Tok.lightWarning;
  static const languageEnd = _Tok.languageEnd;
  static const aboutStart = _Tok.lightSuccess;
  static const aboutEnd = _Tok.aboutEnd;
  static const contactStart = _Tok.lightTint;
  static const contactEnd = _Tok.contactEnd;
  static const logoutStart = _Tok.lightDanger;
  static const logoutEnd = _Tok.logoutEnd;
  static const logout = _Tok.lightDanger;
  static const primaryStart = _Tok.lightTint;
  static const primaryEnd = _Tok.contactEnd;
  static const themeStart = _Tok.lightShipped;
  static const themeEnd = _Tok.themeEnd;
  static const arabic = _Tok.lightSuccess;
  static const english = _Tok.lightTint;
  static const editBackground = _Tok.lightGray5;
  static const themeLightIcon = _Tok.lightWarning;
  static const darkBorder = _Tok.darkSeparator;
  static const lightBorder = _Tok.lightSeparator;
  static const darkShadow = _Tok.darkShadow;
  static const lightShadow = _Tok.lightShadow;
  static const darkImageSurface = _Tok.darkFill;
  static const lightImageSurface = _Tok.lightFill;
  static const darkCardSurface = _Tok.darkSurfaceElevated;
  static const lightCardSurface = _Tok.lightSurface;
  static const mutedText = _Tok.lightTextSecondary;
  static const border = _Tok.lightSeparator;
  static const shadow = _Tok.lightShadow;

  static const darkSurface = _Tok.darkSurface;
  static const lightSurface = _Tok.lightSurface;

  static const Color sortChipLightBg = _Tok.lightSurface;
  static const Color sortChipDarkBg = _Tok.darkSurface;
  static const Color sortChipLightBorder = _Tok.lightSeparator;
  static const Color sortChipDarkBorder = _Tok.darkSeparator;
  static const Color sortChipLightPrimary = _Tok.lightPrimary;
  static const Color sortChipDarkPrimary = _Tok.darkPrimary;
  static const Color sortChipLightOnPrimary = _Tok.lightOnPrimary;
  static const Color sortChipDarkOnPrimary = _Tok.darkOnPrimary;
  static const Color sortChipLightTextSecondary = _Tok.gray;
  static const Color sortChipDarkTextSecondary = _Tok.gray;
}
