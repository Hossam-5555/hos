import 'package:get/get.dart';
import 'package:hos/core/class/crud.dart';
import 'package:hos/core/functions/handlingdata.dart';
import 'package:hos/core/serveces/myservisec.dart';
import 'package:hos/data/datasource/remote/orderdata.dart';
import 'package:hos/data/model/itemsmodel.dart';
import 'package:hos/data/model/ordersmodel.dart';

class Ordercontroller extends GetxController {
  List<OrderModel> orders = [];
  Statusrequest statusrequest = Statusrequest.none;
  Myservisec myservisec = Get.find();
  Orderdata orderdata = Orderdata(Get.find());

  String printpymentmethod(String val) {
    if (val == "0") {
      return "cash";
    } else if (val == "1") {
      return "pyment card";
    } else {
      return "google payment";
    }
  }

  String printorderstatus(String val) {
    if (val == "0") {
      return "Awaite Aproval";
    } else if (val == "1") {
      return "Order is Being prepared";
    } else if (val == "2") {
      return "on The way";
    } else {
      return "Archive";
    }
  }

  Future<void> viewmyorders() async {
    orders.clear();
    statusrequest = Statusrequest.loading;
    update();
    var response = await orderdata.order(
      myservisec.sharedPreferences.getString("id")!,
    );
    statusrequest = handling(response);
    if (Statusrequest.success == statusrequest) {
      if (response['status'] == 'success') {
        List data = response["data"];
        orders.addAll(data.map((e) => OrderModel.fromJson(e)));
      } else {
        statusrequest = Statusrequest.failure;
      }
    }
    update();
  }

  @override
  void onInit() {
    viewmyorders();
    super.onInit();
  }
}
