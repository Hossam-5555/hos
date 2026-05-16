import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:hos/core/class/crud.dart';
import 'package:hos/core/functions/handlingdata.dart';
import 'package:hos/core/functions/upload_image.dart';
import 'package:hos/data/datasource/admindata/itemdata.dart';
import 'package:hos/data/model/itemsmodel.dart';
import 'package:hos/veiw/adminscreen/Home/itemsview/viewitem.dart';

class Edititemcontroller extends GetxController {
  Statusrequest statusrequest = Statusrequest.none;
  admindataitem dataitem = admindataitem(Get.find());
  String? itemid;
  String? active;
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

  Future<void> edit() async {
    if (!editkey.currentState!.validate()) return;

    statusrequest = Statusrequest.loading;
    update();
    Map data = {
      "itemid": itemid,
      "itemscat": itemcat.text,
      "itemname": name.text,
      "itemnamear": namear.text,
      "itemdesc": description.text,
      "itemdescar": descriptionar.text,
      "itemscount": count.text,
      // "itemsactive": active,
      "itemsprice": price.text,
      "itemsdiscount": descount.text,
      "oldimage": imagename,
    };
    var response = await dataitem.edititem(data, file);
    statusrequest = handling(response);
    if (statusrequest == Statusrequest.success) {
      if (response['status'] == 'success') {
        Get.snackbar("success", "    تم تعديل العنصر بنجاح");

        Get.offAll(
          () => ViewItemScreen(),
          transition: Transition.fadeIn,
          duration: Duration(milliseconds: 250),
        );
      }
    } else {
      statusrequest = Statusrequest.failure;
    }

    update();
  }

  @override
  void onInit() {
    itemsmodel = Get.arguments['itemsmodel'];
    itemid = itemsmodel!.id.toString();
    active = itemsmodel!.itemsActive.toString();
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
