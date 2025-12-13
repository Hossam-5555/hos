import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hos/core/serveces/myservisec.dart';

class Gotoanypagecalss extends GetxController {
  Myservisec myservisec=Get.put(Myservisec());
   Gotoanypage(Widget wedget, bool islogout,dynamic arguments) {
    if (islogout) {
      myservisec.sharedPreferences.clear();
    }
    Get.to(
      () => wedget,
      arguments:arguments ,
      duration: Duration(milliseconds: 700),
      transition: Transition.fadeIn,
    );
  }
}