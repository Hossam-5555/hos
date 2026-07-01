import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hos/controler/usercontroller/profile/addres/addrescontroller.dart';
import 'package:hos/core/class/crud.dart';
import 'package:hos/core/functions/handlingdata.dart';
import 'package:hos/data/datasource/userdata/addresdata.dart';
import 'package:hos/data/model/Addresmodel.dart';

class Editaddress extends GetxController {
  Statusrequest statusrequest = Statusrequest.none;
  Addresdata addresdata = Addresdata(Get.find());

  //update address
  Future<void> updateaddres(String addresid) async {
    statusrequest = Statusrequest.loading;
    update();

    var response = await addresdata.updateAddresdata(
      name!.text,
      city!.text,
      street!.text,
      lat.toString(),
      long.toString(),
      "+201034567820",
      addresid,
    );
    statusrequest = handling(response);
    if (Statusrequest.success == statusrequest) {
      if (response['status'] == true) {
        // تحديث القائمة بعد التحديث
        await Get.find<AddressController>().viewaddres();

        Get.back();
      } else {
        statusrequest = Statusrequest.failure;
      }
    }
    update();
  }

  TextEditingController? name;
  TextEditingController? city;
  TextEditingController? street;
  double lat = 23.3344;
  double long = 23.3344;
  AddressModel? model;
  @override
  void onInit() {
    model = Get.arguments["AddresModel"];
    name = TextEditingController();
    city = TextEditingController();
    street = TextEditingController();
    name!.text = model!.name!;
    city!.text = model!.name!;
    street!.text = model!.name!;

    super.onInit();
  }
}
