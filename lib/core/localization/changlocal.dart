import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hos/core/conistant/apptheme.dart';
import 'package:hos/core/functions/appmassaging.dart';
import 'package:hos/core/serveces/myservisec.dart';
import 'package:jiffy/jiffy.dart';

class LocalController extends GetxController {
  Myservisec myservisec = Get.find();

  late Locale language;
  var selectedTheme = 'System'.obs;
  ThemeData apptheme = AppTheme.darkEn;

  // تغيير اللغة
  void changeLang(String codeLang) async {
    Locale locale = Locale(codeLang);
    myservisec.sharedPreferences.setString('lang', codeLang);
    await Jiffy.setLocale(codeLang);

    Get.updateLocale(locale);
    _updateThemeLogic(); // تحديث الثيم عشان يغير نوع الخط فوراً
  }

  // تغيير الثيم من الـ Dropdown
  void changeTheme(bool? newTheme) {
    if (newTheme == null) return;
    String theme = newTheme ? 'Dark' : 'Light';
    selectedTheme.value = theme;
    myservisec.sharedPreferences.setString("theme_mode", theme);
    _updateThemeLogic();
  }

  // المنطق الموحد لتطبيق الثيم واللغة
  void _updateThemeLogic() {
    String lang = myservisec.sharedPreferences.getString("lang") ?? 'en';
    String themePref = selectedTheme.value;

    ThemeMode mode;
    ThemeData themeData;

    if (themePref == 'Light') {
      mode = ThemeMode.light;
      themeData = (lang == 'ar') ? AppTheme.lightAr : AppTheme.lightEn;
    } else if (themePref == 'Dark') {
      mode = ThemeMode.dark;
      themeData = (lang == 'ar') ? AppTheme.darkAr : AppTheme.darkEn;
    } else {
      // System Mode
      mode = ThemeMode.system;
      // بنختار ثيم افتراضي والـ OS بيقرر، لكن بنحدد الخط بناءً على اللغة
      bool isDeviceDark = Get.isPlatformDarkMode;
      if (lang == 'ar') {
        themeData = isDeviceDark ? AppTheme.darkAr : AppTheme.lightAr;
      } else {
        themeData = isDeviceDark ? AppTheme.darkEn : AppTheme.lightEn;
      }
    }

    Get.changeThemeMode(mode);
    Get.changeTheme(themeData);
  }

  @override
  void onInit() {
    // 1. استعادة اللغة
    String? sharedPreflang = myservisec.sharedPreferences.getString("lang");
    language = (sharedPreflang == "ar")
        ? const Locale('ar')
        : const Locale('en');

    // 2. استعادة الثيم
    selectedTheme.value =
        myservisec.sharedPreferences.getString("theme_mode") ?? 'System';

    // 3. تطبيق الإعدادات عند التشغيل
    _updateThemeLogic();

    // 4. صلاحيات ومساجات (وظائفك القديمة)
    requestpermition();
    appMessaging();
    super.onInit();
  }
}
