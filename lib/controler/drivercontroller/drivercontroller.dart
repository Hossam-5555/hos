import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hos/core/class/crud.dart';
import 'package:hos/core/functions/handlingdata.dart';
import 'package:hos/core/serveces/myservisec.dart';
import 'package:hos/data/datasource/driverdata/driverorderdata.dart';
import 'package:hos/data/model/ordersmodel.dart';

class driverviewordercontroller extends GetxController {
  List<OrderModel> orderspending = [];

  Statusrequest statusrequest = Statusrequest.none;

  Myservisec myservisec = Get.find();
  Driverorderdata orderdata = Driverorderdata(Get.find());

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
      case "0":
        return "الدفع عند الاستلام";
      case "1":
        return "بطاقة بنكية";
      default:
        return "دفع Google";
    }
  }

  Future<void> vieworderspending() async {
    orderspending.clear();
    statusrequest = Statusrequest.loading;
    update();
    var response = await orderdata.pendingdata(
      myservisec.sharedPreferences.getString("id")!,
    );
    statusrequest = handling(response);
    if (Statusrequest.success == statusrequest) {
      if (response['status'] == 'success') {
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
    var response = await orderdata.approveorder(
      orderid,
      userid,
      myservisec.sharedPreferences.getString("id")!,
    );
    statusrequest = handling(response);
    if (Statusrequest.success == statusrequest) {
      if (response['status'] == 'success') {
        vieworderspending();
        Get.snackbar("succee ", " تم قبول الطلب");
      } else {
        Get.snackbar("حدث خطا ", " الرجاء  اعاده المحاوله  ");

        vieworderspending();
      }
    }
    update();
  }

  @override
  void onInit() {
    vieworderspending();
    super.onInit();
  }
}
