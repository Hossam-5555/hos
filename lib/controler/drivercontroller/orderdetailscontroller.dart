
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hos/core/class/crud.dart';
import 'package:hos/core/functions/handlingdata.dart';
import 'package:hos/data/datasource/userdata/orderdata.dart';
import 'package:hos/data/model/cartmodel.dart';
import 'package:hos/data/model/ordersmodel.dart';

class DriverOrderDetailesController extends GetxController {
  OrderModel? order;

  Orderdata orderdata = Get.put(Orderdata(Get.find()));
  Statusrequest statusrequest = Statusrequest.none;
  List<cartmodel> data = [];

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

  Future<void> driverorderdetails() async {
    statusrequest = Statusrequest.loading;
    update();
    var response = await orderdata.orderdetailsdata(order!.ordersId!);
    statusrequest = handling(response);
    if (Statusrequest.success == statusrequest) {
      if (response['status'] == 'success') {
        List orderdata = response["data"];
        data.addAll(orderdata.map((e) => cartmodel.fromJson(e)));
      } else {
        statusrequest = Statusrequest.failure;
      }
    }
    update();
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

    driverorderdetails();
    super.onInit();
  }
}
