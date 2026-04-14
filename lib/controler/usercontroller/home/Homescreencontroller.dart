import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:hos/controler/usercontroller/home/Homepage_controller.dart';
import 'package:hos/core/class/searchclass.dart';
import 'package:hos/core/conistant/imageasset.dart';
import 'package:hos/core/conistant/routs.dart';
import 'package:hos/veiw/userscreen/screen/cartandcheckout/cart.dart';
import 'package:hos/veiw/userscreen/screen/home/Homepage.dart';
import 'package:hos/veiw/userscreen/screen/offer.dart';
import 'package:hos/veiw/userscreen/screen/profile/profile.dart';

class Homescreencontroller extends SearchMix {
  // ignore: non_constant_identifier_names
  int Currentpage = 0;
  PageController pageControllers = PageController();
  void onpagechnage(int i) {
    Currentpage = i;
    update();
  }

  void changpage(int i) {
    if ((Currentpage - i) > 1) {
      pageControllers.jumpToPage(i);
    } else {
      pageControllers.animateToPage(
        i,
        duration: Duration(milliseconds: 250),
        curve: Curves.easeIn,
      );
    }
    Currentpage = i;

    // 👇 تحكم في تايمر الهوم
    if (i == 0 && Get.currentRoute != Approute.Homepage) {
      Get.find<HomepageController>().startTimer();
    } else {
      Get.find<HomepageController>().stopTimer();
    }

    update();
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
    pageControllers.dispose();
  }

  List<List<dynamic>> appbartitle = [
    ['Fashon', Imageasset.homesvg],
    ['Cart', Imageasset.cart],
    ['Offer', Imageasset.offer],
    ['Profile', Imageasset.profile],
  ];
  final List<Widget> pages = [
    HomePage(),
    ShoppingCartPage(),
    Offer(),
    ProfilePage(),
  ];
}
