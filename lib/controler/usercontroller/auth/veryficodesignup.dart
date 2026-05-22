import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hos/core/class/crud.dart';
import 'package:hos/core/conistant/routs.dart';
import 'package:hos/core/functions/handlingdata.dart';
import 'package:hos/core/functions/snackbar.dart';
import 'package:hos/data/datasource/userdata/auth/veryvicodesign.dart';

class VeryfiSignControler extends GetxController {
  String? email;
  VeryfiCodeSignupData veryficodesign = VeryfiCodeSignupData(Get.find());
  Statusrequest statusrequest = Statusrequest.none;

  Future<void> gotosuccessignup(String verifycode) async {
    statusrequest = Statusrequest.loading;
    update();
    var response = await veryficodesign.postdata(email!, verifycode);
    statusrequest = handling(response);
    if (Statusrequest.success == statusrequest) {
      if (response['status'] == true) {
        showSnackBar(Get.context!, "Acout added sussecfuly",Icon(Icons.check_circle));
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

  void resendcode() {
    veryficodesign.resend(email!);
  }

  @override
  void onInit() {
    email = Get.arguments['email'];
    super.onInit();
  }
}
