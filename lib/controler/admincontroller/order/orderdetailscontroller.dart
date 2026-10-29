import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hos/controler/admincontroller/order/pindingcontroller.dart';
import 'package:hos/core/functions/handlingdata.dart';
import 'package:hos/core/functions/orderstatus.dart';
import 'package:hos/core/serveces/myservisec.dart';
import 'package:hos/data/datasource/admindata/orderdata.dart';
import 'package:hos/data/model/ordersmodel.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../data/services/crud.dart';

class AdminOrderDetailesController extends GetxController {
  OrderModel? order;

  // 🔹 1. متغير محلي جديد لحفظ الحالة الحالية وقابل للتعديل
  String currentStatus = 'pending';

  Myservisec myservisec = Get.find();
  AdminDataOrder dataOrder = Get.put(AdminDataOrder(Get.find()));
  Color? statusColor;
  String? statusText;
  Statusrequest statusrequest = Statusrequest.none;

  String? get langage => myservisec.sharedPreferences.getString("lang");
  bool get lang => langage == "ar";

  void getcolorandstause(String status) {
    final st = OrderStatus.from(status);
    statusColor = st.color;
    statusText = st.label(isArabic: lang);
  }

  @override
  void onInit() {
    final args = Get.arguments;
    if (args != null && args["order"] != null) {
      order = args["order"];
      // 🔹 2. نأخذ الحالة الابتدائية من الـ Model عند فتح الصفحة
      currentStatus = order!.status;
      getcolorandstause(currentStatus);
    }
    super.onInit();
  }

  void updateStatus(String s) async {
    statusrequest = Statusrequest.loading;
    update();

    var response = await dataOrder.changestatus(order!.orderId, s);
    statusrequest = handling(response);

    if (Statusrequest.success == statusrequest) {
      if (response['status'] == true) {
        // 🔹 3. هنا الحل! بنعدل المتغير المحلي للـ Controller مش الـ Model
        currentStatus = s;
        order!.status = s; // السطر الناقص

        getcolorandstause(s);

        try {
          if (Get.isRegistered<AdminPindingController>()) {
            final pendingCtrl = Get.find<AdminPindingController>();
            pendingCtrl.viewOrders(s);

            int currentstat = pendingCtrl.statusKeys.indexWhere((e) => e == s);
            pendingCtrl.selectedStatus = currentstat;
          }
        } catch (e) {
          if (kDebugMode) print("Error: $e");
        }
      } else {
        statusrequest = Statusrequest.failure;
      }
    }
    update();
  }

  RxBool isLoading = false.obs;

  Future<void> makePhoneCall() async {
    isLoading.value = true;

    // ✅ تأخير بسيط قبل تنفيذ العملية (مثلاً ثانية)
    await Future.delayed(const Duration(milliseconds: 750));

    final Uri phoneUri = Uri(scheme: 'tel', path: '+201023426561');

    try {
      await launchUrl(phoneUri);
    } catch (e) {
      Get.snackbar("خطأ", "تعذر فتح تطبيق الاتصال 😢");
    }

    // ✅ تأخير بسيط بعد العملية لتجميل الحركة
    await Future.delayed(const Duration(milliseconds: 500));

    isLoading.value = false;
  }

  RxBool istracking = false.obs;

  Future<void> openMap({required double lat, required double lng}) async {
    istracking.value = true;
    // رابط موحد يفتح Google Maps أو Apple Maps حسب نظام التشغيل
    final Uri googleMapsUrl = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=$lat,$lng',
    );

    if (await canLaunchUrl(googleMapsUrl)) {
      await launchUrl(
        googleMapsUrl,
        mode: LaunchMode
            .externalApplication, // يفتح في تطبيق الخرائط الخاص بالجهاز
      );
    } else {
      debugPrint('تعذر فتح الخرائط');
    }
    istracking.value = false;
  }
}
