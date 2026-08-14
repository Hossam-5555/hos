import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hos/controler/usercontroller/checkout&cart/CartController.dart';
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
  String selectedMethod = "cash";

  // مفتاح الفورم للتحقق من صحة البيانات
  // دالة لتغيير طريقة الدفع
  void changePaymentMethod(String method) {
    selectedMethod = method;
    update();
  }

  List<List> paymentMethodEnum = [
    ["cash", Imageasset.cash], //0
    ["credit", Imageasset.visa], //1
    ["mobile", Imageasset.googlepay], //2
  ];

  //============================ البيانات من السيرفر
  Addresdata addresdata = Addresdata(Get.find());
  Checkoutdata checkoutdata = Checkoutdata(Get.find());
  Myservisec myservisec = Get.find();
  Statusrequest statusrequest = Statusrequest.none;
  List<AddressModel> listaddresdata = [];

  // ✨ المتغير السحري: شايل الـ Object بتاع العنوان المختار حالياً للشحن
  var selectedAddress = Rxn<AddressModel>();

  // دالة بتهيا العنوان الابتدائي أول ما البيانات تيجي من الـ API

  // دالة الاختيار لما المستخدم يغير العنوان من الـ Sheet
  void chooseAddres(AddressModel address) {
    selectedAddress.value = address; // تحديث الـ Object بالكامل
  }

  int isdafault = 0;
  //============================ جلب العناوين من السيرفر
  Future<void> getaddress() async {
    // statusrequest = Statusrequest.loading;
    // update();

    var response = await addresdata.viewAddresdata();

    statusrequest = handling(response);

    if (Statusrequest.success == statusrequest) {
      if (response['status'] == true) {
        List data = response['data']['data'];
        isdafault = response['data']["is_default"];
        // تنظيف القائمة قبل الإضافة
        listaddresdata.clear();
        listaddresdata.addAll(data.map((e) => AddressModel.fromJson(e)));
        if (listaddresdata.isNotEmpty) {
          // بيبحث عن الافتراضي أو ياخد أول واحد ويخزنه كـ Object كامل
          selectedAddress.value = listaddresdata.firstWhere(
            (e) => e.id == isdafault,
            orElse: () => listaddresdata.first,
          );
        }
      }
    } else {
      statusrequest = Statusrequest.failure;
    }

    update();
  }

  //============================ تنفيذ عملية الطلب
  Future<void> checkoutoder() async {
    // 1. التحقق من وجود عنوان
    if (selectedAddress.value == null) {
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
        "address_id": selectedAddress.value?.id,
        "payment_method": "credit",
        "items": cartdata
            .map((e) => {"product_id": e.itemid, "quantity": e.cartCount})
            .toList(),
      };

      // تنفيذ الطلب
      var response = await checkoutdata.Checkout(data);
      print("Response from checkout: $response");
      statusrequest = handling(response);

      if (statusrequest == Statusrequest.success) {
        if (response['status'] == true) {
          // نجاح العملية
          // showSnackBar(
          //   Get.context!,
          //   "تم إرسال الطلب بنجاح",
          //   Icon(Icons.check_circle, color: Colors.green),
          // );
          int orderId = response['data']['order_id'];

          var paymentResponse = await checkoutdata.payment(orderId);
          print("Payment response: $paymentResponse");
          // مسح السلة (يفضل تفعيلها لضمان عدم تكرار الطلب)
          Get.find<CartController>().view();
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
