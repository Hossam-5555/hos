import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hos/core/class/crud.dart';
import 'package:hos/core/conistant/routs.dart';
import 'package:hos/core/functions/handlingdata.dart';
import 'package:hos/core/serveces/myservisec.dart';
import 'package:hos/data/datasource/remote/auth/logindata.dart';
import 'package:hos/veiw/userscreen/screen/auth/signup%20.dart';

class LoginController extends GetxController {
  void checkemailpage() {
    Get.toNamed(Approute.checkemailpage);
  }

  void gotosignup() {
    Get.off(
      () => Signup(),
      transition: Transition.rightToLeft,
      duration: const Duration(milliseconds: 800),
    );
  }

  GlobalKey<FormState> loginkey = GlobalKey();
  TextEditingController email = TextEditingController();
  TextEditingController passward = TextEditingController();
  Myservisec myservisec = Get.find();
  bool showpass = true;
  @override
  void onInit() {
    FirebaseMessaging.instance.getToken().then((val) {});
    super.onInit();
  }

  void isshowpass() {
    showpass = showpass == true ? false : true;
    update();
  }

  @override
  void dispose() {
    email.dispose();
    passward.dispose();
    super.dispose();
  }

  logindata Logindata = logindata(Get.find());
  Statusrequest statusrequest = Statusrequest.none;
  Future<void> login() async {
    if (loginkey.currentState!.validate()) {
      statusrequest = Statusrequest.loading;
      update();
      var response = await Logindata.postdata(email.text, passward.text);
      statusrequest = handling(response);
      if (Statusrequest.success == statusrequest) {
        if (response['status'] == 'success') {
          if (response["data"]["users_aprove"] == 1) {
            myservisec.sharedPreferences.setString(
              "id",
              response["data"]['users_id'].toString(),
            );
            String id = myservisec.sharedPreferences.getString("id") ?? "";
            myservisec.sharedPreferences.setString(
              "usersname",
              response["data"]['users_name'],
            );
            myservisec.sharedPreferences.setString(
              "email",
              response["data"]['users_email'],
            );
            myservisec.sharedPreferences.setString("step", '2');
            FirebaseMessaging.instance.subscribeToTopic("users");
            FirebaseMessaging.instance.subscribeToTopic("users${id}");

            Get.offNamed(Approute.Homescreen);
          } else {
            Get.toNamed(Approute.veryfisign, arguments: {"email": email.text});
          }

          print(response["data"]);
        } else {
          Get.rawSnackbar(
            duration: Duration(milliseconds: 800),

            margin: EdgeInsets.all(12),
            borderRadius: 16,
            title: "إشعار",
            messageText: const Text(" هناك خطأ في السيرفر"),
          );
          statusrequest = Statusrequest.failure;
        }
      }
      update();
    }
  }
}
