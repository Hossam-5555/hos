import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:hos/controler/usercontroller/profile/order/ordercontroller.dart';

import 'package:hos/data/model/ordersmodel.dart';

class Orderdetailescontroller extends Ordercontroller {
  OrderModel? order;

  @override
  void onInit() {
    // تأكد إن Get.arguments مش null
    final args = Get.arguments;
    if (args != null && args["order"] != null) {
      order = args["order"];
    } else {
      if (kDebugMode) {
        print("⚠️ لم يتم استلام أي بيانات من الصفحة السابقة");
      }
    }
    // getordersdetailsdata();
    super.onInit();
  }
}
