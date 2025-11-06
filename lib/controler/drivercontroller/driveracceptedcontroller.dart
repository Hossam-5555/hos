import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hos/core/class/crud.dart';
import 'package:hos/core/functions/handlingdata.dart';
import 'package:hos/core/serveces/myservisec.dart';
import 'package:hos/data/datasource/remote/driverdata/driverorderdata.dart';
import 'package:hos/data/model/ordersmodel.dart';

class Driveracceptedcontroller extends GetxController {
  List<OrderModel> ordersaccepted = [];

  Statusrequest statusrequest = Statusrequest.none;

  Myservisec myservisec = Get.find();
  Driverorderdata orderdata = Driverorderdata(Get.find());

  int selectedRating = 0;

  void changeRatingColor(int i) {
    selectedRating = i + 1; // خزن رقم النجمة اللي المستخدم ضغطها
    update(); // يحدث الواجهة
  }

  Color getStatusColor(String status) {
    switch (status) {
      case "0":
        return Colors.orange;
      case "1":
        return Colors.blue;
      case "2":
        return Colors.purple;
      case "3":
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  String translateStatus(String val) {
    switch (val) {
      case "0":
        return "في انتظار الموافقة";
      case "1":
        return "يتم تجهيز الطلب";
      case "2":
        return "في الطريق";
      case "3":
        return "تم التسليم";
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
    var response = await orderdata.acceptedorderdata(
      myservisec.sharedPreferences.getString("id")!,
    );
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

  @override
  void onInit() {
    viewordersaccepted();
    super.onInit();
  }
}
