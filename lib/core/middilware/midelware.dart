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

    // ✅ أول مرة يفتح التطبيق — لسه محددش اللغة
    if (step == null) {
      if (route != Approute.Onboarding) {
        return RouteSettings(name: Approute.Onboarding);
      }
      return null;
    }

    // ✅ بعد اختيار اللغة — يروح لتسجيل الدخول
    if (step == "1") {
      if (route != Approute.login) {
        return RouteSettings(name: Approute.login);
      }
      return null;
    }

    // ✅ بعد تسجيل الدخول — يروح حسب نوع المستخدم
    if (step == "2") {
      if (userType == "admin") {
        if (route != AdminApproate.adminHome) {
          return const RouteSettings(name: AdminApproate.adminHome);
        }
      }  else {
        if (route != Approute.Homescreen) {
          return RouteSettings(name: Approute.Homescreen);
        }
      }
      return null;
    }

    return null;
  }
}
