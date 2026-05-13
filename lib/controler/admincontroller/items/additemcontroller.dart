import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:hos/core/class/crud.dart';
import 'package:hos/core/functions/handlingdata.dart';
import 'package:hos/core/functions/upload_image.dart';
import 'package:hos/data/datasource/admindata/itemdata.dart';
import 'package:hos/veiw/adminscreen/Home/itemsview/viewitem.dart';

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
  showImagePickerBottomSheet(chooseimagecamera, chooseimagegalary);
}

Future<void> chooseimagecamera() async {
  file = await imageUploadCamera();
  update();
}

Future<void> chooseimagegalary() async {
  file = await fileUploadGallery();
  update();
}

  Future<void> additem() async {
    if (itemvalidKey.currentState!.validate()) {
      if (file == null) {
        Get.snackbar("تنبيه", "من فضلك اختر صورة أولاً");
        return;
      }
      statusrequest = Statusrequest.loading;
      update();
      Map data = {
        "itemname": name.text,
        "itemnamear": namear.text,
        "itemdesc": description.text,
        "itemdescar": descriptionar.text,
        "itemscount": count.text,
        "itemsprice": price.text,
        "itemsdiscount": descount.text,
        "itemscat": itemcat.text,
        "datenow": DateTime.now().toString(),
      };

      var response = await dataitem.additem(data, file!);

      statusrequest = handling(response);
      if (statusrequest == Statusrequest.success) {
        if (response['status'] == 'success') {
          Get.snackbar("success", "    تم اضافه القسم بنجاح");

          Get.off(() => viewitem());
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
    description = TextEditingController();
    descriptionar = TextEditingController();
    count = TextEditingController();
    price = TextEditingController();
    descount = TextEditingController();
    itemcat = TextEditingController();
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
