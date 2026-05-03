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
import 'package:hos/data/model/cartmodel.dart';

class Checkoutcontroller extends GetxController {
  List<List> paymentMethodEnum = [
    ["cash", Imageasset.cash], //0
    ["credit", Imageasset.visa], //1
    ["mobile", Imageasset.googlepay], //2
  ];
  var selectedMethod = "credit";
  void changePaymentMethod(String method) {
    selectedMethod = method;
    print(selectedMethod);
    update();
  }

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
  int? get userid => myservisec.sharedPreferences.getInt("id");
  Statusrequest statusrequest = Statusrequest.none;
  List<AddresModel> listaddresdata = [];

  //============================ جلب العناوين من السيرفر
  Future<void> getaddress() async {
    statusrequest = Statusrequest.loading;
    update();

    var response = await addresdata.viewAddresdata(userid!);

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
    if (listaddresdata.isEmpty) {
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
        "user_id":
            userid, // يفضل جلب الـ id من الـ Auth Service وليس كتابته يدوياً
        "address_id": addressid.value,
        "payment_method": selectedMethod,
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
          _showSnackBar("تم إرسال الطلب بنجاح");

          // مسح السلة (يفضل تفعيلها لضمان عدم تكرار الطلب)
          Get.find<CartController>().view();

          Future.delayed(const Duration(milliseconds: 300), () {
          Get.offAllNamed(Approute.Homescreen);
        });
        } else {
          statusrequest = Statusrequest.failure;
          _showSnackBar("خطأ في البيانات، الرجاء المحاولة مرة أخرى");
        }
      } else {
        // التعامل مع أخطاء السيرفر أو الإنترنت
        _showSnackBar("حدث خطأ في الاتصال بالخادم");
      }
    } catch (e) {
      // حماية التطبيق من الانهيار في حال حدث خطأ غير متوقع
      statusrequest = Statusrequest.serverfailure;
      _showSnackBar("حدث خطأ غير متوقع");
    } finally {
      update(); // تحديث الواجهة في كل الحالات
    }
  }

  // دالة مساعدة لتقليل تكرار كود السناك بار
  void _showSnackBar(String message) {
    ScaffoldMessenger.of(Get.context!).showSnackBar(
      SnackBar(
        duration: Duration(seconds: 4),
        behavior: SnackBarBehavior.floating, // يخليه طاير مش لازق تحت
        margin: EdgeInsets.all(12),
        backgroundColor: Colors.grey.shade900,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15), // 🔥 حواف دائرية
        ),

        content: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.green),
            SizedBox(width: 10),
            Expanded(
              child: Text(message, style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
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
