import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:hos/controler/admincontroller/categories/viewcontroller.dart';
import 'package:hos/core/class/crud.dart';
import 'package:hos/core/functions/handlingdata.dart';
import 'package:hos/core/functions/snackbar.dart';
import 'package:hos/core/functions/upload_image.dart';
import 'package:hos/data/datasource/admindata/categoriesdata.dart';

class Addcatcontroller extends GetxController {
  Statusrequest statusrequest = Statusrequest.none;
  AdmindaTaCaregores admindaTaCaregores = AdmindaTaCaregores(Get.find());
  late TextEditingController name;
  late TextEditingController namear;
  GlobalKey<FormState> validkey = GlobalKey<FormState>();
  File? file;

  Future<void> chooseimage() async {
    file = await fileUploadGallery();
    update();
  }

  Future<void> addcategories() async {
    if (validkey.currentState!.validate()) {
      if (file == null) {
        showSnackBar(
          Get.context!,
          "من فضلك اختر صورة أولاً",
          Icon(Icons.image_search_rounded),
        );
        return;
      }

      statusrequest = Statusrequest.loading;
      update();

      var response = await admindaTaCaregores.addcat(
        name.text,
        namear.text,
        file!, // دلوقتي آمن نستخدمها
      );

      statusrequest = handling(response);
      if (statusrequest == Statusrequest.success) {
        if (response['status'] == true) {
          showSnackBar(
            Get.context!,
            "تم إضافة الفئة بنجاح",
            Icon(Icons.check_circle),
          );
          Get.find<ViewCatController>().viewCat();

          Future.delayed(Duration(seconds: 1), () {
            Get.back(); // ارجع بعد ثانية
          });
        }
      } else {
        statusrequest = Statusrequest.failure;
      }
    }
    update();
  }

  @override
  void onInit() {
    name = TextEditingController();
    namear = TextEditingController();
    super.onInit();
  }

  @override
  void onClose() {
    name.dispose();
    namear.dispose();
    super.onClose();
  }
}
