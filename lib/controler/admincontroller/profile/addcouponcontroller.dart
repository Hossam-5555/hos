// المسار المقترح: lib/controler/admincontroller/coupon/addcouponcontroller.dart
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hos/core/class/crud.dart';
import 'package:hos/core/functions/handlingdata.dart';
import 'package:hos/data/datasource/admindata/addcoupondata.dart';
import 'package:hos/data/model/coupone_model.dart';

class AddCouponController extends GetxController {
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
    // load();
    super.onInit();
  }
 
  // bool _ok(dynamic response, Statusrequest st) =>
  //     st == Statusrequest.success &&
  //     response is Map &&
  //     response['status'] == true;
 
  // Future<void> load({bool silent = false}) async {
  //   if (!silent) {
  //     statusrequest = Statusrequest.loading;
  //     update();
  //   }
 
  //   final response = await data.getCoupons();
  //   statusrequest = handling(response);
 
  //   if (_ok(response, statusrequest)) {
  //     final list = (response['data'] as List?) ?? [];
  //     coupons = list
  //         .map((e) => CouponModel.fromJson(Map<String, dynamic>.from(e)))
  //         .toList();
  //   } else if (statusrequest == Statusrequest.success) {
  //     statusrequest = Statusrequest.failure;
  //   }
  //   update();
  // }
 
  // Future<void> refreshList() => load(silent: true);
 
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
 
  // Future<void> toggle(CouponModel c, bool value) async {
  //   if (busyIds.contains(c.id)) return;
 
  //   busyIds.add(c.id);
  //   c.isActive = value; // optimistic: الشاشة تتغير فوراً
  //   update();
 
  //   final response = await data.toggleCoupon(c.id.toString(), value);
  //   final st = handling(response);
 
  //   if (!_ok(response, st)) {
  //     c.isActive = !value; // نرجّع القيمة القديمة لو فشل
  //     Get.snackbar(
  //       "Error".tr,
  //       "Something went wrong".tr,
  //       snackPosition: SnackPosition.BOTTOM,
  //     );
  //   }
 
  //   busyIds.remove(c.id);
  //   update();
  // }
 
  // Future<void> delete(CouponModel c) async {
  //   if (busyIds.contains(c.id)) return;
 
  //   busyIds.add(c.id);
  //   update();
 
  //   final response = await data.deleteCoupon(c.id.toString());
  //   final st = handling(response);
 
  //   busyIds.remove(c.id);
 
  //   if (_ok(response, st)) {
  //     coupons.removeWhere((e) => e.id == c.id);
  //     Get.snackbar(
  //       "Success".tr,
  //       "Coupon deleted".tr,
  //       snackPosition: SnackPosition.BOTTOM,
  //     );
  //   } else {
  //     Get.snackbar(
  //       "Error".tr,
  //       "Something went wrong".tr,
  //       snackPosition: SnackPosition.BOTTOM,
  //     );
  //   }
  //   update();
  // }
  final formKey = GlobalKey<FormState>();

  final code = TextEditingController();
  final value = TextEditingController();
  final minOrder = TextEditingController();
  final maxDiscount = TextEditingController();
  final usageLimit = TextEditingController();

  AdminCouponData data = AdminCouponData(Get.find());

  /// 'percentage' أو 'fixed'
  String type = 'percentage';
  DateTime? expiresAt;
  bool isActive = true;

  bool get isPercentage => type == 'percentage';

  String get dateText => expiresAt == null ? '' : _fmt(expiresAt!);

  String _fmt(DateTime d) => d.toIso8601String().split('T').first;

  void changeType(String t) {
    type = t;
    if (!isPercentage) maxDiscount.clear();
    update();
  }

  void toggleActive(bool v) {
    isActive = v;
    update();
  }

  /// كود عشوائي من 8 حروف/أرقام (من غير الحروف المتشابهة زي O و 0)
  void generateCode() {
    const chars = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';
    final rnd = Random.secure();
    code.text = List.generate(8, (_) => chars[rnd.nextInt(chars.length)]).join();
    update();
  }

  Future<void> pickDate(BuildContext context) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: expiresAt ?? now.add(const Duration(days: 30)),
      firstDate: now,
      lastDate: now.add(const Duration(days: 365 * 5)),
    );
    if (picked != null) {
      expiresAt = picked;
      update();
    }
  }

  void clearDate() {
    expiresAt = null;
    update();
  }

  Future<void> submit() async {
    if (statusrequest == Statusrequest.loading) return;
    if (!formKey.currentState!.validate()) return;

    final payload = <String, String>{
      'code': code.text.trim().toUpperCase(),
      'type': type,
      'value': value.text.trim(),
      'is_active': isActive ? '1' : '0',
      if (minOrder.text.trim().isNotEmpty)
        'min_order_amount': minOrder.text.trim(),
      if (isPercentage && maxDiscount.text.trim().isNotEmpty)
        'max_discount': maxDiscount.text.trim(),
      if (usageLimit.text.trim().isNotEmpty)
        'usage_limit': usageLimit.text.trim(),
      if (expiresAt != null) 'expires_at': _fmt(expiresAt!),
    };

    statusrequest = Statusrequest.loading;
    update();

    final response = await data.addCoupon(payload);
    statusrequest = handling(response);

    if (Statusrequest.success == statusrequest &&
        response is Map &&
        response['status'] == true) {
      Get.back(result: true);
      Get.snackbar(
        "Success".tr,
        "Coupon added successfully".tr,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    // فشل: نعرض رسالة الباك إند لو موجودة (مثلاً: الكود مكرر)
    final message = (response is Map ? response['message'] : null)?.toString();
    Get.snackbar(
      "Error".tr,
      message ?? "Something went wrong".tr,
      snackPosition: SnackPosition.BOTTOM,
    );

    statusrequest = Statusrequest.none; // نرجّع الزرار لحالته الطبيعية
    update();
  }

  @override
  void onClose() {
    code.dispose();
    value.dispose();
    minOrder.dispose();
    maxDiscount.dispose();
    usageLimit.dispose();
    super.onClose();
  }
}