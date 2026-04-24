import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:hos/controler/usercontroller/auth/sign_upcontroller.dart';
import 'package:hos/controler/usercontroller/checkout&cart/CartController.dart';
import 'package:hos/controler/usercontroller/home/itemsdetailscontroller.dart';
import 'package:hos/controler/usercontroller/notificationcontroller.dart';

import 'package:hos/core/class/crud.dart';

class MyBinding extends Bindings {
  @override
  void dependencies() {
 
    Get.lazyPut(() => Signupcontroller(), fenix: true);
    Get.put(Crud());
    Get.lazyPut(() => CartController(), fenix: true);
    Get.put(Notificationcontroller());
  }
}

class ItemDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(Itemdetailscontroller());
  }
}
