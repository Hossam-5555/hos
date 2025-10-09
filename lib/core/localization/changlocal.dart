import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get_core/get_core.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:hos/core/conistant/apptheme.dart';
import 'package:hos/core/serveces/myservisec.dart';

class LocalController extends GetxController {
  Myservisec myservisec = Get.find();
ThemeData apptheme=themeEnglish;
  late Locale language;
  void Changelang(String Codelang) {
    Locale locale = Locale(Codelang);
    myservisec.sharedPreferences.setString('lang', Codelang);
    apptheme=language=='ar'?themeArabic:themeEnglish;
    Get.changeTheme(apptheme);
    Get.updateLocale(locale);
  }

  @override
  void onInit() {
    String? sharedPreflang = myservisec.sharedPreferences.getString("lang");
    if (sharedPreflang == "ar") {
      language = Locale('ar');
      apptheme=themeArabic;
    } else if (sharedPreflang == 'en') {
      language = Locale('en');
      apptheme=themeEnglish;
    } else {
      language = Locale(Get.deviceLocale!.languageCode);
    }

    super.onInit();
  }
}
