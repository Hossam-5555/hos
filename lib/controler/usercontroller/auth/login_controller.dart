import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hos/core/class/crud.dart';
import 'package:hos/core/conistant/routs.dart';
import 'package:hos/core/functions/handlingdata.dart';
import 'package:hos/core/serveces/myservisec.dart';
import 'package:hos/data/datasource/userdata/auth/logindata.dart';
import 'package:hos/veiw/userscreen/screen/auth/signup%20.dart';

class LoginController extends GetxController {
  void checkemailpage() {
    Get.toNamed(Approute.checkemailpage);
  }

  void gotosignup() {
    Get.off(
      () => Signup(),
      transition: Transition.fade,
      duration: const Duration(milliseconds: 400),
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

  LoginData logindata = LoginData(Get.find());
  Statusrequest statusrequest = Statusrequest.none;
  Future<void> login() async {
    //لقد انشأت عمود في قواعد البيانات ب نوع المستخدم )(admin,user,driver)
    //ثم عند تسجيل الدخول بنحفظها ب شيرد برفرانس usertypeثم نعمل داله

    // if (userType == "admin") {ادمن يروح صفحه admin ,user=>user,driver=driver
    //             Get.offNamed(AdminApproate.adminHome);
    //           } else if (userType == "driver") {
    //             Get.offNamed(AdminApproate.driverHome);
    //           } else {
    //             Get.offNamed(Approute.Homescreen);
    //           }

    if (loginkey.currentState!.validate()) {
      statusrequest = Statusrequest.loading;
      update();
      var response = await logindata.postdata(email.text, passward.text);
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
            myservisec.sharedPreferences.setString(
              "usertype",
              response["data"]["users_type"],
            );

            myservisec.sharedPreferences.setString("step", '2');
            FirebaseMessaging.instance.subscribeToTopic("users");
            FirebaseMessaging.instance.subscribeToTopic("users$id");

            String userType = response["data"]["users_type"];

            if (userType == "admin") {
              Get.offAllNamed(AdminApproate.adminHome);
            } else if (userType == "driver") {
              Get.offAllNamed(AdminApproate.driverHome);
            } else {
              Get.offAllNamed(Approute.Homescreen);
            }
          } else {
            Get.toNamed(Approute.veryfisign, arguments: {"email": email.text});
          }

          if (kDebugMode) {
            print(response["data"]);
          }

        } else {
          statusrequest = Statusrequest.failure;
        }
      }
      update();
    }
  }
}
