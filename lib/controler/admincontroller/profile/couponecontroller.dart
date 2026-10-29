// المسار المقترح: lib/controler/admincontroller/coupon/couponscontroller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hos/data/services/crud.dart';
import 'package:hos/core/functions/handlingdata.dart';
import 'package:hos/data/datasource/admindata/addcoupondata.dart';
import 'package:hos/data/model/coupone_model.dart';

class CouponsController extends GetxController {
  AdminCouponData data = AdminCouponData(Get.find());

  final search = TextEditingController();

  Statusrequest statusrequest = Statusrequest.loading;
  List<CouponModel> coupons = [];

  /// الفلاتر بالترتيب اللي بتظهر بيه في الـ ChipsBar
  static const filterKeys = ['all', 'active', 'inactive', 'expired'];
  int filterIndex = 0;

  /// ids الكوبونات اللي عليها طلب شغال (لمنع الضغط المتكرر)
  final Set<int> busyIds = {};

  @override
  void onInit() {
    load();
    super.onInit();
  }

  bool _ok(dynamic response, Statusrequest st) =>
      st == Statusrequest.success &&
      response is Map &&
      response['status'] == true;

  Future<void> load({bool silent = false}) async {
    if (!silent) {
      statusrequest = Statusrequest.loading;
      update();
    }

    final response = await data.getCoupons();
    statusrequest = handling(response);

    if (_ok(response, statusrequest)) {
      final list = (response['data'] as List?) ?? [];
      coupons = list
          .map((e) => CouponModel.fromJson(Map<String, dynamic>.from(e)))
          .toList();
    } else if (statusrequest == Statusrequest.success) {
      // الـ API رد بـ status:false → نعتبره خطأ سيرفر عشان يظهر زرار Try again
      statusrequest = Statusrequest.serverfailure;
    }
    update();
  }

  Future<void> refreshList() => load(silent: true);

  /// الحالة اللي بتتعرض فعلاً: التحميل نجح بس مفيش نتائج → nodata
  Statusrequest get viewStatus =>
      statusrequest == Statusrequest.success && visible.isEmpty
      ? Statusrequest.nodata
      : statusrequest;

  // ------------------------------------------------------------- filtering

  bool _matches(CouponModel c, String key) {
    switch (key) {
      case 'active':
        return c.status == CouponStatus.active;
      case 'inactive':
        return c.status == CouponStatus.inactive;
      case 'expired':
        return c.status == CouponStatus.expired ||
            c.status == CouponStatus.usedUp;
      default:
        return true;
    }
  }

  int countOf(String key) => coupons.where((c) => _matches(c, key)).length;

  List<CouponModel> get visible {
    final key = filterKeys[filterIndex];
    final q = search.text.trim().toLowerCase();
    return coupons
        .where((c) => _matches(c, key))
        .where((c) => q.isEmpty || c.code.toLowerCase().contains(q))
        .toList();
  }

  void changeFilter(int i) {
    filterIndex = i;
    update();
  }

  void onSearch(String _) => update();

  void clearSearch() {
    search.clear();
    update();
  }

  // --------------------------------------------------------------- actions

  Future<void> toggle(CouponModel c, bool value) async {
    if (busyIds.contains(c.id)) return;

    busyIds.add(c.id);
    c.isActive = value; // optimistic: الشاشة تتغير فوراً
    update();

    final response = await data.toggleCoupon(c.id.toString(), value);
    final st = handling(response);

    if (!_ok(response, st)) {
      c.isActive = !value; // نرجّع القيمة القديمة لو فشل
      Get.snackbar(
        "Error".tr,
        "Something went wrong".tr,
        snackPosition: SnackPosition.BOTTOM,
      );
    }

    busyIds.remove(c.id);
    update();
  }

  Future<void> delete(CouponModel c) async {
    if (busyIds.contains(c.id)) return;

    busyIds.add(c.id);
    update();

    final response = await data.deleteCoupon(c.id.toString());
    final st = handling(response);

    busyIds.remove(c.id);

    if (_ok(response, st)) {
      coupons.removeWhere((e) => e.id == c.id);
      Get.snackbar(
        "Success".tr,
        "Coupon deleted".tr,
        snackPosition: SnackPosition.BOTTOM,
      );
    } else {
      Get.snackbar(
        "Error".tr,
        "Something went wrong".tr,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
    update();
  }

  @override
  void onClose() {
    search.dispose();
    super.onClose();
  }
}