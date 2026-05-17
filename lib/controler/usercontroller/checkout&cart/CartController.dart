import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hos/core/class/crud.dart';
import 'package:hos/core/functions/handlingdata.dart';
import 'package:hos/core/serveces/myservisec.dart';
import 'package:hos/data/datasource/userdata/cartdata.dart';
import 'package:hos/data/model/Couponemodel.dart';
import 'package:hos/data/model/cartmodel.dart';
import 'package:hos/veiw/userscreen/screen/cartandcheckout/checkout.dart';

class CartController extends GetxController {
  ///////////////======================ملكش دعوه
  Cartdata cartdata = Cartdata(Get.find());
  Statusrequest statusrequest = Statusrequest.loading;
  Myservisec myservisec = Get.put(Myservisec());
  CartModel cart = CartModel();
  /////===========================

  int? get userid => myservisec.sharedPreferences.getInt("id");

  double gettotalprice() {
    return (totalprice - totalprice * couponediscount / 100);
  }

  double get totalpriceafterdiscount => gettotalprice();

  late AnimationController controllerAnimation;
  late Animation<double> priceAnimation;

  var coupone = true.obs;
  void havecoupone(bool value) async {
    coupone.value = value;
    final prefs = myservisec.sharedPreferences;
    await prefs.setBool('cop', value);
  }

  ///////////////////ملكش دعوه بدول  //view data
  List<CartModel> data = [];
  RxInt get countitem => data.length.obs;
  int totalcount = 0;
  double totalprice = 0.0;
  ///////////////////////

  /// ================== زيادة العدد
  void increment(int itemId) async {
    await addtocart(itemId, 1);
    await view(); // ✅ يحدث الداتا من السيرفر بعد الزيادة
    update();
  }

  /// ================== نقصان العدد
  void decrement(int itemid) async {
    // نلاقي المنتج
    final item = data.firstWhere(
      (e) => e.itemid == itemid,
      orElse: () => CartModel(),
    );
    print("==================decrement item count: ${item.cartCount}");
    int currentCount = item.cartCount ?? 0;

    if (currentCount >= 1) {
      // ينقص العدد (الباك إند هيخصم واحد)
      await delete(itemid);
    }

    await view();
    update();
  }

  Future<void> addtocart(int itemid, int count) async {
    statusrequest = Statusrequest.loading;
    update();
    var response = await cartdata.addcartdata(userid!, itemid, count);
    statusrequest = handling(response);
    if (Statusrequest.success == statusrequest) {
      if (response["status"] == true) {
        Get.snackbar("Success", "تم اضافه المنتج للسلة ✅");
        CartController cartController = Get.find();
        await cartController.view(); // ✅ يحدث الداتا من السيرفر بعد الزيادة
      } else {
        statusrequest = Statusrequest.failure;
      }
    }
  }

  Future<void> delete(int itemid) async {
    statusrequest = Statusrequest.loading;
    update();
    var response = await cartdata.deletcartdata(userid!, itemid);
    statusrequest = handling(response);
    if (Statusrequest.success == statusrequest) {
      if (response["status"] == true) {
      } else {
        statusrequest = Statusrequest.failure;
      }
    }
  }

  Future<void> view() async {
    data.clear(); // ✅ تنظيف القديم
    statusrequest = Statusrequest.loading;

    update(); // ✅ لازم تتفعل هنا علشان Handlingdataview تعرض الـ loading
    var response = await cartdata.viewcart(userid!);

    statusrequest = handling(response);

    if (Statusrequest.success == statusrequest) {
      if (response["status"] == true) {
        data.clear();
        List datarespons = response["data"]["cart"];
        data.addAll(datarespons.map((e) => CartModel.fromJson(e)));

        totalcount =
            int.tryParse(response["data"]["total_count"]?.toString() ?? "0") ??
            0;

        totalprice =
            double.tryParse(
              response["data"]["total_price"]?.toString() ?? "0",
            ) ??
            0.0;
        if (data.isEmpty) {
          statusrequest = Statusrequest.failure;
        }
      } else {
        statusrequest = Statusrequest.failure;
      }
    }
    update(); // ✅ لتحديث الواجهة بالبيانات بعد الرد
  }

  //coubone========================================
  TextEditingController? coubonecontroller;
  CouponeModel? couponeModel;
  double couponediscount = 0;
  String? couponename;
  String? couponeID;

  void gotochechout() {
    Get.to(
      () => Checkout(),
      transition: Transition.fadeIn,
      arguments: {
        "Cartdata": data,
        "totalprice": totalpriceafterdiscount.toString(),
        "couponeID": couponeID ?? "0",
        "couponediscount": couponediscount.toString(),
      },
      duration: const Duration(milliseconds: 400),
    );
  }

  // Future<void> chechcoupone() async {
  //   statusrequest = Statusrequest.loading;
  //   update();
  //   if (data.isNotEmpty) {
  //     var response = await cartdata.couponedata(coubonecontroller!.text);
  //     statusrequest = handling(response);
  //     if (Statusrequest.success == statusrequest) {
  //       if (response["status"] == "success") {
  //         Map<String, dynamic> dataCoupone = response['data'];
  //         couponeModel = CouponeModel.fromJson(dataCoupone);
  //         couponediscount = double.parse(couponeModel!.couponDiscount!);
  //         couponename = couponeModel!.couponName;
  //         couponeID = couponeModel!.couponId.toString();
  //         Get.snackbar("الكوبون", "✅تم تطبيق الكوبون ");
  //       } else {
  //         couponediscount = 0;
  //         couponename = null;
  //         couponeID = null;
  //         Get.snackbar("خطأ في البيانات ", "الرجاء المحاوله مره اخري");
  //       }
  //     }
  //     update();
  //   } else {
  //     Get.snackbar("السلله  فارغه", "لا يمكن تطبيق الكوبون");
  //   }
  // }

  // 
  //coubone========================================

  @override
  void onInit() {
    coubonecontroller = TextEditingController();
    coupone.value = myservisec.sharedPreferences.getBool('cop') ?? false;

    view();

    super.onInit();
  }

  @override
  void onClose() {
    coubonecontroller!.dispose();
    super.onClose();
  }
}
