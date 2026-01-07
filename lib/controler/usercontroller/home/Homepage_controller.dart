// ignore_for_file: overridden_fields

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hos/core/class/crud.dart';
import 'package:hos/core/class/searchclass.dart';
import 'package:hos/core/functions/handlingdata.dart';
import 'package:hos/core/serveces/myservisec.dart';
import 'package:hos/data/datasource/userdata/homedata.dart';
import 'package:hos/data/model/categoriesmodel.dart';
import 'package:hos/veiw/userscreen/screen/home/items.dart';

class HomepageController extends SearchMix {
  Myservisec myservisec = Get.put(Myservisec());

  String? username;
  List items = [];
  List<categoriesmodel> categories = [];



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
        List categorylist = response["categories"];
        categories.addAll(categorylist.map((e) => categoriesmodel.fromJson(e)));
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
  // داخل HomepageController
  PageController? pageController;

  @override
  void onClose() {
    // تم التعديل هنا: استخدام ?.dispose() لتجنب Null check operator used on a null value
    pageController?.dispose();
    super.onClose();
  }

  //=======================================================cart
  @override
  void onInit() {
    pageController = PageController(
      initialPage: 0,
      viewportFraction:
          0.8, // مهم جداً: هذا الرقم هو ما يظهر جزءاً من الكروت الجانبية
    );
    getdata();
    username = myservisec.sharedPreferences.getString("username");
    super.onInit();
  }
}
