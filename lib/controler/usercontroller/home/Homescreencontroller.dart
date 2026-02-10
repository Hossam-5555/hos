import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:hos/core/conistant/imageasset.dart';
import 'package:hos/veiw/userscreen/screen/cartandcheckout/cart.dart';
import 'package:hos/veiw/userscreen/screen/home/Homepage.dart';
import 'package:hos/veiw/userscreen/screen/offer.dart';
import 'package:hos/veiw/userscreen/screen/profile/profile.dart';

class Homescreencontroller extends GetxController {
  // ignore: non_constant_identifier_names
  int Currentpage = 0;

  void changpage(int i) {
    Currentpage = i;
    update();
  }

  void gotoshoppage() {
    Get.to(() => ShoppingCartPage());
  }


  var x = 20.0.obs;
  var y = 500.0.obs;

  void fun(DragUpdateDetails details) {
    x.value += details.delta.dx;
    y.value += details.delta.dy;
  }

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

  List<List<dynamic>> appbartitle = [
    ['Fashon', Imageasset.homesvg],
    ['Offer', Imageasset.offer],
    ['Profile', Imageasset.profile],
  ];
    final List<Widget> pages = [
    HomePage(), // 🔹 صفحة الهوم
    Offer(),
    ProfilePage(),
  ];

  
}
