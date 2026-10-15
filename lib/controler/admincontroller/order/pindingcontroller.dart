import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hos/core/class/crud.dart';
import 'package:hos/core/functions/handlingdata.dart';
import 'package:hos/core/functions/orderstatus.dart';
import 'package:hos/core/serveces/myservisec.dart';
import 'package:hos/data/datasource/admindata/orderdata.dart';
import 'package:hos/data/model/ordersmodel.dart';
import 'package:hos/veiw/adminscreen/Home/orders/admin_orderdetails.dart';

class AdminPindingController extends GetxController {
  Myservisec myservisec = Get.find();
  AdminDataOrder orderdata = Get.put(AdminDataOrder(Get.find()));
  Statusrequest statusrequest = Statusrequest.none;
  final ScrollController scrollController = ScrollController();
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

  @override
  void onInit() {
    super.onInit();
    scrollController.addListener(() {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent - 300) {
        viewOrders(statusKeys[selectedStatus], loadMore: true);
      }
    });
    // جلب كل الطلبات عند فتح الشاشة
    viewOrders(statusKeys[0]);
  }

  void changeSelectedStatus(int index) {
    selectedStatus = index;
    update();
    viewOrders(statusKeys[index]);
  }

  int currentPage = 1;
  int lastPage = 1;

  bool isLoadingMore = false;

  Future<void> viewOrders(String status, {bool loadMore = false}) async {
    // =========================
    // تحميل الصفحة الأولى
    // =========================
    if (!loadMore) {
      currentPage = 1;
      lastPage = 1;

      orderspending.clear();

      statusrequest = Statusrequest.loading;
      update();
    } else {
      // منع طلب أكثر من صفحة في نفس الوقت
      if (isLoadingMore) return;

      // التأكد أن هناك صفحة أخرى
      if (currentPage >= lastPage) return;

      isLoadingMore = true;
      update();
    }

    // الصفحة المطلوبة
    final int requestedPage = loadMore ? currentPage + 1 : 1;

    var response = await orderdata.pendingdata(status, page: requestedPage);

    statusrequest = handling(response);

    if (Statusrequest.success == statusrequest) {
      if (response['status'] == true && response['data'] != null) {
        // =========================
        // بيانات الـPagination
        // =========================
        final pagination = response['data'];

        List data = [];

        if (pagination is Map && pagination['data'] != null) {
          data = pagination['data'];
        }

        // =========================
        // معرفة آخر صفحة
        // =========================
        if (pagination is Map && pagination['meta'] != null) {
          lastPage = pagination['meta']['last_page'] ?? 1;
        }

        // =========================
        // إضافة البيانات الجديدة
        // =========================
        final existingIds = orderspending.map((e) => e.orderId).toSet();

        for (var e in data) {
          final order = OrderModel.fromJson(e);

          if (existingIds.add(order.orderId)) {
            orderspending.add(order);
          }
        }

        // تحديث الصفحة بعد نجاح الطلب فقط
        currentPage = requestedPage;

        if (orderspending.isEmpty) {
          statusrequest = Statusrequest.nodata;
        } else {
          statusrequest = Statusrequest.success;
        }
      } else {
        statusrequest = Statusrequest.failure;
      }
    }

    isLoadingMore = false;

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
          "ملغي",
        ]
      : ["All", "Pending", "Processing", "Shipped", "Delivered", "Cancelled"];

  void getcolorandstause(String status) {
    final st = OrderStatus.from(status);
    statusColor = st.color;
    statusText = st.label(isArabic: lang);
  }

  void gotodetails(OrderModel order) {
    Get.to(
      () => const AdminOrderdetails(),
      arguments: {"order": order},
      duration: const Duration(milliseconds: 400),
      transition: Transition.fadeIn,
    );
  }
}
