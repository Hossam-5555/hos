import 'package:flutter/widgets.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/instance_manager.dart';
import 'package:hos/core/serveces/myservisec.dart';
import 'package:hos/veiw/userscreen/screen/auth/Auth.dart';

class OnboardingControler extends GetxController {
  Myservisec myservisec = Get.find();
  void next() {
    myservisec.sharedPreferences.setString('step', "1");
    Get.offAll(
      () => AuthPage(),
      transition: Transition.fadeIn,
      curve: Curves.easeInOut,
      duration: const Duration(milliseconds: 900),
    );
  }

  @override
  void onInit() {
    super.onInit();
  }
}
