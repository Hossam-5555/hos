import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hos/core/class/crud.dart';
import 'package:hos/core/class/searchclass.dart';
import 'package:hos/core/functions/handlingdata.dart';
import 'package:hos/core/serveces/myservisec.dart';
import 'package:hos/data/datasource/userdata/items.dart';
import 'package:hos/data/model/categoriesmodel.dart';
import 'package:hos/data/model/itemsmodel.dart';

class ItemsControler extends SearchMix {
  List<categoriesmodel> categories = [];
  int? selecteditem;
  late String catid;
  List<Itemsmodel> data = [];
  Statusrequest statusrequest = Statusrequest.none;
  Myservisec myservisec = Get.find();
  itemsdata itemdata = itemsdata(Get.find());

  void changcat(int val, String catigid) {
    selecteditem = val;
    catid = catigid;
    update(); // يحدث الواجهة مباشرة
    getitems(catid); // بعدين يجيب البيانات
  }

  void initdata() {
    catid = Get.arguments['catid'];
    categories = Get.arguments["categories"];
    selecteditem = Get.arguments['selecteditem'] ?? 0; // قيمة افتراضية
    getitems(catid);
  }

  Future<void> getitems(String catid) async {
    data.clear();
    statusrequest = Statusrequest.loading;
    update();
    var response = await itemdata.postdata(
      catid,
      myservisec.sharedPreferences.getString("id")!,
    );
    statusrequest = handling(response);
    if (Statusrequest.success == statusrequest) {
      if (response['status'] == 'success') {
        List itemlist = response["data"];
        data.addAll(itemlist.map((e) => Itemsmodel.fromJson(e)));
      } else {
        statusrequest = Statusrequest.failure;
      }
    }
    update();
  }

  @override
  void onInit() {
    search = TextEditingController();
    initdata();
    super.onInit();
  }
}
