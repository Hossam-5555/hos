import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:hos/core/class/crud.dart';
import 'package:hos/core/conistant/routs.dart';
import 'package:hos/core/functions/handlingdata.dart';
import 'package:hos/data/datasource/remote/homedata.dart';
import 'package:hos/data/model/itemsmodel.dart';
import 'package:hos/veiw/screen/home/itemsdetailes.dart';

class SearchMix extends GetxController {
  List<Itemsmodel> searchlist = [];
  Statusrequest statusrequest = Statusrequest.none;
  TextEditingController? search;
  Homedata homedata = Homedata(Get.find());

  bool issearch = false;

  Future<void> getsearhdata() async {
    if (search == null || search!.text.trim().isEmpty) {
      print("حقل البحث فارغ، لم يتم تنفيذ البحث");
      return;
    }

    searchlist.clear();
    statusrequest = Statusrequest.loading;
    update();

    var response = await homedata.searchdata(search!.text);
    print("Response==========================: $response");

    statusrequest = handling(response);

    if (Statusrequest.success == statusrequest) {
      if (response["status"] == "success") {
        List responsebody = response['data'];
        searchlist.addAll(responsebody.map((e) => Itemsmodel.fromJson(e)));
      } else {
        statusrequest = Statusrequest.failure;
      }
    }
    update();
  }

  void checksearch(String val) {
    if (val.isEmpty) {
      issearch = false;
      statusrequest = Statusrequest.none;
    }
    update();
  }

  @override
  void onInit() {
    search = TextEditingController();
    super.onInit();
  }

  @override
  void dispose() {
    search?.dispose();
    super.dispose();
  }

  void onsearch() {
    if (search == null || search!.text.trim().isEmpty) {
      print("تم الضغط على البحث بدون كتابة نص");
      return;
    }

    issearch = true;
    getsearhdata();
    update();
  }
  
  void gotoitemsdatails(Itemsmodel itemsmodel) {
    Get.to(
      () => Itemsdetailes(),
      transition: Transition.fadeIn,
      duration: const Duration(milliseconds: 400),
      arguments: {"itemsmodel": itemsmodel},
    );
  }
}
