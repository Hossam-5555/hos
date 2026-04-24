import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hos/core/class/crud.dart';
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

  Statusrequest statusrequest = Statusrequest.none;
  Checkemaildata checkemaildata = Checkemaildata(Get.find());
  Future<void> checkemail() async {
    if (formstate.currentState!.validate()) {
      statusrequest = Statusrequest.loading;
      update();
      var response = await checkemaildata.postdata(email.text);
      statusrequest = handling(response);
      if (Statusrequest.success == statusrequest &&
          response['status'] == true) {
        Get.offNamed(Approute.Veryficode, arguments: {"email": email.text});
      } else {
        statusrequest = Statusrequest.failure;
      }
      update();
    }
  }
}
