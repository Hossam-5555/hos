import 'package:flutter/material.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/route_manager.dart';
import 'package:hos/core/conistant/routs.dart';
import 'package:hos/core/localization/transilation.dart';
import 'package:hos/core/serveces/binding.dart';

import 'package:hos/core/serveces/myservisec.dart';
// import 'package:hos/test.dart';

import 'core/localization/changlocal.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initialservisec();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    LocalController controller = Get.put(LocalController());
    return GetMaterialApp(
      // home: TestView(),
      debugShowCheckedModeBanner: false,
      initialBinding: MyBinding(),
      locale: controller.language,
      getPages: routes,
      translations: Mytransilation(),
      theme: controller.apptheme,
    );
  }
}
