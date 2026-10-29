import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hos/controler/usercontroller/checkout&cart/paymentcontroller.dart';
import 'package:hos/data/services/crud.dart';
import 'package:hos/core/serveces/myservisec.dart';
import 'package:hos/data/datasource/userdata/checkoutdata.dart';

import 'package:hos/data/model/ordersmodel.dart';


class Orderdetailescontroller extends GetxController {
  OrderModel? order;
  Statusrequest statusrequest = Statusrequest.none;
  Myservisec myservisec = Get.find();
  int? get userid => myservisec.sharedPreferences.getInt("id");
  Checkoutdata checkoutdata = Checkoutdata(Get.find());
PaymentController paymentController = Get.put(PaymentController());
  Color? statusColor;
  String? statusText;
  String? get langage => myservisec.sharedPreferences.getString("lang");
  bool get lang => langage == "ar" ? true : false;
  // ignore: non_constant_identifier_names
  void Getcolorandstause(String status) {
    if (status == "pending") {
      statusColor = Colors.orange;
      statusText = lang ? "قيد الانتظار" : "Pending";
    } else if (status == "processing") {
      statusColor = Colors.blue;
      statusText = lang ? "قيد التجهيز" : "Processing";
    } else if (status == "shipped") {
      statusColor = const Color.fromARGB(255, 179, 123, 39);
      statusText = lang ? "في الطريق" : "Shipped";
    } else if (status == "delivered") {
      statusColor = const Color.fromARGB(255, 33, 201, 10);
      statusText = lang ? "تم التسليم" : "Delivered";
    } else if (status == "cancelled") {
      statusColor = Colors.red;
      statusText = lang ? "ملغي" : "Cancelled";
    } else {
      statusColor = const Color.fromARGB(200, 226, 226, 226);
      statusText = lang ? "غير معروف" : "Unknown";
    }
  }

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
