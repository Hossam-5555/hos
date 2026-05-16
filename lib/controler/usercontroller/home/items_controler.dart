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
  List<CategoriesModel> categories = [];
  int? selecteditem;
  int? selectedfilter;
  late String catid;
  List<ItemsModel> data = [];
  @override
  // ignore: overridden_fields
  Statusrequest statusrequest = Statusrequest.none;
  Myservisec myservisec1 = Get.find();
  itemsdata itemdata = itemsdata(Get.find());

  void changcat(int val, String catigid) {
    selecteditem = val;
    catid = catigid;
    update(); // يحدث الواجهة مباشرة
    getitems(catid); // بعدين يجيب البيانات
  }

  void filtesortedby(int val) {
    selectedfilter = val;
    update(); // يحدث الواجهة مباشرة
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
      myservisec1.sharedPreferences.getInt("id")!,
    );
    statusrequest = handling(response);
    if (Statusrequest.success == statusrequest) {
      if (response['status'] == true) {
        List itemlist = response["data"];
        data.addAll(itemlist.map((e) => ItemsModel.fromJson(e)));
        if (data.isEmpty) {
          statusrequest = Statusrequest.nodata;
        }
      } else {
        statusrequest = Statusrequest.failure;
      }
    }
    update();
  }

  List<String> filterdata = [
    "On Sale",
    "Featured",
    "Date: Latest",
    "Date: oldest",
    "Price: Low to High",
    "Price: High to Low",
  ];

  RxInt price = 50.obs;

  @override
  void onInit() {
    search = TextEditingController();
    initdata();
    super.onInit();
  }
}
