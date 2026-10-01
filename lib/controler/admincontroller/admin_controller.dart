import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hos/core/class/crud.dart';
import 'package:hos/core/conistant/imageasset.dart';
import 'package:hos/core/functions/handlingdata.dart';
import 'package:hos/data/datasource/admindata/dashboarddata.dart';
import 'package:hos/veiw/adminscreen/Home/admin_home.dart';
import 'package:hos/veiw/adminscreen/Home/categories/viewcat.dart';
import 'package:hos/veiw/adminscreen/Home/orders/adminpending.dart';
import 'package:hos/veiw/userscreen/screen/profile/profile.dart';

class Adminhome extends GetxController with GetSingleTickerProviderStateMixin {
  // ─────────────────────────── State ───────────────────────────
  Statusrequest statusrequest = Statusrequest.none;
  String? errorMessage;

  // ──────────────── Data Objects ──────────────────────────────
  Map<String, dynamic> overviewData = {};
  List<RevenueChartModel> chartData = [];
  Map<String, dynamic> detailsData = {};

  // ─────────────────── Navigation / Pages ──────────────────────
  int currentpage = 0;
  late PageController controller;

  // ───────────────────── Chart Filter ──────────────────────────
  // 0 -> weekly | 1 -> monthly
  int selectedtime = 0;
  bool isChartLoading = false;

  // ─────────────────── Animation (BottomBar) ───────────────────
  late AnimationController animatedContainer;

  // ─────────────────────── Services ────────────────────────────
  final Dashboarddata _data = Get.put(Dashboarddata(Get.find()));
  final TextEditingController searchcontroller = TextEditingController();

  // ─────────────────── Static Data ─────────────────────────────
  final List<Widget> pages = [
    const Adminhomedashboard(),
    const ViewCategories(),
    const Adminpending(),

    ProfilePage(),
  ];

   List<List<dynamic>> get title => [
    ["Dashboard".tr, Imageasset.homesvg],
    ["Orders".tr, Imageasset.cart],
    ["Categories".tr, Imageasset.category],
    ["Profile".tr, Imageasset.profile],
  ];

  // ─────────────────────── Getters ─────────────────────────────

  /// استخراج نقاط الـ LineChart للرسم البياني بأمان
  List<FlSpot> get salesSpots {
    return chartData.asMap().entries.map((entry) {
      return FlSpot(entry.key.toDouble() + 1, entry.value.total);
    }).toList();
  }

  bool get isLoading => statusrequest == Statusrequest.loading;

  // ────────────────────── API Calls ─────────────────────────────

  /// جلب كافة البيانات عند فتح الشاشة أو التحديث (Pull to refresh)
  Future<void> getdashboardapi({bool isRefresh = false}) async {
    statusrequest = Statusrequest.loading;
    errorMessage = null;
    update();

    try {
      final results = await Future.wait([
        _data.getOverview(isRefresh: isRefresh),
        _data.getChartData(period: 'monthly', isRefresh: isRefresh),
        _data.getDetails(isRefresh: isRefresh),
      ]);

      final overviewRes = results[0];
      final chartRes = results[1];
      final detailsRes = results[2];

      final overviewStatus = handling(overviewRes);

      if (overviewStatus != Statusrequest.success) {
        statusrequest = overviewStatus;
        update();
        return;
      }

      if (overviewRes['status'] == true) {
        overviewData = Map<String, dynamic>.from(overviewRes['data'] ?? {});
      }

      // chart
      if (chartRes is List<RevenueChartModel>) {
        chartData = chartRes;
      }

      if (detailsRes['status'] == true) {
        detailsData = Map<String, dynamic>.from(detailsRes['data'] ?? {});
      }

      statusrequest = Statusrequest.success;
    } catch (e, stack) {
      debugPrint('getdashboardapi error: $e\n$stack');

      statusrequest = Statusrequest.serverfailure;
    }

    update();
  }

  /// تغيير فلترة الرسم البياني (أسبوعي / شهري)
  Future<void> changetime(int index) async {
    if (selectedtime == index) return;

    selectedtime = index;
    isChartLoading = true;
    update();

    final period = selectedtime == 0 ? 'monthly' : 'yearly';

    try {
      chartData = await _data.getChartData(period: period);
    } catch (e) {
      debugPrint('Error updating chart time: $e');
    }

    isChartLoading = false;
    update();
  }

  // ───────────────────── Navigation ────────────────────────────
  void changePage(int index) {
    if (currentpage == index) return;
    currentpage = index;
    controller.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
    update();
  }

  void onpagechanged(int index) {
    if (currentpage == index) return;
    currentpage = index;
    update();
  }

  // ──────────────────── Lifecycle ──────────────────────────────
  @override
  void onInit() {
    super.onInit();
    controller = PageController(initialPage: currentpage);
    animatedContainer = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    getdashboardapi();
  }

  @override
  void onClose() {
    controller.dispose();
    animatedContainer.dispose();
    searchcontroller.dispose();
    super.onClose();
  }
}
