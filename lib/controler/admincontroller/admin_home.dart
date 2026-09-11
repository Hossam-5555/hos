import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hos/core/class/crud.dart';
import 'package:hos/core/conistant/imageasset.dart';
import 'package:hos/core/functions/handlingdata.dart';
import 'package:hos/data/datasource/admindata/dashboarddata.dart';
import 'package:hos/data/model/dashboardmodel.dart';
import 'package:hos/veiw/adminscreen/Home/AdminHome.dart';
import 'package:hos/veiw/adminscreen/Home/categories/viewcat.dart';
import 'package:hos/veiw/adminscreen/Home/orders/adminpending.dart';
import 'package:hos/veiw/userscreen/screen/profile/profile.dart';

class Adminhome extends GetxController with GetSingleTickerProviderStateMixin {
  // ─────────────────────────── State ───────────────────────────
  Statusrequest statusrequest = Statusrequest.none;
  List<DashboardResponse> apidata = [];
  String? errorMessage;

  // ─────────────────── Navigation / Pages ──────────────────────
  int currentpage = 0;
  late PageController controller;

  // ───────────────────── Chart Filter ──────────────────────────
  int selectedtime = 0;

  // ─────────────────── Animation (BottomBar) ───────────────────
  late AnimationController animatedContainer;

  // ─────────────────────── Services ────────────────────────────
  final Dashboarddata _data = Get.put(Dashboarddata(Get.find()));
  final TextEditingController searchcontroller = TextEditingController();

  // ─────────────────── Static Data ─────────────────────────────
  final List<Widget> pages = [
    Adminhomedashboard(),
    Adminpending(),
    ViewCategories(),
    ProfilePage(),
  ];

  final List<List<dynamic>> title = [
    ["Dashboard", Imageasset.homesvg],
    ["Orders", Imageasset.cart],
    ["Categories", Imageasset.category],
    ["Profile", Imageasset.profile],
  ];

  // ─────────────────────── Getters ─────────────────────────────

  /// بيرجع نقاط الـ LineChart من بيانات الـ API.
  /// لو الـ apidata فاضية أو مفيش chart data يرجع قائمة فاضية بأمان
  /// بدل ما يكرش بـ RangeError.
  List<FlSpot> get salesSpots {
    if (apidata.isEmpty) return [];

    final chartData = apidata[0].salesChart;
    if (chartData.isEmpty) return [];

    final List<FlSpot> spots = [];
    for (int i = 0; i < chartData.length; i++) {
      final rawTotal = chartData[i].total;
      // تجاهل أي نقطة فيها قيمة null أو مش رقم صالح
      final double? y = double.tryParse(rawTotal ?? '');
      if (y != null) {
        spots.add(FlSpot(i.toDouble(), y));
      }
    }
    return spots;
  }

  /// true لما الصفحة في حالة loading أو لما الـ apidata لسه فاضية
  bool get isLoading =>
      statusrequest == Statusrequest.loading || apidata.isEmpty;

  // ────────────────────── API Call ─────────────────────────────
  Future<void> getdashboardapi() async {
    statusrequest = Statusrequest.loading;
    errorMessage = null;
    update();

    try {
      final response = await _data.getdata();
      final handledStatus = handling(response);

      // فشل شبكة أو سيرفر
      if (handledStatus != Statusrequest.success) {
        statusrequest = handledStatus;
        update();
        return;
      }

      // فشل من جهة الـ API نفسه
      if (response['status'] != true || response['data'] == null) {
        statusrequest = Statusrequest.failure;
        errorMessage = response['message'] ?? 'Something went wrong';
        update();
        return;
      }

      // نجح — نمسح القديم ونحط الجديد
      apidata
        ..clear()
        ..add(DashboardResponse.fromJson(response['data']));

      statusrequest = Statusrequest.success;
    } catch (e, stack) {
      debugPrint('getdashboardapi error: $e\n$stack');
      statusrequest = Statusrequest.serverfailure;
    }

    update();
  }

  // ───────────────────── Navigation ────────────────────────────
  void changePage(int index) {
    if (currentpage == index) return; // تجنب إعادة البناء لو نفس الصفحة
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

  // ─────────────────── Chart Filter ────────────────────────────
  void changetime(int i) {
    if (selectedtime == i) return; // تجنب إعادة البناء لو نفس الفلتر
    selectedtime = i;
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
