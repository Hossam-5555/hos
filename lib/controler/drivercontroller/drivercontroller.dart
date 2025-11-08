import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hos/core/class/crud.dart';
import 'package:hos/core/functions/handlingdata.dart';
import 'package:hos/core/serveces/myservisec.dart';
import 'package:hos/data/datasource/remote/driverdata/driverorderdata.dart';
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
