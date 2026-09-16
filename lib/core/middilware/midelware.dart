import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hos/core/conistant/routs.dart';
import 'package:hos/core/serveces/myservisec.dart';

class Midelware extends GetMiddleware {
  @override
  int? get priority => 1;

  final Myservisec myservisec = Get.find();

  @override
  RouteSettings? redirect(String? route) {
    String? step = myservisec.sharedPreferences.getString("step");
    String? userType = myservisec.sharedPreferences.getString("usertype");

    print("🔹 Step = $step | UserType = $userType | Route = $route");

    // ✅ مسجل دخول بالفعل (step == "1") -> يروح للرئيسية حسب نوع المستخدم
    if (step == "1") {
      if (userType == "admin") {
        if (route != AdminApproate.adminHome) {
          return const RouteSettings(name: AdminApproate.adminHome);
        }
      } else {
        if (route != Approute.Homescreen) {
          return RouteSettings(name: Approute.Homescreen);
        }
      }
      return null;
    }

    // ✅ غير مسجل (step == null) -> يروح لصفحة تسجيل الدخول مباشرة
    if (route != Approute.login) {
      return RouteSettings(name: Approute.login);
    }

    return null;
  }
}