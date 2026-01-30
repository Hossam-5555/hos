import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:hos/core/serveces/myservisec.dart';

class Gotoanypagecalss  {
  Myservisec myservisec=Get.put(Myservisec());
   // ignore: non_constant_identifier_names
   void Gotoanypage(Widget wedget, bool islogout,Map arguments) {
    if (islogout) {
      myservisec.sharedPreferences.clear();
    }
    Get.to(fullscreenDialog: true,
      () => wedget,
      arguments:arguments ,
      duration: Duration(milliseconds: 400),
      transition: Transition.fadeIn,
    );
  }
}