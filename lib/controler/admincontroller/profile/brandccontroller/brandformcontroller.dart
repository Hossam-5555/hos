// المسار المقترح: lib/controler/admincontroller/brand/adminbrandformcontroller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hos/core/class/crud.dart';
import 'package:hos/core/functions/handlingdata.dart';
import 'package:hos/data/datasource/admindata/branddata.dart';
import 'package:hos/data/model/brandmodel.dart';


/// فورم واحد للإضافة والتعديل:
/// لو اتبعت arguments: {'brand': AdminBrandModel} يبقى تعديل، غير كده إضافة.
class AdminBrandFormController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final name = TextEditingController();

  AdminBrandData data = AdminBrandData(Get.find());

  AdminBrandModel? brand;
  Statusrequest statusrequest = Statusrequest.none;

  bool get isEdit => brand != null;

  @override
  void onInit() {
    final args = Get.arguments;
    if (args is Map && args['brand'] is AdminBrandModel) {
      brand = args['brand'] as AdminBrandModel;
      name.text = brand!.name;
    }
    super.onInit();
  }

  Future<void> submit() async {
    if (statusrequest == Statusrequest.loading) return;
    if (!formKey.currentState!.validate()) return;

    final value = name.text.trim();

    // مفيش تغيير → نرجع من غير طلب
    if (isEdit && value == brand!.name) {
      Get.back();
      return;
    }

    statusrequest = Statusrequest.loading;
    update();

    final response = isEdit
        ? await data.updateBrand(brand!.id.toString(), value)
        : await data.addBrand(value);

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