import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hos/core/class/crud.dart';
import 'package:hos/core/functions/handlingdata.dart';
import 'package:hos/data/datasource/admindata/addcoupondata.dart';

class AddCouponController extends GetxController {
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
  Statusrequest statusrequest = Statusrequest.none;

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
    code.text = List.generate(
      8,
      (_) => chars[rnd.nextInt(chars.length)],
    ).join();
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
