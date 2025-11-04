import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hos/core/class/crud.dart';
import 'package:hos/core/conistant/imageasset.dart';
import 'package:hos/core/conistant/routs.dart';
import 'package:hos/core/functions/handlingdata.dart';
import 'package:hos/core/serveces/myservisec.dart';
import 'package:hos/data/datasource/remote/addresdata.dart';
import 'package:hos/data/datasource/remote/checkoutdata.dart';
import 'package:hos/data/model/Addresmodel.dart';

class Checkoutcontroller extends GetxController {
  //============================ العناوين الافتراضية
  final List<Map<String, String>> addresses = [
    {"title": "Home Address", "subtitle": "123 Main St, Cairo"},
    {"title": "Work Address", "subtitle": "Downtown, Nasr City"},
    {"title": "Other Address", "subtitle": "Alexandria, Corniche"},
  ];

  //============================ وسائل الدفع الافتراضية
  final List<List> paymentMethods = [
    ["Cash", Imageasset.cash],
    ["Visa", Imageasset.Visa],
    ["Wallet", Imageasset.googlepay],
  ];

  //============================ المتغيرات
  int? Paymenttype;
  String? deleverytype;
  int Addressid = 0;

  //============================ الدوال الخاصة بالاختيار
  void choospaymentmethod(val) {
    Paymenttype = val;
    update();
  }

  void choosedeleverytype(val) {
    deleverytype = val;
    update();
  }

  void chooseAddres(val) {
    Addressid = val;
    update();
  }

  //============================ البيانات من السيرفر
  Addresdata addresdata = Addresdata(Get.find());
  Checkoutdata checkoutdata = Checkoutdata(Get.find());
  Myservisec myservisec = Get.find();

  Statusrequest? statusrequest;
  List<Addresmodel> ListAddresdata = [];

  //============================ جلب العناوين من السيرفر
  Future<void> getaddress() async {
    statusrequest = Statusrequest.loading;
    update();

    var response = await addresdata.viewAddresdata(
      myservisec.sharedPreferences.getString("id")!,
    );

    statusrequest = handling(response);

    if (Statusrequest.success == statusrequest) {
      if (response['status'] == 'success') {
        List data = response['data'];

        // تنظيف القائمة قبل الإضافة
        ListAddresdata.clear();
        ListAddresdata.addAll(data.map((e) => Addresmodel.fromJson(e)));
      }
    } else {
      statusrequest = Statusrequest.failure;
    }

    update();
  }

  //============================ تنفيذ عملية الطلب
  checkoutoder() async {
    if (Addressid == 0) {
      Get.snackbar("خطأ", "الرجاء إدخال العنوان");
      return;
    }

    if (Paymenttype == null) {
      Get.snackbar("خطأ", "الرجاء اختيار وسيلة الدفع");
      return;
    }

    if (ListAddresdata.isEmpty) {
      Get.snackbar("  تنبيه", "الرجاء اضافه  عنوان ");
    }
    statusrequest = Statusrequest.loading;
    update();

    Map<String, dynamic> data = {
      "userid": myservisec.sharedPreferences.getString("id")!,
      "addressid": Addressid.toString(),
      "orderstype": "0",
      "pricedelivery": "10",
      "ordersprice": totalprice.toString(),
      "couponid": couponeid.toString(),
      "couponediscount": couponediscount.toString(),
      "paymentmethod": Paymenttype.toString(), // ← هنا برضه
    };

    var response = await checkoutdata.Checkout(data);
    statusrequest = handling(response);
    if (statusrequest == Statusrequest.success) {
      if (response['status'] == 'success') {
        // ✅ نجاح العملية
        Get.snackbar(
          "تم الطلب بنجاح ✅",
          "سيتم توصيل طلبك في أقرب وقت",
          backgroundColor: const Color.fromARGB(
            255,
            242,
            245,
            242,
          ).withOpacity(0.8),
          colorText: const Color.fromARGB(255, 0, 0, 0),
          duration: const Duration(seconds: 2),
        );

        Get.offAllNamed(Approute.Homescreen);
      } else {
        statusrequest = Statusrequest.failure;
        update();
        Get.snackbar("خطأ في البيانات", "الرجاء المحاولة مرة أخرى");
      }
    } else {
      statusrequest = Statusrequest.serverfailure;
      update();
      Get.snackbar("خطأ", "حدث خطأ أثناء إرسال الطلب");
    }
  }

  //============================ متغيرات الكوبون والسعر
  String? couponeid;
  late String totalprice;
  String couponediscount = "0";

  @override
  void onInit() {
    couponeid = Get.arguments['couponeID'].toString();
    totalprice = Get.arguments['totalprice'].toString();
    couponediscount = Get.arguments['couponediscount'].toString();

    getaddress();
    super.onInit();
  }
}
