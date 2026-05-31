import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hos/controler/usercontroller/checkout&cart/CartController.dart';
import 'package:hos/controler/usercontroller/profile/paymentcontroller.dart';
import 'package:hos/core/class/crud.dart';
import 'package:hos/core/conistant/imageasset.dart';
import 'package:hos/core/functions/handlingdata.dart';
import 'package:hos/core/functions/snackbar.dart';
import 'package:hos/core/serveces/myservisec.dart';
import 'package:hos/data/datasource/userdata/addresdata.dart';
import 'package:hos/data/datasource/userdata/checkoutdata.dart';
import 'package:hos/data/model/Addresmodel.dart';
import 'package:hos/data/model/cartmodel.dart';

class Checkoutcontroller extends GetxController {
  final formKey = GlobalKey<FormState>();
  var selectedMethod = PaymentMethod.creditCard.obs;

  // مفتاح الفورم للتحقق من صحة البيانات
  // دالة لتغيير طريقة الدفع
  void changePaymentMethod(PaymentMethod method) {
    selectedMethod.value = method;
  }

  List<List> paymentMethodEnum = [
    ["cash", Imageasset.cash], //0
    ["credit", Imageasset.visa], //1
    ["mobile", Imageasset.googlepay], //2
  ];

  //============================ المتغيرات
  RxInt addressid = 0.obs;
  //============================ الدوال الخاصة بالاختيار

  void chooseAddres(int val) {
    addressid.value = val;
  }

  //============================ البيانات من السيرفر
  Addresdata addresdata = Addresdata(Get.find());
  Checkoutdata checkoutdata = Checkoutdata(Get.find());
  Myservisec myservisec = Get.find();
  Statusrequest statusrequest = Statusrequest.none;
  List<AddresModel> listaddresdata = [];

  //============================ جلب العناوين من السيرفر
  Future<void> getaddress() async {
    // statusrequest = Statusrequest.loading;
    // update();

    var response = await addresdata.viewAddresdata();

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
  Future<void> checkoutoder() async {
    // 1. التحقق من وجود عنوان
    if (addressid.value == 0) {
      Get.snackbar("تنبيه", "الرجاء إضافة عنوان أولاً");
      return; // ضروري جداً لمنع إكمال الدالة
    }

    // 2. التحقق من وسيلة الدفع
    if (selectedMethod == '') {
      Get.snackbar("خطأ", "الرجاء اختيار وسيلة الدفع");
      return;
    }

    // وضع حالة التحميل
    statusrequest = Statusrequest.loading;
    update();

    try {
      // تجهيز البيانات
      Map<String, dynamic> data = {
        "address_id": addressid.value,
        "payment_method": "credit",
        "items": cartdata
            .map((e) => {"product_id": e.itemid, "quantity": e.cartCount})
            .toList(),
      };

      // تنفيذ الطلب
      var response = await checkoutdata.Checkout(data);
      statusrequest = handling(response);

      if (statusrequest == Statusrequest.success) {
        if (response['status'] == true) {
          // نجاح العملية
          showSnackBar(
            Get.context!,
            "تم إرسال الطلب بنجاح",
            Icon(Icons.check_circle, color: Colors.green),
          );

          // مسح السلة (يفضل تفعيلها لضمان عدم تكرار الطلب)
          Get.find<CartController>().view();

          Future.delayed(const Duration(milliseconds: 300), () {
            Get.back();
          });
        } else {
          statusrequest = Statusrequest.failure;
          showSnackBar(
            Get.context!,
            "خطأ في البيانات، الرجاء المحاولة مرة أخرى",
            Icon(Icons.question_mark, color: Colors.red),
          );
        }
      } else {
        // التعامل مع أخطاء السيرفر أو الإنترنت
        showSnackBar(
          Get.context!,
          "حدث خطأ في الاتصال بالخادم",
          Icon(Icons.question_mark, color: Colors.red),
        );
      }
    } catch (e) {
      // حماية التطبيق من الانهيار في حال حدث خطأ غير متوقع
      statusrequest = Statusrequest.serverfailure;
      showSnackBar(
        Get.context!,
        "حدث خطأ غير متوقع",
        Icon(Icons.question_mark, color: Colors.red),
      );
    } finally {
      update(); // تحديث الواجهة في كل الحالات
    }
  }

  //============================ متغيرات الكوبون والسعر
  String? couponeid;
  String couponediscount = "0";

  late String totalprice;
  List<CartModel> cartdata = [];
  @override
  void onInit() {
    couponeid = Get.arguments['couponeID'].toString();
    totalprice = Get.arguments['totalprice'].toString();
    couponediscount = Get.arguments['couponediscount'].toString();
    cartdata = Get.arguments['Cartdata'];
    getaddress();
    super.onInit();
  }
}
