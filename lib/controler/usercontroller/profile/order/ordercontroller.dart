import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hos/core/class/crud.dart';
import 'package:hos/core/functions/handlingdata.dart';
import 'package:hos/core/serveces/myservisec.dart';
import 'package:hos/data/datasource/userdata/orderdata.dart';
import 'package:hos/data/model/ordersmodel.dart';

class Ordercontroller extends GetxController {
  List<OrderModel> orders = [];
  final ScrollController scrollController = ScrollController();
  RxInt get orderscount => orders.length.obs;
  Statusrequest statusrequest = Statusrequest.none;
  Myservisec myservisec = Get.find();
  Orderdata orderdata = Orderdata(Get.find());
  TextEditingController? comment;
  int? get userid => myservisec.sharedPreferences.getInt("id");
  int selectedRating = 0;
  void changeRatingColor(int i) {
    selectedRating = i + 1; // خزن رقم النجمة اللي المستخدم ضغطها
    update(); // يحدث الواجهة
  }

  Color? statusColor;
  String? statusText;
  String? get langage => myservisec.sharedPreferences.getString("lang");
  bool get lang => langage == "ar" ? true : false;
  // ignore: non_constant_identifier_names
  void Getcolorandstause(String status) {
    if (status == "pending") {
      statusColor = Colors.orange;
      statusText = lang ? "قيد الانتظار" : "Pending";
    } else if (status == "processing") {
      statusColor = Colors.blue;
      statusText = lang ? "قيد التجهيز" : "Processing";
    } else if (status == "shipped") {
      statusColor = const Color.fromARGB(255, 179, 123, 39);
      statusText = lang ? "في الطريق" : "Shipped";
    } else if (status == "delivered") {
      statusColor = const Color.fromARGB(255, 33, 201, 10);
      statusText = lang ? "تم التسليم" : "Delivered";
    } else if (status == "cancelled") {
      statusColor = Colors.red;
      statusText = lang ? "ملغي" : "Cancelled";
    } else {
      statusColor = const Color.fromARGB(200, 226, 226, 226);
      statusText = lang ? "غير معروف" : "Unknown";
    }
  }

  List<OrderModel> orderspending = [];
  int selectedStatus = 0;

  List<String> statusKeys = [
    "all", // 0
    "pending", // 1
    "processing", // 2
    "shipped", // 3
    "delivered", // 4
    "cancelled",
  ];

  void changeSelectedStatus(int index) {
    selectedStatus = index;
    update();
    viewmyorders();
  }

  List<String> get orderstatus => lang
      ? [
          "الكل",
          "قيد الانتظار",
          "قيد التجهيز",
          "في الطريق",
          "تم التسليم",
          "ملغي",
        ]
      : ["All", "Pending", "Processing", "Shipped", "Delivered", "Cancelled"];

  int page = 1;
  int lastPage = 1;

  bool isLoadingMore = false;
  Future<void> viewmyorders({bool isLoadMore = false}) async {
    // لو بنحمل صفحة جديدة
    if (isLoadMore) {
      if (isLoadingMore) return;

      // مفيش صفحات تانية
      if (page >= lastPage) return;

      isLoadingMore = true;
      update();

      page++;
    } else {
      // تحميل أول صفحة
      page = 1;
      orders.clear();

      statusrequest = Statusrequest.loading;
      update();
    }

    var response = await orderdata.order(
      status: statusKeys[selectedStatus],
      page: page,
    );

    if (isLoadMore) {
      isLoadingMore = false;
    }

    statusrequest = handling(response);

    if (Statusrequest.success == statusrequest) {
      if (response['status'] == true) {
        List data = response["data"]["data"];

        // معلومات الـPagination
        final meta = response["data"]["meta"];

        lastPage = meta["last_page"] ?? 1;
        // إضافة الطلبات الجديدة
        orders.addAll(data.map((e) => OrderModel.fromJson(e)));

        if (orders.isEmpty) {
          statusrequest = Statusrequest.nodata;
        } else {
          statusrequest = Statusrequest.success;
        }
      } else {
        statusrequest = Statusrequest.failure;
      }
    }

    update();
  }

  void onScroll() {
    if (!scrollController.hasClients) return;

    final position = scrollController.position;

    // لما نوصل قبل نهاية القائمة بـ 300px
    if (position.pixels >= position.maxScrollExtent - 300) {
      viewmyorders(isLoadMore: true);
    }
  }

  //هي الي هتخلي الاوردر ملغي
  Future<void> deleteorders(int orderid) async {
    statusrequest = Statusrequest.loading;
    update();

    try {
      var response = await orderdata.deletedata(orderid);
      statusrequest = handling(response);

      if (Statusrequest.success == statusrequest &&
          response['status'] == true) {
        Get.back();

        Get.snackbar(
          "نجاح",
          "تم إلغاء الطلب بنجاح",
          icon: const Icon(Icons.check_circle, color: Colors.white),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.grey.shade800,
          colorText: Colors.white,
          margin: const EdgeInsets.all(15),
          duration: const Duration(seconds: 2),
        );

        final index = orders.indexWhere((e) => e.orderId == orderid);
        if (index != -1) {
          orders[index].status = "cancelled";
        }
      }
    } catch (e) {
      statusrequest = Statusrequest.serverfailure;
    } finally {
      if (Get.isRegistered<Ordercontroller>()) {
        update();
      }
    }
  }

  @override
  void onInit() {
    comment = TextEditingController();
    scrollController.addListener(onScroll);

    viewmyorders();
    super.onInit();
  }

  @override
  void onClose() {
    scrollController.dispose();

    super.onClose();
  }
}
