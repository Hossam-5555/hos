import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:hos/core/class/crud.dart';
import 'package:hos/core/functions/handlingdata.dart';
import 'package:hos/core/functions/snackbar.dart';
import 'package:hos/data/datasource/admindata/itemdata.dart';
import 'package:hos/data/model/itemsmodel.dart';
import 'package:image_picker/image_picker.dart';

class Edititemcontroller extends GetxController {
  Statusrequest statusrequest = Statusrequest.none;
  Admindataitem dataitem = Admindataitem(Get.find());
  int? itemid;
  int? active;
  String? imagename;
  late TextEditingController name;
  late TextEditingController namear;
  late TextEditingController description;
  late TextEditingController descriptionar;
  late TextEditingController count;
  late TextEditingController price;
  late TextEditingController descount;
  late TextEditingController itemcat;
  GlobalKey<FormState> editkey = GlobalKey<FormState>();
  File? file;
  ItemsModel? itemsmodel;

  final ImagePicker _picker = ImagePicker(); // 👈 كائن اختيار الصور

  // مصفوفة الصور ثابتة الحجم (3 صور كحد أقصى) لكي لا يتأثر كود الـ additem الخاص بك
  List<File?> selectedImages = List<File?>.filled(3, null);

  /// 👈 الدالة الجديدة التي ستقوم باستدعائها من زر الواجهة الجديد
  Future<void> pickMultipleImagesFromGallery() async {
    try {
      // تفتح معرض الهاتف وتسمح للمستخدم بتحديد عدة صور دفعة واحدة
      final List<XFile>? pickedFiles = await _picker.pickMultiImage(
        imageQuality: 80, // لتقليل الحجم والحفاظ على سرعة الرفع
      );

      if (pickedFiles != null && pickedFiles.isNotEmpty) {
        // تفريغ المصفوفة أولاً عند اختيار صور جديدة
        selectedImages = List<File?>.filled(3, null);

        // ملء المصفوفة بأول 3 صور اختارها المستخدم كحد أقصى
        for (int i = 0; i < pickedFiles.length && i < 3; i++) {
          selectedImages[i] = File(pickedFiles[i].path);
        }
        update(); // تحديث الواجهة (GetBuilder) لرؤية الصور فوراً
      }
    } catch (e) {
      Get.snackbar("خطأ", "حدث خطأ أثناء اختيار الصور: $e");
    }
  }

  // دالة التعامل مع اختيار الكاميرا للمربع المحدد

  Future<void> edit() async {
    if (!editkey.currentState!.validate()) return;

    statusrequest = Statusrequest.loading;
    update();
    Map data = {
      "items_name": name.text,
      "items_name_ar": namear.text,
      "items_desc": description.text,
      "items_desc_ar": descriptionar.text,
      "items_active": active,
      "stock": count.text,
      "items_price": price.text,
      "items_discount": descount.text,
      "category_id": itemcat
          .text, // ملحوظة: شيلت المسافة الزيادة اللي كانت بعد كلمة category_id لضمان مطابقة الباك إند
    };
    var response = await dataitem.edititem(data, file, itemid!);
    statusrequest = handling(response);
    if (statusrequest == Statusrequest.success && response['status'] == true) {
      showSnackBar(Get.context!, "saved succesfuly",Icon(Icons.edit,color: Colors.blue,));
      Get.back();
    } else {
      statusrequest = Statusrequest.failure;
    }

    update();
  }

  void removeImage(int index) {
    selectedImages[index] = null;
    update();
  }

  @override
  void onInit() {
    itemsmodel = Get.arguments['itemsmodel'];
    itemid = itemsmodel!.id;
    active = itemsmodel!.itemsActive;
    imagename = itemsmodel!.itemsImage;
    name = TextEditingController();
    namear = TextEditingController();
    description = TextEditingController();
    descriptionar = TextEditingController();
    count = TextEditingController();
    price = TextEditingController();
    descount = TextEditingController();
    itemcat = TextEditingController();
    name.text = itemsmodel!.itemsName!;
    namear.text = itemsmodel!.itemsNameAr!;
    description.text = itemsmodel!.itemsDesc!;
    descriptionar.text = itemsmodel!.itemsDescAr!;
    count.text = itemsmodel!.stock.toString();
    price.text = itemsmodel!.itemsPrice.toString();
    descount.text = itemsmodel!.itemsDiscount!.toString();
    itemcat.text = itemsmodel!.categoryId.toString();
    super.onInit();
  }

  @override
  void onClose() {
    name.dispose();
    namear.dispose();
    super.onClose();
  }
}
