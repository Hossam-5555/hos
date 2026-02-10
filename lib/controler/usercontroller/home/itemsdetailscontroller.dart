import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hos/core/class/crud.dart';
import 'package:hos/core/functions/handlingdata.dart';
import 'package:hos/core/serveces/myservisec.dart';
import 'package:hos/data/datasource/userdata/cartdata.dart';
import 'package:hos/data/model/itemsmodel.dart';

// ignore: camel_case_types
class Itemdetailscontroller extends GetxController {
  late Itemsmodel itemsmodel;
  Cartdata cartdata = Cartdata(Get.find());
  Myservisec myservisec = Get.find();
  //
  bool isadded = false;
  //
   Future<void> addtocart(String itemid, int count) async {
    try {
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
          print("Hossam is the cest========================");
        Get.snackbar(
              "تم الاضافة",
              "تم اضافة المنتج الى السلة",
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.green,
              colorText: Colors.white,
            );
          statusrequest = Statusrequest.failure;
        }
      }
      update();
    } catch (e) {
      if (kDebugMode) {
        print("error in add to cart $e");
      }
    }
  }

  bool isExpanded = false;

  void toggleDescription() {
    isExpanded = !isExpanded;
    update();
  }

  // ui ============================
  int itemcount = 0;

  void add() {
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
