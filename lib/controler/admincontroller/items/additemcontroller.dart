import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart'; // 👈 تأكد من وجود هذا الإنبورت لاختيار الصور المتعددة
import 'package:hos/controler/admincontroller/items/viewitemcontroller.dart';
import 'package:hos/core/class/crud.dart';
import 'package:hos/core/functions/handlingdata.dart';
import 'package:hos/core/functions/snackbar.dart';
import 'package:hos/core/functions/upload_image.dart';
import 'package:hos/data/datasource/admindata/itemdata.dart';

class Additemcontroller extends GetxController {
  Statusrequest statusrequest = Statusrequest.none;
  Admindataitem dataitem = Admindataitem(Get.find());
  late TextEditingController name;
  late TextEditingController namear;
  late TextEditingController description;
  late TextEditingController descriptionar;
  late TextEditingController count;
  late TextEditingController price;
  late TextEditingController descount;
  late TextEditingController itemcat;
  int active = 1;
  GlobalKey<FormState> itemvalidKey = GlobalKey<FormState>();
  File? file;

  final ImagePicker _picker = ImagePicker(); // 👈 كائن اختيار الصور

  // مصفوفة الصور ثابتة الحجم (3 صور كحد أقصى) لكي لا يتأثر كود الـ additem الخاص بك
  List<File?> selectedImages = List<File?>.filled(3, null);

  /// 👈 الدالة الجديدة التي ستقوم باستدعائها من زر الواجهة الجديد
  Future<void> pickMultipleImagesFromGallery() async {
    try {
      // تفتح معرض الهاتف وتسمح للمستخدم بتحديد عدة صور دفعة واحدة
      // ignore: unnecessary_nullable_for_final_variable_declarations
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

  // دالة لحذف صورة معينة من الواجهة عند الضغط على زر X
  void removeImage(int index) {
    selectedImages[index] = null;
    update();
  }

  // 🛑 ملاحظة: تركت لك الدوال القديمة لربما تحتاجها في مكان آخر (أو يمكنك حذفها)
  void showoptionimage() {
    showImagePickerBottomSheet(
      chooseFromCamera as VoidCallback,
      chooseFromGallery as VoidCallback,
    );
  }

  Future<void> chooseFromCamera(int index) async {
    File? file = await imageUploadCamera();
    if (file != null) {
      selectedImages[index] = file;
      update();
    }
  }

  Future<void> chooseFromGallery(int index) async {
    File? file = await fileUploadGallery();
    if (file != null) {
      selectedImages[index] = file;
      update();
    }
  }

  Future<void> additem() async {
    if (itemvalidKey.currentState!.validate()) {
      // التأكد من اختيار الصورة الرئيسية (المربع الأول) أولاً
      if (selectedImages[0] == null) {
        Get.snackbar("تنبيه", "من فضلك اختر الصورة الرئيسية للمنتج (أول صورة)");
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
        "category_id": itemcat.text,
      };

      // يتم إرسال لستة الصور كالمعتاد دون أي تغيير في الـ Data Layer أو الباك إند
      var response = await dataitem.additem(data, selectedImages);
      statusrequest = handling(response);

      if (statusrequest == Statusrequest.success) {
        if (response['status'] == true) {
          showSnackBar(
            Get.context!,
            "Product Added Successfully",
            Icon(Icons.check,color: Colors.green,),
          );

          selectedImages = List<File?>.filled(3, null);

          Get.find<ViewItemController>().viewCategoryItems(
            Get.arguments["catid"],
          );
          Future.delayed(const Duration(seconds: 1), () {
            Get.back();
          });
        } else {
          statusrequest = Statusrequest.failure;
          Get.snackbar("فشل", response['message'] ?? "لم يتم حفظ المنتج");
        }
      } else {
        statusrequest = Statusrequest.failure;
      }
      update();
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
