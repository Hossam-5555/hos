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

  Color getStatusColor(String status) {
    switch (status) {
      case "0":
        return const Color.fromARGB(255, 222, 40, 26);
      case "1":
        return Colors.blue;
      case "2":
        return Colors.purple;
      case "3":
        return const Color.fromARGB(255, 171, 156, 22);
      case "4":
        return const Color.fromARGB(255, 44, 183, 23);
      default:
        return Colors.grey;
    }
  }

  String translateStatus(String val) {
    switch (val) {
      case "0":
        return "في انتظار الموافقة";
      case "1":
        return "تمت الموافقه   ";
      case "2":
        return " يجهز";
      case "3":
        return "في الطريق ";
      case "4":
        return "تم  التسليم";
      default:
        return "غير معروف";
    }
  }

  String translatePayment(String val) {
    switch (val) {
      case "0":
        return "الدفع عند الاستلام";
      case "1":
        return "بطاقة بنكية";
      default:
        return "دفع Google";
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

  gotodetails(OrderModel order) {
    Get.to(
      () => AdminOrderdetails(),
      arguments: {"order": order},
      transition: Transition.fadeIn,
    );
  }

  @override
  void onInit() {
    viewordersaccepted();
    super.onInit();
  }
}
