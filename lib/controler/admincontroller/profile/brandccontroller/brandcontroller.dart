// المسار المقترح: lib/controler/admincontroller/brand/adminbrandscontroller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hos/core/functions/snackbar.dart';
import 'package:hos/data/services/crud.dart';
import 'package:hos/core/functions/handlingdata.dart';
import 'package:hos/data/datasource/admindata/branddata.dart';
import 'package:hos/data/model/brandmodel.dart';

class AdminBrandsController extends GetxController {
  AdminBrandData data = AdminBrandData(Get.find());

  final search = TextEditingController();

  Statusrequest statusrequest = Statusrequest.loading;
  List<AdminBrandModel> brands = [];

  /// ids البراندات اللي عليها طلب شغال (لمنع الضغط المتكرر)
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

  String? _message(dynamic response) =>
      (response is Map ? response['message'] : null)?.toString();

  Future<void> load({bool silent = false}) async {
    if (!silent) {
      statusrequest = Statusrequest.loading;
      update();
    }

    final response = await data.getBrands();
    statusrequest = handling(response);

    if (_ok(response, statusrequest)) {
      final list = (response['data'] as List?) ?? [];
      brands = list
          .map((e) => AdminBrandModel.fromJson(Map<String, dynamic>.from(e)))
          .toList();
    } else if (statusrequest == Statusrequest.success) {
      // الـ API رد بـ status:false → نعتبره خطأ سيرفر عشان يظهر زرار Try again
      statusrequest = Statusrequest.serverfailure;
    }
    update();
  }

  Future<void> refreshList() => load(silent: true);

  // ------------------------------------------------------------- search
  // البحث على الجهاز نفسه: عدد البراندات صغير فمفيش داعي لطلب جديد مع كل حرف

  List<AdminBrandModel> get visible {
    final q = search.text.trim().toLowerCase();
    if (q.isEmpty) return brands;
    return brands.where((b) => b.name.toLowerCase().contains(q)).toList();
  }

  /// الحالة اللي بتتعرض فعلاً: التحميل نجح بس مفيش نتائج → nodata
  Statusrequest get viewStatus =>
      statusrequest == Statusrequest.success && visible.isEmpty
      ? Statusrequest.nodata
      : statusrequest;

  void onSearch(String _) => update();

  void clearSearch() {
    search.clear();
    update();
  }

  // ------------------------------------------------------------- delete

  Future<void> delete(AdminBrandModel brand) async {
    if (busyIds.contains(brand.id)) return;

    busyIds.add(brand.id);
    update();

    final response = await data.deleteBrand(brand.id.toString());
    final st = handling(response);

    busyIds.remove(brand.id);

    if (_ok(response, st)) {
      brands.removeWhere((b) => b.id == brand.id);

      showSnackBar(
        Get.context!,
        "Success".tr,
        Icon(Icons.check, color: Colors.green),
      );
    } else {
      Get.snackbar(
        "Error".tr,
        _message(response) ?? "Something went wrong".tr,
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
