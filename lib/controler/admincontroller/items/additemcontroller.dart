import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:hos/controler/admincontroller/items/viewitemcontroller.dart';
import 'package:hos/core/class/crud.dart';
import 'package:hos/core/functions/handlingdata.dart';
import 'package:hos/core/functions/snackbar.dart';
import 'package:hos/core/functions/upload_image.dart';
import 'package:hos/data/datasource/admindata/itemdata.dart';

class Additemcontroller extends GetxController {
  Statusrequest statusrequest = Statusrequest.none;
  admindataitem dataitem = admindataitem(Get.find());
  late TextEditingController name;
  late TextEditingController namear;
  late TextEditingController description;
  late TextEditingController descriptionar;
  late TextEditingController count;
  late TextEditingController price;
  late TextEditingController descount;
  late TextEditingController itemcat;

  GlobalKey<FormState> itemvalidKey = GlobalKey<FormState>();
  File? file;

  void showoptionimage() {
    showImagePickerBottomSheet(
      chooseFromCamera as VoidCallback,
      chooseFromGallery as VoidCallback,
    );
  }

  List<File?> selectedImages = List<File?>.filled(3, null);

  // دالة التعامل مع اختيار الكاميرا للمربع المحدد
  Future<void> chooseFromCamera(int index) async {
    File? file = await imageUploadCamera(); // دالتك الجاهزة
    if (file != null) {
      selectedImages[index] = file;
      update(); // تحديث الواجهة فوراً
    }
  }

  // دالة التعامل مع اختيار المعرض للمربع المحدد
  Future<void> chooseFromGallery(int index) async {
    File? file = await fileUploadGallery(); // دالتك الجاهزة
    if (file != null) {
      selectedImages[index] = file;
      update(); // تحديث الواجهة فوراً
    }
  }

  // دالة لحذف الصورة من المربع
  void removeImage(int index) {
    selectedImages[index] = null;
    update();
  }

  Future<void> additem() async {
    if (itemvalidKey.currentState!.validate()) {
      // 1. 🛑 التعديل هنا: التأكد من اختيار الصورة الرئيسية (المربع الأول) أولاً
      if (selectedImages[0] == null) {
        Get.snackbar(
          "تنبيه",
          "من فضلك اختر الصورة الرئيسية للمنتج (المربع الأول)",
        );
        return;
      }

      statusrequest = Statusrequest.loading;
      update();

      Map data = {
        "items_name": name.text,
        "items_name_ar": namear.text,
        "items_desc": description.text,
        "items_desc_ar": descriptionar.text,
        "items_active": "1",
        "stock": count.text,
        "items_price": price.text,
        "items_discount": descount.text,
        "category_id": itemcat
            .text, // ملحوظة: شيلت المسافة الزيادة اللي كانت بعد كلمة category_id لضمان مطابقة الباك إند
      };

      // 2. 🚀 استدعاء دالة الـ Data Layer وتمرير لستة الصور كاملة
      var response = await dataitem.additem(data, selectedImages);
      statusrequest = handling(response);

      if (statusrequest == Statusrequest.success) {
        // ملحوظة: اللارافل عادة بيرجع الكود في ماب، التشييك بتاعك سليم
        if (response['status'] == true) {
          showSnackBar(Get.context!, "Product Added Successfully");

          // إعادة تهيئة مصفوفة الصور لتصبح فارغة بعد النجاح استعداداً لإضافة منتج آخر
          selectedImages = List<File?>.filled(3, null);

          Get.find<ViewItemController>().viewCategoryItems(Get.arguments["catid"]);
          Future.delayed(Duration(seconds: 1), () {
            Get.back(); // الرجوع بعد ثواني قليلة لإظهار الـ Snackbar
          });
        } else {
          // لو الباك إند رجع status false لسبب ما (مثلاً مشكلة validation في اللارافل)
          statusrequest = Statusrequest.failure;
          Get.snackbar("فشل", response['message'] ?? "لم يتم حفظ المنتج");
        }
      } else {
        statusrequest = Statusrequest.failure;
      }
      update(); // لتحديث حالة الـ UI وإخفاء الـ Loading
    }
  }

String? catname;
  @override
  void onInit() {
    name = TextEditingController();
    namear = TextEditingController();
    description = TextEditingController();
    descriptionar = TextEditingController();
    count = TextEditingController();
    price = TextEditingController();
    descount = TextEditingController();
    itemcat = TextEditingController();
    itemcat.text = Get.arguments["catid"].toString();
    catname = Get.arguments["catname"];
    super.onInit();
  }

  @override
  void onClose() {
    name.dispose();
    namear.dispose();
    description.dispose();
    descriptionar.dispose();
    count.dispose();
    price.dispose();
    descount.dispose();
    itemcat.dispose();
    super.onClose();
  }
}
