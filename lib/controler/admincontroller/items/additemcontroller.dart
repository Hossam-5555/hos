import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hos/data/services/crud.dart';
import 'package:hos/core/functions/handlingdata.dart';
import 'package:hos/core/functions/snackbar.dart';
import 'package:hos/data/datasource/admindata/itemdata.dart';
import 'package:hos/data/model/itemsmodel.dart';
import 'package:image_picker/image_picker.dart';

/// While empty, Edit mode shows a placeholder instead of the current image.
const String _itemsImagesBase = '';

class ItemFormController extends GetxController {
  ItemFormController({this.item, this.categoryId, this.categoryName});

  /// null => Add mode, non-null => Edit mode
  final ItemsModel? item;
  final Object? categoryId; // required in Add mode
  final String? categoryName;

  bool get isEdit => item != null;
  String get catId => (item?.categoryId ?? categoryId).toString();

  static const int maxImages = 3;

  final Admindataitem _data = Admindataitem(Get.find());
  final ImagePicker _picker = ImagePicker();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  late final TextEditingController name;
  late final TextEditingController namear;
  late final TextEditingController description;
  late final TextEditingController descriptionar;
  late final TextEditingController price;
  late final TextEditingController discount;

  Statusrequest statusrequest = Statusrequest.none;
  bool get isLoading => statusrequest == Statusrequest.loading;

  /// Newly picked images. Index 0 is always the main image.
  final List<File> images = [];
  int stock = 0;
  int active = 1;

  String? get existingImageUrl {
    final img = item?.itemsImage;
    if (img == null || img.toString().isEmpty || _itemsImagesBase.isEmpty) {
      return null;
    }
    return '$_itemsImagesBase/$img';
  }

  @override
  void onInit() {
    name = TextEditingController(text: item?.itemsName ?? '');
    namear = TextEditingController(text: item?.itemsNameAr ?? '');
    description = TextEditingController(text: item?.itemsDesc ?? '');
    descriptionar = TextEditingController(text: item?.itemsDescAr ?? '');
    price = TextEditingController(text: item?.itemsPrice?.toString() ?? '');
    discount =
        TextEditingController(text: item?.itemsDiscount?.toString() ?? '0');
    stock = int.tryParse('${item?.stock ?? 0}') ?? 0;
    active = item?.itemsActive ?? 1;
    super.onInit();
  }

  // ---------------- images ----------------
  Future<void> pickImages() async {
    final remaining = maxImages - images.length;
    if (remaining <= 0) {
      _snack('max_images_reached'.tr, Icons.info_outline);
      return;
    }
    try {
      final picked = await _picker.pickMultiImage(imageQuality: 80);
      if (picked.isEmpty) return;
      images.addAll(picked.take(remaining).map((x) => File(x.path)));
      update();
    } catch (_) {
      _snack('image_pick_error'.tr, Icons.error_outline);
    }
  }

  void removeImage(int index) {
    images.removeAt(index); // remaining images shift left, so [0] stays main
    update();
  }

  // ---------------- stock / status ----------------
  void incStock() {
    stock++;
    update();
  }

  void decStock() {
    if (stock > 0) {
      stock--;
      update();
    }
  }

  void toggleActive(bool v) {
    active = v ? 1 : 0;
    update();
  }

  // ---------------- validators ----------------
  String? requiredValidator(String? v) =>
      (v == null || v.trim().isEmpty) ? 'field_required'.tr : null;

  String? priceValidator(String? v) {
    if (v == null || v.trim().isEmpty) return 'field_required'.tr;
    final n = double.tryParse(v.trim());
    return (n == null || n <= 0) ? 'invalid_number'.tr : null;
  }

  String? discountValidator(String? v) {
    if (v == null || v.trim().isEmpty) return 'field_required'.tr;
    final n = double.tryParse(v.trim());
    return (n == null || n < 0 || n > 100) ? 'invalid_discount'.tr : null;
  }

  // ---------------- submit ----------------
  Future<void> submit() async {
    if (isLoading) return;
    if (!formKey.currentState!.validate()) return;

    if (!isEdit && images.isEmpty) {
      _snack('item_main_image_required'.tr, Icons.image_search_rounded);
      return;
    }

    statusrequest = Statusrequest.loading;
    update();

    final data = {
      "items_name": name.text.trim(),
      "items_name_ar": namear.text.trim(),
      "items_desc": description.text.trim(),
      "items_desc_ar": descriptionar.text.trim(),
      "items_active": active.toString(),
      "stock": stock.toString(),
      "items_price": price.text.trim(),
      "items_discount": discount.text.trim(),
      "category_id": catId,
    };

    try {
      final response = isEdit
          // edititem accepts a single file => we send the main image
          ? await _data.edititem(
              data,
              images.isEmpty ? null : images.first,
              item!.id!,
            )
          // additem expects a fixed list of 3 slots
          : await _data.additem(
              data,
              List<File?>.generate(
                maxImages,
                (i) => i < images.length ? images[i] : null,
              ),
            );

      statusrequest = handling(response);

      if (statusrequest == Statusrequest.success &&
          response['status'] == true) {
        _snack(
          (isEdit ? 'item_updated_success' : 'item_added_success').tr,
          Icons.check_circle,
        );
        update();
        await Future.delayed(const Duration(milliseconds: 600));
        Get.back(result: true); // the list page refreshes on `true`
        return;
      }
      statusrequest = Statusrequest.failure;
      _snack(
        (response is Map ? response['message'] : null)?.toString() ??
            'something_went_wrong'.tr,
        Icons.error_outline,
      );
    } catch (_) {
      statusrequest = Statusrequest.failure;
      _snack('something_went_wrong'.tr, Icons.error_outline);
    }
    update();
  }

  void _snack(String msg, IconData icon) =>
      showSnackBar(Get.context!, msg, Icon(icon));

  @override
  void onClose() {
    name.dispose();
    namear.dispose();
    description.dispose();
    descriptionar.dispose();
    price.dispose();
    discount.dispose();
    super.onClose();
  }
}