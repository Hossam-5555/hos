import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hos/controler/usercontroller/checkout&cart/cart_controller.dart';
import 'package:hos/data/services/crud.dart';
import 'package:hos/core/conistant/imageasset.dart';
import 'package:hos/core/functions/handlingdata.dart';
import 'package:hos/core/functions/snackbar.dart';
import 'package:hos/core/serveces/myservisec.dart';
import 'package:hos/data/datasource/userdata/addresdata.dart';
import 'package:hos/data/datasource/userdata/checkoutdata.dart';
import 'package:hos/data/model/addres_model.dart';
import 'package:hos/data/model/cartmodel.dart';
import 'package:hos/veiw/userscreen/screen/cartandcheckout/payment_result.dart';
import 'package:hos/veiw/userscreen/screen/cartandcheckout/paymentwepview.dart';

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
    ["cash", Imageasset.cash],
    ["card", Imageasset.visa], // ← تعديل credit إلى card
    ["wallet", Imageasset.googlepay], // ← تعديل mobile إلى wallet لو محفظة
  ];

  //============================ البيانات من السيرفر
  Addresdata addresdata = Addresdata(Get.find());
  Checkoutdata checkoutdata = Checkoutdata(Get.find());
  Myservisec myservisec = Get.find();
  Statusrequest statusrequest = Statusrequest.none;
  List<AddressModel> listaddresdata = [];
  TextEditingController? coubonecontroller;
  bool isactive = true;
  // ✨ المتغير السحري: شايل الـ Object بتاع العنوان المختار حالياً للشحن
  var selectedAddress = Rxn<AddressModel>();
  String? appliedCode;
  double couponDiscount = 0;
  bool isCouponLoading = false;
  String? couponError;
  double get productsTotal => double.tryParse(totalprice) ?? 0;
  double get total => productsTotal - couponDiscount + 50;
  Future<void> applyCoupon() async {
    final code = coubonecontroller!.text.trim();
    if (code.isEmpty) {
      couponError = "ادخل كود الكوبون";
      update();
      return;
    }

    isCouponLoading = true;
    couponError = null;
    update();

    var response = await checkoutdata.apply(code, productsTotal);

    if (response is Map) {
      if (response['status'] == true) {
        appliedCode = response['data']['code'];
        couponDiscount = double.parse(response['data']['discount'].toString());
      } else {
        couponError = response['message']?.toString() ?? "كوبون غير صالح";
      }
    } else {
      couponError = "تعذر الاتصال بالخادم";
    }

    isCouponLoading = false;
    update();
  }

  void removeCoupon() {
    appliedCode = null;
    couponDiscount = 0;
    couponError = null;
    coubonecontroller?.clear();
    update();
  }

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
      } else {
        showSnackBar(
          Get.context!,
          response['message']?.toString() ?? "فشل في جلب العناوين",
          Icon(Icons.error, color: Colors.red),
        );
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
        "payment_method": selectedMethod,
        if (appliedCode != null) "coupon_code": appliedCode,

        "items": cartdata
            .map((e) => {"product_id": e.itemid, "quantity": e.cartCount})
            .toList(),
      };

      // تنفيذ الطلب
      var response = await checkoutdata.Checkout(data);
      statusrequest = handling(response);

      if (statusrequest == Statusrequest.success) {
        if (response['status'] == true) {
          int orderId = response['data']['order_id'];

          // ✅ لو كاش → روح لصفحة النجاح مباشرة
          // لو كاش → روح لصفحة النجاح مباشرة
          if (selectedMethod == 'cash') {
            Get.find<CartController>().view();

            Get.to(
              () => PaymentResultPage(
                isSuccess: true,
                orderNumber: '#$orderId',
                amount:
                    '$total'
                            "EGP"
                        .tr,
                transactionId: 'CASH',
                paymentMethod: 'كاش عند الاستلام',
              ),
            );

            return;
          }

          // ✅ لو credit → ابدأ الدفع
          var paymentResponse = await checkoutdata.payment(orderId);
          if (paymentResponse['status'] == true) {
            String paymentUrl = paymentResponse['data']['payment_url'];
            Get.to(
              () => PaymentWebViewScreen(),
              arguments: {'url': paymentUrl, 'order_id': orderId},
            );
          } else {
            showSnackBar(
              Get.context!,
              "فشل في إنشاء رابط الدفع",
              Icon(Icons.error, color: Colors.red),
            );
          }

          Get.find<CartController>().view();
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
    coubonecontroller = TextEditingController();
    totalprice = Get.arguments['totalprice'].toString();
    cartdata = Get.arguments['Cartdata'];
    getaddress();
    super.onInit();
  }
}
