import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hos/core/serveces/myservisec.dart';

class Gotoanypagecalss {
  Myservisec myservisec=Get.put(Myservisec());
   Gotoanypage(Widget wedget, bool islogout) {
    if (islogout) {
      myservisec.sharedPreferences.clear();
    }
    Get.to(
      () => wedget,
      duration: Duration(milliseconds: 700),
      transition: Transition.fadeIn,
    );
  }
}