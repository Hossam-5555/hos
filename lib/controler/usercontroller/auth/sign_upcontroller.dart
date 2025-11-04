import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hos/core/class/crud.dart';
import 'package:hos/core/conistant/routs.dart';
import 'package:hos/core/functions/handlingdata.dart';
import 'package:hos/data/datasource/remote/auth/signupdata.dart';
import 'package:hos/veiw/userscreen/screen/auth/login.dart';

class Signupcontroller extends GetxController {
  TextEditingController email = TextEditingController();
  TextEditingController passward = TextEditingController();
  TextEditingController username = TextEditingController();

  GlobalKey<FormState> signuokey = GlobalKey();
  Statusrequest statusrequest = Statusrequest.none;
  List data = [];

  // go to login(){}
  void gotologinin() {
    Get.off(
      () => Login(),
      transition: Transition.leftToRight,
      duration: const Duration(milliseconds: 800),
    );
  }

  Signupdata signupdata = Signupdata(Get.find());
  //sign up(){}
  Future<void> signup() async {
    if (signuokey.currentState!.validate()) {
      statusrequest = Statusrequest.loading;
      update();
      var response = await signupdata.postdata(
        username.text,
        email.text,
        passward.text,
      );
      statusrequest = handling(response);
      if (Statusrequest.success == statusrequest) {
        if (response['status'] == 'success') {
          // data.addAll(response['data']);
          Get.offNamed(Approute.veryfisign, arguments: {"email": email.text});
        } else {
          Get.defaultDialog(title: "Warning", middleText: "email are Exist");
          statusrequest = Statusrequest.failure;
        }
      }
      update();
    }
  }

  @override
  void dispose() {
    email.dispose();
    passward.dispose();
    username.dispose();
    super.dispose();
  }
}
