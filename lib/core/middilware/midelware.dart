import 'package:flutter/src/widgets/navigator.dart';
import 'package:get/get.dart';
import 'package:hos/core/conistant/routs.dart';
import 'package:hos/core/serveces/myservisec.dart';

class Midelware extends GetMiddleware {
  int? get priority => 1;
  Myservisec myservisec = Get.find();
  @override
  RouteSettings? redirect(String? route) {
    if (myservisec.sharedPreferences.getString("step") == "2") {
      return RouteSettings(name:Approute.Homescreen);
    }
    if (myservisec.sharedPreferences.getString("step") == "1") {
      return RouteSettings(name:Approute.login);
    }
    return null;
  }
}
