import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hos/veiw/userscreen/screen/profile/order/orders.dart';
import 'package:hos/veiw/userscreen/screen/profile/settings/addres/viewaddres.dart';

class Profilepagecontroller extends GetxController {
  goaddres() {
    Get.to(
      () => viewmyaddres(),
      transition: Transition.fadeIn,
      curve: Curves.easeIn,
      duration: Duration(milliseconds: 400),
    );
  }


    gotoorders() {
    Get.to(
      () => Orders(),
      transition: Transition.fadeIn,
      curve: Curves.easeIn,
      duration: Duration(milliseconds: 400),
    );
  }
}
