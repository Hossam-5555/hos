import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:hos/core/class/crud.dart';
import 'package:hos/core/functions/handlingdata.dart';
import 'package:hos/core/functions/upload_image.dart';
import 'package:hos/data/datasource/admindata/itemdata.dart';
import 'package:hos/veiw/adminscreen/Home/categories/viewcat.dart';

class Additemcontroller extends GetxController {
  Statusrequest statusrequest = Statusrequest.none;
  admindataitem dataitem = admindataitem(Get.find());
  late TextEditingController name;
  late TextEditingController namear;
  GlobalKey<FormState> validkey = GlobalKey<FormState>();
  File? file;

  showoptionimage() {
    showImagePickerBottomSheet(file!);
    update();
  }

  addcategories() async {
    if (validkey.currentState!.validate()) {
      if (file == null) {
        Get.snackbar("تنبيه", "من فضلك اختر صورة أولاً");
        return;
      }

      statusrequest = Statusrequest.loading;
      update();

      var response = await dataitem.additem(
        name.text,
        namear.text,
        // file!, // دلوقتي آمن نستخدمها
      );

      statusrequest = handling(response);
      if (statusrequest == Statusrequest.success) {
        if (response['status'] == 'success') {
          Get.snackbar("success", "    تم اضافه القسم بنجاح");

          Get.off(() => ViewCategories());
        }
      } else {
        statusrequest = Statusrequest.failure;
      }
    }
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
