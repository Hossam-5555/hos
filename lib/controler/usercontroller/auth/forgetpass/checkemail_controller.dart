import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hos/core/class/crud.dart';
import 'package:hos/core/conistant/routs.dart';
import 'package:hos/core/functions/handlingdata.dart';
import 'package:hos/data/datasource/remote/auth/forgetpass/checkemail.dart';

class CheckemailController extends GetxController {
  TextEditingController email = TextEditingController();
  GlobalKey<FormState> formstate = GlobalKey();
  @override
  void dispose() {
    email.dispose();
    super.dispose();
  }

  Statusrequest statusrequest = Statusrequest.none;
  Checkemaildata checkemaildata = Checkemaildata(Get.find());
  checkemail() async {
    if (formstate.currentState!.validate()) {
      statusrequest = Statusrequest.loading;
      update();
      var response = await checkemaildata.postdata(email.text);
      statusrequest = handling(response);
      if (Statusrequest.success == statusrequest) {
        if (response['status'] == 'success') {
          // data.addAll(response['data']);
          Get.offNamed(Approute.Veryficode, arguments: {"email": email.text});
        } else {
          Get.defaultDialog(title: "Warning", middleText: "email Not Exist");
          statusrequest = Statusrequest.failure;
        }
      }
      update();
    }
  }
}
