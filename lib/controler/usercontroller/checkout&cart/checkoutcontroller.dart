import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hos/controler/usercontroller/checkout&cart/CartController.dart';
import 'package:hos/controler/usercontroller/profile/paymentcontroller.dart';
import 'package:hos/core/class/crud.dart';
import 'package:hos/core/conistant/imageasset.dart';
import 'package:hos/core/conistant/routs.dart';
import 'package:hos/core/functions/handlingdata.dart';
import 'package:hos/core/serveces/myservisec.dart';
import 'package:hos/data/datasource/userdata/addresdata.dart';
import 'package:hos/data/datasource/userdata/checkoutdata.dart';
import 'package:hos/data/model/Addresmodel.dart';

class Checkoutcontroller extends GetxController {
  List<List> paymentMethodEnum = [
    [PaymentMethod.cod, Imageasset.cash], //0
    [PaymentMethod.creditCard, Imageasset.visa], //1
    [PaymentMethod.mobileWallet, Imageasset.googlepay], //2
  ];
  var selectedMethod = PaymentMethod.creditCard.obs;
  void changePaymentMethod(PaymentMethod method) {
    selectedMethod.value = method;
  }

  //============================ المتغيرات
  String? deleverytype;
  RxInt addressid = 0.obs;
  //============================ الدوال الخاصة بالاختيار

  void choosedeleverytype(String val) {
    deleverytype = val;
    update();
  }

  void chooseAddres(int val) {
    addressid.value = val;
  }

  //============================ البيانات من السيرفر
  Addresdata addresdata = Addresdata(Get.find());
  Checkoutdata checkoutdata = Checkoutdata(Get.find());
  Myservisec myservisec = Get.find();

  Statusrequest? statusrequest;
  List<AddresModel> listaddresdata = [];

  //============================ جلب العناوين من السيرفر
  Future<void> getaddress() async {
    statusrequest = Statusrequest.loading;
    update();

    var response = await addresdata.viewAddresdata(
      // myservisec.sharedPreferences.getString("id")!,
      "2",
    );

    statusrequest = handling(response);

    if (Statusrequest.success == statusrequest) {
      if (response['status'] == true) {
        List data = response['data'];

        // تنظيف القائمة قبل الإضافة
        listaddresdata.clear();
        listaddresdata.addAll(data.map((e) => AddresModel.fromJson(e)));
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
    if (selectedMethod.value == PaymentMethod.none) {
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
      "paymentmethod": selectedMethod.value.toString(),
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
