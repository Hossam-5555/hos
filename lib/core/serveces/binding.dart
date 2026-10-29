import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:hos/controler/usercontroller/auth/auth_controller.dart';
import 'package:hos/controler/usercontroller/checkout&cart/cart_controller.dart';
import 'package:hos/controler/usercontroller/home/itemsdetailscontroller.dart';
import 'package:hos/controler/usercontroller/notificationcontroller.dart';

import 'package:hos/data/services/crud.dart';

class MyBinding extends Bindings {
  @override
  void dependencies() {
 
    Get.lazyPut(() => AuthController(), fenix: true);
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
