
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:hos/controler/drivercontroller/drivercontroller.dart';
import 'package:hos/core/class/crud.dart';
import 'package:hos/core/functions/handlingdata.dart';
import 'package:hos/data/datasource/userdata/orderdata.dart';
import 'package:hos/data/model/cartmodel.dart';
import 'package:hos/data/model/ordersmodel.dart';

class DriverOrderDetailesController extends DriverViewOrderController {
  OrderModel? order;

  Orderdata orderdata = Get.put(Orderdata(Get.find()));
  Statusrequest statusrequestorderdetails = Statusrequest.none;
  List<cartmodel> data = [];



  // Future<void> driverorderdetails() async {
  //   statusrequestorderdetails = Statusrequest.loading;
  //   update();
  //   var response = await orderdata.orderdetailsdata(order!.orderId!);
  //   statusrequestorderdetails = handling(response);
  //   if (Statusrequest.success == statusrequestorderdetails) {
  //     if (response['status'] == 'success') {
  //       List orderdata = response["data"];
  //       data.addAll(orderdata.map((e) => cartmodel.fromJson(e)));
  //     } else {
  //       statusrequestorderdetails = Statusrequest.failure;
  //     }
  //   }
  //   update();
  // }

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

    // driverorderdetails();
    super.onInit();
  }
}
