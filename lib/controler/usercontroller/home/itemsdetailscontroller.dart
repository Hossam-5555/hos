import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hos/core/class/crud.dart';
import 'package:hos/core/functions/handlingdata.dart';
import 'package:hos/core/serveces/myservisec.dart';
import 'package:hos/data/datasource/remote/userdata/cartdata.dart';
import 'package:hos/data/model/itemsmodel.dart';

// ignore: camel_case_types
class Itemdetailscontroller extends GetxController {
  late Itemsmodel itemsmodel;
  Cartdata cartdata = Cartdata(Get.find());
  Myservisec myservisec = Get.find();

  addtocart(String itemid, int count) async {
    var statusrequest = Statusrequest.loading;
    update();
    var response = await cartdata.addcartdata(
      myservisec.sharedPreferences.getString("id")!,
      itemid,
      count,
    );
    statusrequest = handling(response);
    if (Statusrequest.success == statusrequest) {
      if (response["status"] == "success") {
        Get.snackbar(
          "إشعار",
          "تم إضافة المنتج للسلة ✅",
          duration: Duration(seconds: 1),
          backgroundColor: Colors.white,
          colorText: Colors.black,
        );
      } else {
        statusrequest = Statusrequest.failure;
      }
    }
  }

  // ui ============================
  int itemcount = 0;

  add() {
    itemcount++;
    update();
  }

  void remove() {
    if (itemcount > 0) {
      itemcount--;
    }
    update();
  }

  // ui=================================
  @override
  void onInit() {
    itemsmodel = Get.arguments['itemsmodel'];
    super.onInit();
  }
}
