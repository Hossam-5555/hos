
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hos/core/class/crud.dart';
import 'package:hos/core/functions/handlingdata.dart';
import 'package:hos/core/serveces/myservisec.dart';
import 'package:hos/data/datasource/admindata/orderdata.dart';
import 'package:hos/data/model/ordersmodel.dart';
import 'package:hos/veiw/adminscreen/Home/orders/admin_orderdetails.dart';

class AdminPindingController extends GetxController {
  List<OrderModel> orderspending = [];
  List<String> orderstatus = [
    "Pending",
    "Processing",
    "Shipped",
    "Delivered",
    "Cancelled",
  ];
  // قائمة الطلبات المصفاة بناءً على القسم المختار
  List<OrderModel> get filteredOrders {
    if (selectedStatus == 0) {
      return orderspending.where((order) => order.status == "pending").toList();
    } else if (selectedStatus == 1) {
      return orderspending
          .where((order) => order.status == "processing")
          .toList(); // تأكد من الاسم في الداتابيز
    } else if (selectedStatus == 2) {
      return orderspending.where((order) => order.status == "shipped").toList();
    } else if (selectedStatus == 3) {
      return orderspending
          .where((order) => order.status == "delivered")
          .toList();
    } else if (selectedStatus == 4) {
      return orderspending
          .where((order) => order.status == "cancelled")
          .toList();
    } else {
      return orderspending; // في حالة عدم وجود فلترة، نعيد القائمة كاملة
    }
  }

  int selectedStatus = 0; // القسم المختار حالياً
  Myservisec myservisec = Get.find();
  AdminDataOrder orderdata = Get.put(AdminDataOrder(Get.find()));
  void changeSelectedStatus(int index) {
    selectedStatus = index;
    update(); // لتحديث الواجهة
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

  String translatePayment(String val) {
    switch (val) {
      case "credit":
        return " credit ";
      case "cash":
        return "Cash";
      case "mobil":
        return " mobileWallet";
      default:
        return "غير معروف";
    }
  }

  Statusrequest statusrequest = Statusrequest.none;
  Future<void> vieworderspending() async {
    orderspending.clear();
    statusrequest = Statusrequest.loading;
    update();
    var response = await orderdata.pendingdata();
    statusrequest = handling(response);
    if (Statusrequest.success == statusrequest) {
      if (response['status'] == true) {
        List data = response["data"];
        orderspending.addAll(data.map((e) => OrderModel.fromJson(e)));
      } else {
        statusrequest = Statusrequest.failure;
      }
    }
    update();
  }

  Future<void> approvependingorder(String userid, String orderid) async {
    statusrequest = Statusrequest.loading;
    update();
    var response = await orderdata.approveorder(orderid, userid);
    statusrequest = handling(response);
    if (Statusrequest.success == statusrequest) {
      if (response['status'] == true) {
        vieworderspending();
        Get.snackbar("succee ", " تم قبول الطلب");
      } else {
        Get.snackbar("حدث خطا ", " الرجاء  اعاده المحاوله  ");

        vieworderspending();
      }
    }
    update();
  }

  void gotodetails(OrderModel order) {
    Get.to(
      () => AdminOrderdetails(),
      arguments: {"order": order},
      duration: Duration(milliseconds: 400),
      transition: Transition.fadeIn,
    );
  }

  @override
  void onInit() {
    vieworderspending();
    super.onInit();
  }
}
