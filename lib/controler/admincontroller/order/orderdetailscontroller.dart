import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hos/core/serveces/myservisec.dart';

import 'package:hos/data/model/ordersmodel.dart';
import 'package:hos/veiw/adminscreen/Home/orders/trackingorder.dart';

class AdminOrderDetailesController extends GetxController {
  OrderModel? order;
  Myservisec myservisec = Get.find();

  Color? statusColor;
  String? statusText;

  String? get langage => myservisec.sharedPreferences.getString("lang");
  bool get lang => langage == "ar" ? true : false;

  List<String> get orderstatus => lang
      ? [
          "الكل",
          "قيد الانتظار",
          "قيد التجهيز",
          "في الطريق",
          "تم التسليم",
          "ملغي",
        ]
      : ["All", "Pending", "Processing", "Shipped", "Delivered", "Cancelled"];

  void getcolorandstause(String status) {
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

  // Orderdata orderdatadetails = Get.put(Orderdata(Get.find()));
  @override
  // List<cartmodel> data = [];
  // Future<void> adminorder() async {
  //   statusrequest = Statusrequest.loading;
  //   update();
  //   var response = await orderdatadetails.orderdetailsdata(order!.orderId);
  //   statusrequest = handling(response);
  //   if (Statusrequest.success == statusrequest) {
  //     if (response['status'] == 'success') {
  //       List orderdata = response["data"];
  //       data.addAll(orderdata.map((e) => cartmodel.fromJson(e)));
  //     } else {
  //       statusrequest = Statusrequest.failure;
  //     }
  //   }
  //   update();
  // }
  void gototrackingorder() {
    Get.to(() => Trackinscreenadmin(), arguments: {"order": order});
  }

  String? orderId;
  @override
  void onInit() {
    // تأكد إن Get.arguments مش null

    final args = Get.arguments;
    if (args != null && args["order"] != null) {
      order = args["order"];
      print("=======================${order!.createdAt}");
      print("-------------------------------------${DateTime.now()}");
    } else {
      if (kDebugMode) {
        print("⚠️ لم يتم استلام أي بيانات من الصفحة السابقة");
      }
    }

    // adminorder();

    // if (orderId != null) {
    //   fetchOrderDetails(orderId!); // دالة بتجيب بيانات الأوردر من الـ API بتاع لارافيل
    // }
    super.onInit();
  }
}
