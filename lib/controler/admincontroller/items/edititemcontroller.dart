import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:hos/core/class/crud.dart';
import 'package:hos/core/functions/handlingdata.dart';
import 'package:hos/core/functions/upload_image.dart';
import 'package:hos/data/datasource/admindata/categoriesdata.dart';
import 'package:hos/data/model/categoriesmodel.dart';
import 'package:hos/veiw/adminscreen/Home/categories/viewcat.dart';

class Editcontroller extends GetxController {
  Statusrequest statusrequest = Statusrequest.none;
  AdmindaTaCaregores admindaTaCaregores = AdmindaTaCaregores(Get.find());
  late TextEditingController name;
  late TextEditingController namear;
  GlobalKey<FormState> editkey = GlobalKey<FormState>();
  File? file;
  categoriesmodel? catmodel;
  chooseimage() async {
    file = await fileUploadGallery(isSvg: true);
    update();
  }

  Edit() async {
    if (!editkey.currentState!.validate()) return;

    statusrequest = Statusrequest.loading;
    update();

    try {
      var responseRaw = await admindaTaCaregores.editcat(
        catmodel!.categoriesId!,
        name.text,
        namear.text,
        catmodel!.categoriesImage!,
        file,
      );

      // لو response من السيرفر Map صالح
      Map<String, dynamic> response;
      if (responseRaw is Map<String, dynamic>) {
        response = responseRaw;
      } else {
        // لو response مش Map، اعتبر العملية نجحت لو ما فيه صورة جديدة
        if (file == null) {
          response = {"status": "success"};
        } else {
          statusrequest = Statusrequest.failure;
          update();
          return;
        }
      }

      statusrequest = handling(response);

      if (statusrequest == Statusrequest.success) {
        Get.snackbar("نجاح", "تم حفظ التعديلات بنجاح");
        Get.offAll(() => ViewCategories());
      } else {
        statusrequest = Statusrequest.failure;
      }
    } catch (e) {
      print("خطأ في EditController: $e");
      statusrequest = Statusrequest.failure;
    }

    update();
  }

  @override
  void onInit() {
    catmodel = Get.arguments['catmodel'];
    name = TextEditingController();
    namear = TextEditingController();
    name.text = catmodel!.categoriesName!;
    namear.text = catmodel!.categoriesNameAr!;

    super.onInit();
  }

  @override
  void onClose() {
    name.dispose();
    namear.dispose();
    super.onClose();
  }
}
