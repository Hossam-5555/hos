import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hos/core/class/crud.dart';
import 'package:hos/core/functions/handlingdata.dart';
import 'package:hos/core/serveces/myservisec.dart';
import 'package:hos/data/datasource/admindata/orderdata.dart';
import 'package:hos/data/model/ordersmodel.dart';
import 'package:hos/veiw/adminscreen/Home/orders/admin_orderdetails.dart';

class AdminPindingController extends GetxController {
  Myservisec myservisec = Get.find();
  AdminDataOrder orderdata = Get.put(AdminDataOrder(Get.find()));
  Statusrequest statusrequest = Statusrequest.none;

  List<OrderModel> orderspending = [];
  int selectedStatus = 0;

  List<String> statusKeys = [
    "all", // 0
    "pending", // 1
    "processing", // 2
    "shipped", // 3
    "delivered", // 4
  ];

  @override
  void onInit() {
    super.onInit();
    // جلب كل الطلبات عند فتح الشاشة
    viewOrders(statusKeys[0]);
  }

  void changeSelectedStatus(int index) {
    selectedStatus = index;
    update();
    viewOrders(statusKeys[index]);
  }

  Future<void> viewOrders(String status) async {
    orderspending.clear();
    statusrequest = Statusrequest.loading;
    update();

    var response = await orderdata.pendingdata(status);
    statusrequest = handling(response);
 print("Response from viewOrders: $response");
    if (Statusrequest.success == statusrequest) {
      // ✳️ التحقق من نجاح حالة الرد من السيرفر
      if (response['status'] == true && response['data'] != null) {
        List data = [];

        // هنا نقوم بفحص الهيكل: إذا كان يحتوي على مصفوفة داخلية بسبب الـ Pagination
        if (response['data'] is Map && response['data']['data'] != null) {
          data = response['data']['data'];
        } else if (response['data'] is List) {
          data = response['data'];
        }

        orderspending.addAll(data.map((e) => OrderModel.fromJson(e)));

        if (orderspending.isEmpty) {
          statusrequest = Statusrequest.nodata;
        }
      } else {
        statusrequest = Statusrequest.failure;
      }
    }
    update();
  }

  // --- دوال التصميم والترجمة ---

  Color? statusColor;
  String? statusText;

  String? get langage => myservisec.sharedPreferences.getString("lang");
  bool get lang => langage == "ar" ? true : false;

  List<String> get orderstatus => lang
      ? [
          "الكل",
          "قيد الانتظار",
          "قيد التجهيز",
          "في الطريق",
          "تم التسليم",
        ]
      : ["All", "Pending", "Processing", "Shipped", "Delivered",];

  void getcolorandstause(String status) {
    if (status == "pending") {
      statusColor = Colors.orange;
      statusText = lang ? "قيد الانتظار" : "Pending";
    } else if (status == "processing") {
      statusColor = Colors.blue;
      statusText = lang ? "قيد التجهيز" : "Processing";
    } else if (status == "shipped") {
      statusColor = const Color.fromARGB(255, 148, 21, 173);
      statusText = lang ? "في الطريق" : "Shipped";
    } else if (status == "delivered") {
      statusColor = const Color.fromARGB(255, 33, 201, 10);
      statusText = lang ? "تم التسليم" : "Delivered";
    } else {
      statusColor = const Color.fromARGB(200, 226, 226, 226);
      statusText = lang ? "غير معروف" : "Unknown";
    }
  }

  // --- دوال التحكم في الطلبات ---

  // Future<void> approvependingorder(String userid, String orderid) async {
  //   statusrequest = Statusrequest.loading;
  //   update();

  //   var response = await orderdata.approveorder(orderid, userid);
  //   statusrequest = handling(response);

  //   if (Statusrequest.success == statusrequest) {
  //     if (response['status'] == true) {
  //       Get.snackbar("نجاح", "تم قبول الطلب بنجاح");
  //       // تحديث القسم الحالي الذي يقف عليه الأدمن
  //       viewOrders(statusKeys[selectedStatus]);
  //     } else {
  //       Get.snackbar("حدث خطأ", "الرجاء إعادة المحاولة");
  //       viewOrders(statusKeys[selectedStatus]);
  //     }
  //   }
  //   update();
  // }

  void gotodetails(OrderModel order) {
    Get.to(
      () => const AdminOrderdetails(),
      arguments: {"order": order},
      duration: const Duration(milliseconds: 400),
      transition: Transition.fadeIn,
    );
  }
}
