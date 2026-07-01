import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hos/core/class/crud.dart';
import 'package:hos/core/functions/handlingdata.dart';
import 'package:hos/core/functions/snackbar.dart';
import 'package:hos/core/serveces/myservisec.dart';
import 'package:hos/data/datasource/userdata/orderdata.dart';
import 'package:hos/data/model/ordersmodel.dart';

class Ordercontroller extends GetxController {
  List<OrderModel> orders = [];

  RxInt get orderscount => orders.length.obs;
  Statusrequest statusrequest = Statusrequest.none;
  Myservisec myservisec = Get.find();
  Orderdata orderdata = Orderdata(Get.find());
  TextEditingController? comment;
  int? get userid => myservisec.sharedPreferences.getInt("id");
  int selectedRating = 0;
  void changeRatingColor(int i) {
    selectedRating = i + 1; // خزن رقم النجمة اللي المستخدم ضغطها
    update(); // يحدث الواجهة
  }

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

  // Future<void> viewrating(String id, String rating) async {
  //   orders.clear();
  //   statusrequest = Statusrequest.loading;
  //   update();
  //   var response = await orderdata.ratingdata(id, rating, comment!.text);
  //   statusrequest = handling(response);
  //   if (Statusrequest.success == statusrequest) {
  //     if (response['status'] == 'success') {
  //       viewmyorders();
  //       Get.back();
  //     } else {
  //       statusrequest = Statusrequest.failure;
  //     }
  //   }
  //   update();
  // }

  Future<void> viewmyorders() async {
    orders.clear();
    statusrequest = Statusrequest.loading;
    update();
    var response = await orderdata.order();
    statusrequest = handling(response);
    if (Statusrequest.success == statusrequest) {
      if (response['status'] == true) {
        List data = response["data"]["data"];
        orders.addAll(data.map((e) => OrderModel.fromJson(e)));
        pragma("orders length: ${orders}");
      } else {
        statusrequest = Statusrequest.failure;
      }
    }
    update();
  }

  //هي الي هتخلي الاوردر ملغي
  Future<void> deleteorders(int orderid) async {
    statusrequest = Statusrequest.loading;
    update();

    try {
      var response = await orderdata.deletedata(orderid);
      statusrequest = handling(response);

      if (Statusrequest.success == statusrequest) {
        if (response['status'] == true) {
          orders.removeWhere((e) => e.orderId == orderid);
          // 2. إظهار الرسالة
          showSnackBar(
            Get.context!,
            "تم إلغاء الطلب بنجاح",
            Icon(Icons.check_circle),
          );
          viewmyorders();
          Get.back();
          // 3. العودة للخلف أولاً
        }
      }
    } catch (e) {
      statusrequest = Statusrequest.serverfailure;
    } finally {
      // التحقق من أن الكنترولر لا يزال "حي" قبل التحديث
      if (Get.isRegistered<Ordercontroller>()) {
        update();
      }
    }
  }

  @override
  void onInit() {
    comment = TextEditingController();
    viewmyorders();
    super.onInit();
  }
}
