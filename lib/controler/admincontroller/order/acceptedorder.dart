import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hos/core/class/crud.dart';
import 'package:hos/core/functions/handlingdata.dart';
import 'package:hos/core/serveces/myservisec.dart';
import 'package:hos/data/datasource/admindata/orderdata.dart';
import 'package:hos/data/model/ordersmodel.dart';
import 'package:hos/veiw/adminscreen/Home/orders/admin_orderdetails.dart';

class Acceptedordercontroller extends GetxController {
  List<OrderModel> ordersaccepted = [];

  Statusrequest statusrequest = Statusrequest.none;

  Myservisec myservisec = Get.find();
  admindataorder orderdata = admindataorder(Get.find());

  int selectedRating = 0;

  void changeRatingColor(int i) {
    selectedRating = i + 1; // خزن رقم النجمة اللي المستخدم ضغطها
    update(); // يحدث الواجهة
  }

  Color? statusColor;
  String? statusText;
  // ignore: non_constant_identifier_names
  void Getcolorandstause(String status) {
    if (status == "0") {
      statusColor = Colors.orange;
      statusText = "قيد الانتظار";
    } else if (status == "1") {
      statusColor = Colors.blue;
      statusText = "تم التأكيد";
    } else if (status == "2") {
      statusColor = const Color.fromARGB(255, 180, 65, 30);
      statusText = " يجهز";
    } else if (status == "3") {
      statusColor = const Color.fromARGB(255, 179, 123, 39);
      statusText = "في الطريق";
    } else if (status == "4") {
      statusColor = const Color.fromARGB(255, 33, 201, 10);
      statusText = "مكتمل";
    } else {
      statusColor = const Color.fromARGB(200, 226, 226, 226);
      statusText = "أرشيف";
    }
  }

  String translatePayment(String val) {
    switch (val) {
      case "PaymentMethod.credit":
        return " credit ";
      case "PaymentMethod.cod":
        return "Cash ";
      case "PaymentMethod.mobileWallet":
        return " mobileWallet";
      default:
        return "غير معروف";
    }
  }

  Future<void> viewordersaccepted() async {
    ordersaccepted.clear();
    statusrequest = Statusrequest.loading;
    update();
    var response = await orderdata.acceptedorderdata();
    statusrequest = handling(response);
    if (Statusrequest.success == statusrequest) {
      if (response['status'] == 'success') {
        List data = response["data"];
        ordersaccepted.addAll(data.map((e) => OrderModel.fromJson(e)));
      } else {
        statusrequest = Statusrequest.failure;
      }
    }
    update();
  }

  Future<void> orderdone(String orderid, String userid) async {
    statusrequest = Statusrequest.loading;
    update();
    var response = await orderdata.orderhasdone(orderid, userid);
    statusrequest = handling(response);
    if (Statusrequest.success == statusrequest) {
      if (response['status'] == 'success') {
        viewordersaccepted();
        Get.snackbar("نجاح ", "تم تجهيز  الطلب بنجاح ");
      } else {
        statusrequest = Statusrequest.failure;
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
    viewordersaccepted();
    super.onInit();
  }
}
