import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:hos/core/conistant/imageasset.dart';
import 'package:hos/veiw/adminscreen/Home/orders/adminaccepted.dart';
import 'package:hos/veiw/adminscreen/Home/orders/adminpending.dart';


class Orderscreencontroller extends GetxController {
  // ignore: non_constant_identifier_names
  int Currentpage = 0;

  void changpage(int i) {
    Currentpage = i;
    update();
  }



  final List<Widget> pages = [
    Adminpending(), // 🔹 صفحة الهوم
    Adminaccepted(),
 
  ];


  final ScrollController scrollController = ScrollController();
  bool upordown = true;
  void secrolcotroller() {
    if (scrollController.position.userScrollDirection ==
        ScrollDirection.reverse) {
      upordown = false;
    } else if (scrollController.position.userScrollDirection ==
        ScrollDirection.forward) {
      upordown = true;
    }
    update();
  }

  @override
  void onInit() {
    super.onInit();
    scrollController.addListener(secrolcotroller);
  }

  @override
  void onClose() {
    scrollController.removeListener(secrolcotroller);
    scrollController.dispose();
  }

  List<List<dynamic>> orderscreen = [
    ['pinding', Imageasset.Homesvg],
    ['accepted', Imageasset.offer],

  ];
}
