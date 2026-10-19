import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:hos/controler/usercontroller/home/homepage_controller.dart';
import 'package:hos/core/class/searchclass.dart';
import 'package:hos/core/conistant/imageasset.dart';
import 'package:hos/core/conistant/routs.dart';
import 'package:hos/veiw/userscreen/screen/cartandcheckout/cart.dart';
import 'package:hos/veiw/userscreen/screen/home/home_page.dart';
import 'package:hos/veiw/userscreen/screen/profile/profile.dart';
import 'package:hos/veiw/userscreen/screen/searchpage.dart';

class Homescreencontroller extends SearchMix {
  // ignore: non_constant_identifier_names
  int Currentpage = 0;
  PageController pageControllers = PageController();
  void onpagechnage(int i) {
    Currentpage = i;
    update();
  }

   String get userName => myservisec.sharedPreferences.getString("usersname") ?? "User Name";
    String get email => myservisec.sharedPreferences.getString("email") ?? "user@email.com";
  void changpage(int i) {
    pageControllers.jumpToPage(i);
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

bool upordown = true;

  /// دالة تحديث الرؤية بناءً على اتجاه السكرول
  void onScrollNotification(ScrollDirection direction) {
    if (direction == ScrollDirection.reverse && upordown != false) {
      upordown = false;
      update(); // بيعمل update فقط لما يتغير الشريط من ظاهر لـ مخفي
    } else if (direction == ScrollDirection.forward && upordown != true) {
      upordown = true;
      update(); // بيعمل update فقط لما يتغير الشريط من مخفي لـ ظاهر
    }
  }

  double orderSummaryOffset = 0.0;

void onOrderScroll(double offset) {
  orderSummaryOffset = offset.clamp(0.0, 150.0);
  update();
}

  @override
  void onClose() {
 
    pageControllers.dispose();
  }

  List get appbartitle=> [
    ['Home'.tr, Imageasset.homesvg],
    ['Search'.tr, Imageasset.search],
    ['Cart'.tr, Imageasset.cart],
    ['Profile'.tr,Imageasset.profile],
  ];
  final List<Widget> pages = [
    HomePage(),
    Searchpage(),
    ShoppingCartPage(),
    ProfilePage(),
  ];
}
