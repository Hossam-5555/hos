import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:hos/core/conistant/imageasset.dart';
import 'package:hos/veiw/screen/cartandcheckout/cart.dart';
import 'package:hos/veiw/screen/home/Homepage.dart';
import 'package:hos/veiw/screen/home/notification.dart';
import 'package:hos/veiw/screen/offer.dart';
import 'package:hos/veiw/screen/profile/profile.dart';

class Homescreencontroller extends GetxController {
  // ignore: non_constant_identifier_names
  int Currentpage = 0;

  void changpage(int i) {
    Currentpage = i;
    update();
  }

  void gotoshoppage() {
    Get.to(
      () => ShoppingCartPage(),
      transition: Transition.fadeIn,
      curve: Curves.fastOutSlowIn,
      duration: Duration(milliseconds: 400),
    );
  }

  final List<Widget> pages = [
    HomePage(), // 🔹 صفحة الهوم
    Offer(),
    NotificationPage(), // 🔹 صفحة المفضلة
    ProfilePage(),
  ];

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

  List<List<dynamic>> Appbartitle = [
    ['FASHION', Imageasset.Homesvg],
    ['Offer', Imageasset.offer],
    ['notification', Imageasset.notification],
    ['Profile', Imageasset.profile],
  ];
}
