import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hos/controler/usercontroller/checkout&cart/CartController.dart';
import 'package:hos/core/class/crud.dart';
import 'package:hos/core/conistant/imageasset.dart';
import 'package:hos/core/conistant/routs.dart';
import 'package:hos/core/functions/handlingdata.dart';
import 'package:hos/core/serveces/myservisec.dart';
import 'package:hos/data/datasource/userdata/addresdata.dart';
import 'package:hos/data/datasource/userdata/checkoutdata.dart';
import 'package:hos/data/model/Addresmodel.dart';

class Checkoutcontroller extends GetxController {
  final List<List> paymentMethods = [
    ["Cash", Imageasset.cash],
    ["Visa", Imageasset.visa],
    ["Wallet", Imageasset.googlepay],
  ];

  //============================ المتغيرات
  int? paymenttype;
  String? deleverytype;
  int addressid = 0;

  //============================ الدوال الخاصة بالاختيار
  void choospaymentmethod(int val) {
    paymenttype = val;
    update();
  }

  void choosedeleverytype(String val) {
    deleverytype = val;
    update();
  }

  void chooseAddres(int val) {
    addressid = val;
    update();
  }

  //============================ البيانات من السيرفر
  Addresdata addresdata = Addresdata(Get.find());
  Checkoutdata checkoutdata = Checkoutdata(Get.find());
  Myservisec myservisec = Get.find();

  Statusrequest? statusrequest;
  List<Addresmodel> listaddresdata = [];

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
        listaddresdata.clear();
        listaddresdata.addAll(data.map((e) => Addresmodel.fromJson(e)));
      }
    } else {
      statusrequest = Statusrequest.failure;
    }

    update();
  }

  //============================ تنفيذ عملية الطلب
  Future<void> checkoutoder(double margen) async {
    // تحقق من العنوان
    if (addressid == 0) {
      Get.snackbar("خطأ", "الرجاء إدخال العنوان");
      return;
    }

    // تحقق من وسيلة الدفع
    if (paymenttype == null) {
      Get.snackbar("خطأ", "الرجاء اختيار وسيلة الدفع");
      return;
    }

    // تحقق من وجود عنوان
    if (listaddresdata.isEmpty) {
      Get.snackbar("  تنبيه", "الرجاء اضافه  عنوان ");
    }

    // وضع حالة التحميل
    statusrequest = Statusrequest.loading;
    update();

    // تجهيز البيانات
    Map<String, dynamic> data = {
      "userid": myservisec.sharedPreferences.getString("id")!,
      "addressid": addressid.toString(),
      "orderstype": "0",
      "pricedelivery": "10",
      "ordersprice": totalprice.toString(),
      "couponid": couponeid.toString(),
      "couponediscount": couponediscount.toString(),
      "paymentmethod": paymenttype.toString(),
    };

    // تنفيذ الطلب
    var response = await checkoutdata.Checkout(data);
    statusrequest = handling(response);

    if (statusrequest == Statusrequest.success) {
      if (response['status'] == 'success') {
        // نجاح العملية
        Get.snackbar("نجاح", "تم تنفيذ الطلب بنجاح");
        Get.find<CartController>().view(); // مسح السلة بعد الطلب
        // العودة للصفحة الرئيسية
        Get.offAllNamed(Approute.Homescreen);
      } else {
        statusrequest = Statusrequest.failure;
        update();

        ScaffoldMessenger.of(Get.context!).showSnackBar(
          SnackBar(
            content: Text("خطأ في البيانات\nالرجاء المحاولة مرة أخرى"),
            duration: const Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.all(16),
          ),
        );
      }
    } else {
      statusrequest = Statusrequest.serverfailure;
      update();

      ScaffoldMessenger.of(Get.context!).showSnackBar(
        SnackBar(
          content: Text("حدث خطأ أثناء إرسال الطلب"),
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
        ),
      );
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
