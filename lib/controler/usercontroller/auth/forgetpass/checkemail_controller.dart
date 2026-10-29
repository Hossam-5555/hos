import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hos/data/services/crud.dart';
import 'package:hos/core/conistant/routs.dart';
import 'package:hos/core/functions/handlingdata.dart';
import 'package:hos/data/datasource/userdata/auth/forgetpass/checkemail.dart';

class CheckemailController extends GetxController {
  TextEditingController email = TextEditingController();
  GlobalKey<FormState> formstate = GlobalKey();
  @override
  void dispose() {
    email.dispose();
    super.dispose();
  }

  String errorMessage = "";
  Statusrequest statusrequest = Statusrequest.none;
  Checkemaildata checkemaildata = Checkemaildata(Get.find());
  Future<void> checkemail() async {
    if (!formstate.currentState!.validate()) return;

    statusrequest = Statusrequest.loading;
    update();

    var response = await checkemaildata.postdata(email.text);
    statusrequest = handling(response);

    if (statusrequest == Statusrequest.checkinterner) {
      update();
      return;
    }

    if (statusrequest == Statusrequest.success && response['status'] == true) {
      Get.toNamed(
        Approute.Veryficode,
        arguments: {"email": email.text, "isexiting": true},
      );
    } else {
      errorMessage = response['message'];
      statusrequest = Statusrequest.failure;
    }

    update();
  }
}
