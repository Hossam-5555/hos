import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hos/controler/admincontroller/categories/viewcontroller.dart';
import 'package:hos/data/services/crud.dart';
import 'package:hos/core/functions/handlingdata.dart';
import 'package:hos/core/functions/snackbar.dart';
import 'package:hos/core/functions/upload_image.dart';
import 'package:hos/data/datasource/admindata/categoriesdata.dart';
import 'package:hos/data/model/categoriesmodel.dart';

class CategoryFormController extends GetxController {
  CategoryFormController(this.category);

  /// null => Add mode, non-null => Edit mode
  final CategoriesModel? category;
  bool get isEdit => category != null;

  final AdmindaTaCaregores _data = AdmindaTaCaregores(Get.find());
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  late final TextEditingController name;
  late final TextEditingController namear;
  late final TextEditingController description;

  Statusrequest statusrequest = Statusrequest.none;
  bool get isLoading => statusrequest == Statusrequest.loading;

  File? file;
  String? existingImageUrl; // image already on the server (Edit mode)
  bool isActive = true;

  @override
  void onInit() {
    name = TextEditingController(text: category?.name ?? '');
    namear = TextEditingController(text: category?.nameAr ?? '');
    description = TextEditingController();

    if (isEdit) {
      // (nullable) to CategoriesModel if the backend supports them.
      // description.text = category!.description ?? '';
      // isActive = category!.active == 1;
      // existingImageUrl = '${AppLink.categoriesImages}/${category!.image}';
    }
    super.onInit();
  }

  Future<void> chooseImage() async {
    final picked = await fileUploadGallery();
    if (picked != null) {
      file = picked;
      update();
    }
  }

  void toggleActive(bool v) {
    isActive = v;
    update();
  }

  String? requiredValidator(String? v) =>
      (v == null || v.trim().isEmpty) ? 'field_required'.tr : null;

  Future<void> submit() async {
    if (isLoading) return;
    if (!formKey.currentState!.validate()) return;

    if (!isEdit && file == null) {
      showSnackBar(
        Get.context!,
        'image_required'.tr,
        const Icon(Icons.image_search_rounded),
      );
      return;
    }

    statusrequest = Statusrequest.loading;
    update();

    try {
      // NOTE: `description` / `isActive` are new optional named params —
      // add them to addcat/editcat in the datasource and send them to the API.
      final response = isEdit
          ? await _data.editcat(
              category!.id!,
              name.text.trim(),
              namear.text.trim(),
              file,
              // description: description.text.trim(),
              // isActive: isActive,
            )
          : await _data.addcat(
              name.text.trim(),
              namear.text.trim(),
              file!,
              // description: description.text.trim(),
              // isActive: isActive,
            );

      statusrequest = handling(response);
      if (statusrequest == Statusrequest.success &&
          response['status'] == true) {
        showSnackBar(
          Get.context!,
          (isEdit ? 'updated_success' : 'added_success').tr,
          const Icon(Icons.check_circle),
        );
        Get.find<ViewCatController>().viewCat();
        update();
        await Future.delayed(const Duration(milliseconds: 600));
        Get.back();
        return;
      }
      statusrequest = Statusrequest.failure;
    } catch (_) {
      statusrequest = Statusrequest.failure;
    }

    showSnackBar(
      Get.context!,
      'something_went_wrong'.tr,
      const Icon(Icons.error_outline),
    );
    update();
  }

  @override
  void onClose() {
    name.dispose();
    namear.dispose();
    description.dispose();
    super.onClose();
  }
}