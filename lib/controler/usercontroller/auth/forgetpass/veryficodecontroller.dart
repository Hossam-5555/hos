import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hos/data/services/crud.dart';
import 'package:hos/core/conistant/routs.dart';
import 'package:hos/core/functions/handlingdata.dart';
import 'package:hos/core/functions/snackbar.dart';
import 'package:hos/data/datasource/userdata/auth/forgetpass/verifycode.dart';

class VeryFiControler extends GetxController {
  String? email;
  late bool isexiting;
  Statusrequest statusrequest = Statusrequest.none;
  VerifyCodeForgetpassdata verifyCodeForgetpassdata = VerifyCodeForgetpassdata(
    crud: Get.find(),
  );
  Future<void> chekCode(String verifycode) async {
    statusrequest = Statusrequest.loading;
    update();
    var response = await verifyCodeForgetpassdata.postdata(email!, verifycode);
    statusrequest = handling(response);
    if (Statusrequest.success == statusrequest) {
      if (response['status'] == true) {
        Get.offNamed(Approute.Resetpass, arguments: {"email": email});
      } else {
        Get.defaultDialog(
          title: "Warning",
          middleText: "veryfi code not correct",
        );
        statusrequest = Statusrequest.failure;
      }
      update();
    }
  }

  Future<void> gotosuccessignup(String verifycode) async {
    statusrequest = Statusrequest.loading;
    update();
    var response = await verifyCodeForgetpassdata.verfising(email!, verifycode);
    statusrequest = handling(response);
    if (Statusrequest.success == statusrequest) {
      if (response['status'] == true) {
        showSnackBar(
          Get.context!,
          "Acout added sussecfuly",
          Icon(Icons.check_circle),
        );
        Get.offAllNamed(Approute.login);
      } else {
        Get.defaultDialog(
          title: "Warning",
          middleText: "veryfi code not correct",
        );
      }
      update();
    }
  }

  Future<void> submit(String verifycode) async {
    if (isexiting) {
      await chekCode(verifycode);
    } else {
      await gotosuccessignup(verifycode);
    }
  }

  @override
  void onInit() {
    email = Get.arguments['email'];
    isexiting = Get.arguments["isexiting"];
    super.onInit();
  }
}
