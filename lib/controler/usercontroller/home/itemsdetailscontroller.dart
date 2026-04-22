import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:hos/core/serveces/myservisec.dart';
import 'package:hos/data/datasource/userdata/cartdata.dart';
import 'package:hos/data/model/itemsmodel.dart';

// ignore: camel_case_types
class Itemdetailscontroller extends GetxController {
  late ItemsModel itemsmodel;
  Cartdata cartdata = Cartdata(Get.find());
  Myservisec myservisec = Get.find();
  //
  bool isadded = false;
  //
  PageController controller = PageController();
  int curentpage = 0;
  void onimagechange(int val) {
    curentpage = val;
    update();
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
