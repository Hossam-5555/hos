import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:hos/controler/admincontroller/categories/viewcontroller.dart';
import 'package:hos/core/class/crud.dart';
import 'package:hos/core/functions/handlingdata.dart';
import 'package:hos/core/functions/snackbar.dart';
import 'package:hos/core/functions/upload_image.dart';
import 'package:hos/data/datasource/admindata/categoriesdata.dart';
import 'package:hos/data/model/categoriesmodel.dart';

class Editcontroller extends GetxController {
  Statusrequest statusrequest = Statusrequest.none;
  AdmindaTaCaregores admindaTaCaregores = AdmindaTaCaregores(Get.find());
  late TextEditingController name;
  late TextEditingController namear;
  GlobalKey<FormState> editkey = GlobalKey<FormState>();
  File? file;
  CategoriesModel? catmodel;
  Future<void> chooseimage() async {
    file = await fileUploadGallery();
    update();
  }

  Future<void> edit() async {
    if (!editkey.currentState!.validate()) return;

    statusrequest = Statusrequest.loading;
    update();

    try {
      var response = await admindaTaCaregores.editcat(
        catmodel!.id!,
        name.text,
        namear.text,
        file,
      );

      // لو response من السيرفر Map صالح

      statusrequest = handling(response);

      if (statusrequest == Statusrequest.success &&
          response['status'] == true) {
        showSnackBar(Get.context!, "  تم التعديل بنجاح");
        Get.find<ViewCatController>().viewCat();
      } else {
        statusrequest = Statusrequest.failure;
      }
    } catch (e) {
      statusrequest = Statusrequest.failure;
    }

    update();
  }

  @override
  void onInit() {
    catmodel = Get.arguments['catmodel'];
    name = TextEditingController();
    namear = TextEditingController();
    name.text = catmodel!.name!;
    namear.text = catmodel!.nameAr!;

    super.onInit();
  }

  @override
  void onClose() {
    name.dispose();
    namear.dispose();
    super.onClose();
  }
}
