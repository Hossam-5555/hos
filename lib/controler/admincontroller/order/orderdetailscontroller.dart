import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hos/controler/admincontroller/order/pindingcontroller.dart';
import 'package:hos/core/functions/handlingdata.dart';
import 'package:hos/core/functions/snackbar.dart';
import 'package:hos/core/serveces/myservisec.dart';
import 'package:hos/data/datasource/admindata/orderdata.dart';
import 'package:hos/data/model/ordersmodel.dart';

import '../../../core/class/crud.dart';

class AdminOrderDetailesController extends GetxController {
  OrderModel? order;
  
  // 🔹 1. متغير محلي جديد لحفظ الحالة الحالية وقابل للتعديل
  String currentStatus = 'pending'; 

  Myservisec myservisec = Get.find();
  AdminDataOrder dataOrder = Get.put(AdminDataOrder(Get.find()));
  Color? statusColor;
  String? statusText;
  Statusrequest statusrequest = Statusrequest.none;

  String? get langage => myservisec.sharedPreferences.getString("lang");
  bool get lang => langage == "ar";

  void getcolorandstause(String status) {
    String state = status.toLowerCase();
    if (state == "pending") {
      statusColor = Colors.orange;
      statusText = lang ? "قيد الانتظار" : "Pending";
    } else if (state == "processing") {
      statusColor = Colors.blue;
      statusText = lang ? "قيد التجهيز" : "Processing";
    } else if (state == "shipped") {
      statusColor = const Color.fromARGB(255, 179, 123, 39);
      statusText = lang ? "في الطريق" : "Shipped";
    } else if (state == "delivered") {
      statusColor = const Color.fromARGB(255, 33, 201, 10);
      statusText = lang ? "تم التسليم" : "Delivered";
    } else if (state == "cancelled") {
      statusColor = Colors.red;
      statusText = lang ? "ملغي" : "Cancelled";
    } else {
      statusColor = const Color.fromARGB(200, 226, 226, 226);
      statusText = lang ? "غير معروف" : "Unknown";
    }
  }

  @override
  void onInit() {
    final args = Get.arguments;
    if (args != null && args["order"] != null) {
      order = args["order"];
      // 🔹 2. نأخذ الحالة الابتدائية من الـ Model عند فتح الصفحة
      currentStatus = order!.status; 
      getcolorandstause(currentStatus);
    }
    super.onInit();
  }

  void updateStatus(String s) async {
    statusrequest = Statusrequest.loading;
    update();

    var response = await dataOrder.changestatus(order!.orderId, s);
    statusrequest = handling(response);

    if (Statusrequest.success == statusrequest) {
      if (response['status'] == true) {
        
        // 🔹 3. هنا الحل! بنعدل المتغير المحلي للـ Controller مش الـ Model
        currentStatus = s; 
        getcolorandstause(s); 

        showSnackBar(
          Get.context!,
          lang ? "تم تحديث حالة الطلب بنجاح" : "Status updated",
          Icon(Icons.check_circle_outline, color: statusColor),
        );

        try {
          if (Get.isRegistered<AdminPindingController>()) {
            final pendingCtrl = Get.find<AdminPindingController>();
            pendingCtrl.viewOrders(s); 
          }
        } catch (e) {
          if (kDebugMode) print("Error: $e");
        }
      } else {
        statusrequest = Statusrequest.failure;
      }
    }
    update(); 
  }
}