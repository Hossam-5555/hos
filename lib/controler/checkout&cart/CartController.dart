import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hos/core/class/crud.dart';
import 'package:hos/core/functions/handlingdata.dart';
import 'package:hos/core/serveces/myservisec.dart';
import 'package:hos/data/datasource/remote/cartdata.dart';
import 'package:hos/data/model/Couponemodel.dart';
import 'package:hos/data/model/cartmodel.dart';

class CartController extends GetxController {
  ///////////////======================ملكش دعوه
  Cartdata cartdata = Cartdata(Get.find());
  Statusrequest statusrequest = Statusrequest.none;
  Myservisec myservisec = Get.put(Myservisec());
  cartmodel cart = cartmodel();
  /////===========================

  ///////////////////ملكش دعوه بدول  //view data
  List<cartmodel> data = [];
  int totalcount = 0;
  double totalprice = 0.0;
  ///////////////////////

  /// ================== زيادة العدد
  void increment(String itemId) async {
    await addtocart(itemId, 1);
    await view(); // ✅ يحدث الداتا من السيرفر بعد الزيادة
    update();
  }

  /// ================== نقصان العدد
  void decrement(int itemid) async {
    // نلاقي المنتج
    final item = data.firstWhere(
      (e) => e.itemsId == itemid,
      orElse: () => cartmodel(),
    );

    int currentCount = item.cartCount ?? 0;

    if (currentCount >= 1) {
      // ينقص العدد (الباك إند هيخصم واحد)
      await delete(itemid.toString());
    }

    await view();
    update();
  }

  addtocart(String itemid, int count) async {
    statusrequest = Statusrequest.loading;
    update();
    var response = await cartdata.addcartdata(
      myservisec.sharedPreferences.getString("id")!,
      itemid,
      count,
    );
    statusrequest = handling(response);
    if (Statusrequest.success == statusrequest) {
      if (response["status"] == "success") {
        Get.rawSnackbar(
          duration: Duration(milliseconds: 800),
          margin: EdgeInsets.all(16),
          snackStyle: SnackStyle.FLOATING,
          borderRadius: 16,
          title: "إشعار",
          messageText: const Text("تم إضافة المنتج للسلة ✅"),
        );
      } else {
        statusrequest = Statusrequest.failure;
      }
    }
  }

  delete(String itemid) async {
    statusrequest = Statusrequest.loading;
    update();
    var response = await cartdata.deletcartdata(
      myservisec.sharedPreferences.getString("id")!,
      itemid,
    );
    statusrequest = handling(response);
    if (Statusrequest.success == statusrequest) {
      if (response["status"] == "success") {
        Get.rawSnackbar(
          duration: Duration(milliseconds: 800),

          margin: EdgeInsets.all(12),
          borderRadius: 16,
          title: "إشعار",
          messageText: const Text("تمت ازاله العنصر  ✅"),
        );
      } else {
        statusrequest = Statusrequest.failure;
      }
    }
  }

  getcountitem(String itemid) async {
    statusrequest = Statusrequest.loading;
    update();
    var response = await cartdata.getcount(
      myservisec.sharedPreferences.getString("id")!,
      itemid,
    );
    statusrequest = handling(response);
    if (Statusrequest.success == statusrequest) {
      if (response["status"] == "success") {
        int countitem = 0;
        countitem = int.parse(response['data']);
        return countitem;
      } else {
        statusrequest = Statusrequest.failure;
      }
    }
  }

view() async {
  statusrequest = Statusrequest.loading;
  update();

  var response = await cartdata.viewcart(
    myservisec.sharedPreferences.getString("id")!,
  );

  statusrequest = handling(response);

  if (Statusrequest.success == statusrequest) {
    if (response["status"] == "success") {
      data.clear(); // ✅ تنظيف القديم
      List datarespons = response["datacart"];
      data.addAll(datarespons.map((e) => cartmodel.fromJson(e)));

      Map dataresponsecountprice = response["countprice"];

      totalcount = int.tryParse(dataresponsecountprice["totalcount"]?.toString() ?? "0") ?? 0;
      totalprice = double.tryParse(dataresponsecountprice["totalprice"]?.toString() ?? "0") ?? 0.0;

    } else {
      statusrequest = Statusrequest.failure;
    }
  }

  update();
}


  //coubone========================================
  TextEditingController? coubonecontroller;
  CouponeModel? couponeModel;
  double couponediscount = 0;
  String? couponename;
  chechcoupone() async {
    statusrequest = Statusrequest.loading;
    update();
    var response = await cartdata.couponedata(coubonecontroller!.text);
    print(response);
    statusrequest = handling(response);
    if (Statusrequest.success == statusrequest) {
      if (response["status"] == "success") {
        Map<String, dynamic> dataCoupone = response['data'];
        couponeModel = CouponeModel.fromJson(dataCoupone);
        couponediscount = double.parse(couponeModel!.couponDiscount!);
        couponename = couponeModel!.couponName;
      } else {
        couponediscount = 0;
        couponename = null;
      }
    }
    update();
  }

  gettotalprice() {
    return (totalprice - totalprice * couponediscount / 100);
  }

  bool value = false;
  onchangcheckbox(val) {
    value = val ?? false; // يتغير مع الضغط
    update();
  }
  //coubone========================================

  @override
  void onInit() {
    coubonecontroller = TextEditingController();
    view();
    super.onInit();
  }

  @override
  void onClose() {
    coubonecontroller!.dispose();
    super.onClose();
  }
}
