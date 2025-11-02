import 'package:flutter/src/widgets/navigator.dart';
import 'package:get/get.dart';
import 'package:hos/core/conistant/routs.dart';
import 'package:hos/core/serveces/myservisec.dart';

// class Midelware extends GetMiddleware {
//   int? get priority => 1;
//   Myservisec myservisec = Get.find();
//   @override
//   RouteSettings? redirect(String? route) {
//     if (myservisec.sharedPreferences.getString("step") == "2") {
//       return RouteSettings(name:Approute.Homescreen);
//     }
//     if (myservisec.sharedPreferences.getString("step") == "1") {
//       return RouteSettings(name:Approute.login);
//     }
//     return null;
//   }
// }
import 'package:flutter/material.dart';


class Midelware extends GetMiddleware {
  @override
  int? get priority => 1;

  final Myservisec myservisec = Get.find();

  @override
  RouteSettings? redirect(String? route) {
    String? step = myservisec.sharedPreferences.getString("step");
    String? userType = myservisec.sharedPreferences.getString("usertype");

    // 🔹 أول تشغيل للتطبيق — لسه محددش اللغة
    if (step == null) {
      return  RouteSettings(name: Approute.language);
    }

    // 🔹 بعد ما يختار اللغة (step = 1) — يروح يسجل الدخول
    if (step == "1") {
      return  RouteSettings(name: Approute.login);
    }

    // 🔹 بعد تسجيل الدخول (step = 2) — نحدد الواجهة حسب نوع المستخدم
    if (step == "2") {
      if (userType == "admin") {
        return RouteSettings(name: AdminApproate.adminHome);
      } else if (userType == "driver") {
        return  RouteSettings(name: AdminApproate.driverHome);
      } else {
        return  RouteSettings(name: Approute.Homescreen);
      }
    }

    return null;
  }
}
