import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:hos/controler/usercontroller/auth/sign_upcontroller.dart';
import 'package:hos/core/class/crud.dart';

class MyBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => Signupcontroller(), fenix: true);
    Get.put(Crud());
  }
}
