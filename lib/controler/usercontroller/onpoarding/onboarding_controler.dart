import 'package:flutter/widgets.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/instance_manager.dart';
import 'package:hos/core/serveces/myservisec.dart';
import 'package:hos/veiw/userscreen/screen/auth/login.dart';
import 'package:hos/veiw/wedget/onpording/silder.dart';

class OnboardingControler extends GetxController {





  
  Myservisec myservisec = Get.find();
  int curentpage = 0;
  late PageController pageController;
  void next() {
    curentpage++;
    if (curentpage > onBoarding.length - 1) {
      myservisec.sharedPreferences.setString('step', "1");
      Get.offAll(
        () => Login(),
        transition: Transition.fadeIn,
        duration: const Duration(milliseconds: 900),
      );
    } else {
      pageController.animateToPage(
        curentpage,
        duration: Duration(milliseconds: 900),
        curve: Curves.easeInOut,
      );
    }
  }

  void onpagechange(int index) {
    curentpage = index;
    update();
  }

  @override
  void onInit() {
    pageController = PageController();
    super.onInit();
  }
}
