import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:hos/core/class/crud.dart';
import 'package:hos/core/conistant/routs.dart';
import 'package:hos/core/functions/handlingdata.dart';
import 'package:hos/data/datasource/userdata/auth/forgetpass/resetpass.dart';

class Resetpasscontroller extends GetxController {
  late TextEditingController password;
  late TextEditingController repassword;
  String? email;
  GlobalKey<FormState> formstate = GlobalKey();
  Statusrequest statusrequest = Statusrequest.none;
  ResetPassData resetPassData = ResetPassData(crud: Get.find());
  Future<void> gotosuccesreset() async {
    if (password.text != repassword.text) {
      return Get.defaultDialog(
        title: "Warning",
        middleText: "passWord Not Mach",
      );
    }
    if (formstate.currentState!.validate()) {
      statusrequest = Statusrequest.loading;
      update();
      var response = await resetPassData.postdata(email!, password.text);
      statusrequest = handling(response);
      if (Statusrequest.success == statusrequest) {
        if (response['status'] == 'success') {
          Get.snackbar("success", "تم إعادة تعيين كلمة المرور بنجاح");
          Get.offAllNamed(Approute.login);
        } else {
          Get.defaultDialog(title: "Warning", middleText: "try Again");
          statusrequest = Statusrequest.failure;
        }
        update();
      }
    }
  }

  @override
  void onInit() {
    password = TextEditingController();
    repassword = TextEditingController();
    email = Get.arguments['email'];
    super.onInit();
  }

  @override
  void onClose() {
    password.dispose();
    repassword.dispose();
    super.onClose();
  }
}
