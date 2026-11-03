// المسار المقترح: lib/controler/admincontroller/brand/adminbrandformcontroller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hos/core/functions/handlingdata.dart';
import 'package:hos/data/datasource/admindata/branddata.dart';
import 'package:hos/data/model/admincatedoryoption.dart';
import 'package:hos/data/model/brandmodel.dart';

import 'package:hos/data/services/crud.dart';

/// فورم واحد للإضافة والتعديل:
/// لو اتبعت arguments: {'brand': AdminBrandModel} يبقى تعديل، غير كده إضافة.
class AdminBrandFormController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final name = TextEditingController();

  AdminBrandData data = AdminBrandData(Get.find());

  AdminBrandModel? brand;

  /// حالة الإرسال (بتتعرض على الزرار)
  Statusrequest statusrequest = Statusrequest.none;

  /// حالة تحميل قائمة الأقسام (بتتعرض بـ HandlingDataView)
  Statusrequest categoriesStatus = Statusrequest.loading;

  List<AdminCategoryOption> categories = [];
  final Set<int> selected = {};
  bool showCategoryError = false;

  bool get isEdit => brand != null;

  bool get allSelected =>
      categories.isNotEmpty && categories.every((c) => selected.contains(c.id));

  @override
  void onInit() {
    final args = Get.arguments;
    if (args is Map && args['brand'] is AdminBrandModel) {
      brand = args['brand'] as AdminBrandModel;
      name.text = brand!.name;
      selected.addAll(brand!.categoryIds);
    }
    loadCategories();
    super.onInit();
  }

  Future<void> loadCategories() async {
    categoriesStatus = Statusrequest.loading;
    update();

    final response = await data.getCategories();
    categoriesStatus = handling(response);

    if (categoriesStatus == Statusrequest.success &&
        response is Map &&
        response['status'] == true) {
      final list = (response['data'] as List?) ?? [];
      categories = list
          .map((e) => AdminCategoryOption.fromJson(Map<String, dynamic>.from(e)))
          .toList();

      // مفيش أقسام أصلاً: HandlingDataView يعرض رسالة الفراغ
      if (categories.isEmpty) categoriesStatus = Statusrequest.nodata;
    } else if (categoriesStatus == Statusrequest.success) {
      categoriesStatus = Statusrequest.serverfailure;
    }
    update();
  }

  void toggleCategory(int id) {
    if (!selected.add(id)) selected.remove(id);
    showCategoryError = false;
    update();
  }

  void toggleAll() {
    if (allSelected) {
      selected.clear();
    } else {
      selected.addAll(categories.map((c) => c.id));
    }
    showCategoryError = false;
    update();
  }

  bool _sameSelection() {
    final old = brand?.categoryIds.toSet() ?? <int>{};
    return old.length == selected.length && old.containsAll(selected);
  }

  Future<void> submit() async {
    if (statusrequest == Statusrequest.loading) return;

    final nameOk = formKey.currentState!.validate();

    // لازم قسم واحد على الأقل، عشان البراند يظهر في فلتر الأقسام
    if (selected.isEmpty) {
      showCategoryError = true;
      update();
    }
    if (!nameOk || selected.isEmpty) return;

    final value = name.text.trim();

    // مفيش تغيير → نرجع من غير طلب
    if (isEdit && value == brand!.name && _sameSelection()) {
      Get.back();
      return;
    }

    final ids = selected.toList()..sort();

    statusrequest = Statusrequest.loading;
    update();

    final response = isEdit
        ? await data.updateBrand(brand!.id.toString(), value, ids)
        : await data.addBrand(value, ids);

    statusrequest = handling(response);

    if (Statusrequest.success == statusrequest &&
        response is Map &&
        response['status'] == true) {
      Get.back(result: true);
      Get.snackbar(
        "Success".tr,
        isEdit
            ? "Brand updated successfully".tr
            : "Brand added successfully".tr,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    // فشل: نعرض رسالة الباك إند لو موجودة (مثلاً: الاسم مستخدم)
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
    name.dispose();
    super.onClose();
  }
}