import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hos/core/class/crud.dart';
import 'package:hos/core/functions/handlingdata.dart';
import 'package:hos/core/serveces/binding.dart';
import 'package:hos/data/datasource/userdata/homedata.dart';
import 'package:hos/data/model/itemsmodel.dart';
import 'package:hos/veiw/userscreen/screen/home/itemsdetailes.dart';

class SearchMix extends GetxController {
  List<Itemsmodel> searchlist = [];
  Statusrequest statusrequest = Statusrequest.none;
  TextEditingController? search;
  Homedata homedata = Homedata(Get.find());

  bool issearch = false;
  TextInputAction textInputAction = TextInputAction.search;

  FocusNode focusNode = FocusNode();

  Future<void> getsearhdata() async {
    if (search == null || search!.text.trim().isEmpty) {
      return;
    }

    searchlist.clear();
    statusrequest = Statusrequest.loading;
    update();

    var response = await homedata.searchdata(search!.text);
    // print("Response==========================: $response");

    statusrequest = handling(response);

    if (Statusrequest.success == statusrequest) {
      if (response["status"] == "success") {
        List responsebody = response['data'];
        searchlist.addAll(responsebody.map((e) => Itemsmodel.fromJson(e)));

        focusNode.unfocus();
      } else {
        statusrequest = Statusrequest.failure;
      }
    }
    update();
  }

  void checksearch(String val) {
    if (val.isEmpty) {
      issearch = false;
      focusNode.unfocus();
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
      // print("تم الضغط على البحث بدون كتابة نص");
      return;
    }

    issearch = true;
    getsearhdata();
    update();
  }

  void gotoitemsdatails(Itemsmodel itemsmodel) {
    Get.to(
      () => Itemsdetailes(),
      binding: ItemDetailsBinding(),

      transition: Transition.fadeIn,
      curve: Curves.fastOutSlowIn,
      duration: Duration(milliseconds: 400),
      arguments: {"itemsmodel": itemsmodel},
    );
  }
}
