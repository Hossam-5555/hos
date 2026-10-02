import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:hos/core/conistant/routs.dart';
import 'package:hos/core/localization/transilation.dart';
import 'package:hos/core/serveces/binding.dart';

import 'package:hos/core/serveces/myservisec.dart';
import 'package:jiffy/jiffy.dart';

import 'core/localization/changlocal.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await initialservisec();
  final lang = Get.find<Myservisec>().sharedPreferences.getString('lang') ?? 'en';
  await Jiffy.setLocale(lang);
FlutterNativeSplash.remove();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    LocalController controller = Get.put(LocalController());
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialBinding: MyBinding(),
      locale: controller.language,
      getPages: routes,
      translations: Mytransilation(),
      theme: controller.apptheme,
      themeMode: controller.selectedTheme.value == 'Light'
          ? ThemeMode.light
          : controller.selectedTheme.value == 'Dark'
          ? ThemeMode.dark
          : ThemeMode.system,
    );
  }
}
