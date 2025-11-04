// ignore_for_file: overridden_fields

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hos/core/class/crud.dart';
import 'package:hos/core/class/searchclass.dart';
import 'package:hos/core/functions/handlingdata.dart';
import 'package:hos/core/serveces/myservisec.dart';
import 'package:hos/data/datasource/remote/homedata.dart';
import 'package:hos/veiw/userscreen/screen/home/items.dart';

class HomepageController extends SearchMix {
  Myservisec myservisec = Get.put(Myservisec());

  String? username;
  List items = [];
  List categories = [];

  List<List> categoresdinformation = [
    ['الكل', Icons.all_inbox],
    ["لابتوبات", Icons.laptop],
    ["هواتف", Icons.phone_iphone],
    ["كاميرات", Icons.camera],
      ["لابتوبات", Icons.laptop],
   
  ];

  @override
  Homedata homedata = Homedata(Get.find());

  Future<void> getdata() async {
    statusrequest = Statusrequest.loading;
    update();
    var response = await homedata.postdata();
    // print("Response==========================: $response");
    statusrequest = handling(response);
    if (Statusrequest.success == statusrequest) {
      if (response["status"] == "success") {
        categories.addAll(response["categories"]);
        items.addAll(response["items"]);
      } else {
        statusrequest = Statusrequest.failure;
      }
    }
    update();
  }

  void gotoitems(List categories, int selecteditem, String catid) {
    Get.to(
      () => Items(),
      transition: Transition.fadeIn,

      duration: Duration(milliseconds: 500),
      arguments: {
        'categories': categories,
        'selecteditem': selecteditem,
        "catid": catid,
      },
    );
    update();
  }

  //==================================================cart
  PageController? pageController;

  void initPageController() {
    pageController = PageController(viewportFraction: 0.68);
  }

  @override
  void onClose() {
    pageController?.dispose();
    super.onClose();
  }

  //=======================================================cart
  @override
  void onInit() {
    getdata();
    username = myservisec.sharedPreferences.getString("username");
    super.onInit();
  }
}
