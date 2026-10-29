import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hos/data/services/crud.dart';
import 'package:hos/core/conistant/routs.dart';
import 'package:hos/core/conistant/static.dart';
import 'package:hos/core/functions/handlingdata.dart';
import 'package:hos/core/serveces/myservisec.dart';
import 'package:hos/data/datasource/userdata/auth/logindata.dart';
import 'package:hos/data/datasource/userdata/auth/signupdata.dart';
import 'package:hos/data/model/user_model.dart';

class AuthController extends GetxController {
  bool isLogin = true;
  bool showpass = true;

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController username = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController passward = TextEditingController();

  Myservisec myservisec = Get.find();
  LoginData logindata = LoginData(Get.find());
  Signupdata signupdata = Signupdata(Get.find());

  Statusrequest statusrequest = Statusrequest.none;

  void toggleMode() {
    isLogin = !isLogin;
    formKey = GlobalKey<FormState>();
    statusrequest = Statusrequest.none;
    username.clear();
    email.clear();
    passward.clear();
    update();
  }

  void isshowpass() {
    showpass = !showpass;
    update();
  }

  void checkemailpage() {
    Get.toNamed(Approute.checkemailpage);
  }

  Future<void> submit() async {
    if (!formKey.currentState!.validate()) return;
    if (isLogin) {
      await login();
    } else {
      await signup();
    }
  }

  Future<void> login() async {
    statusrequest = Statusrequest.loading;
    update();

    var response = await logindata.postdata(email.text, passward.text);
    statusrequest = handling(response);

    if (statusrequest == Statusrequest.checkinterner) {
      update();
      return;
    }

    if (statusrequest == Statusrequest.success && response['status'] == true) {
      var data = response['data'];
      var userJson = data['user'];
      var token = data['token'];
      UserModel user = UserModel.fromJson(userJson);

      await myservisec.sharedPreferences.setInt("id", user.id!);
      await myservisec.sharedPreferences.setString("usersname", user.name!);
      await myservisec.sharedPreferences.setString("email", user.email!);
      await myservisec.sharedPreferences.setString("usertype", user.usersType!);
      await myservisec.sharedPreferences.setString("token", token);
      await myservisec.sharedPreferences.setString("step", "1");

      int id = user.id!;

      if (user.isAprove == 1) {
        if (user.usersType == Static.admin) {
          FirebaseMessaging.instance.subscribeToTopic(Static.admin);
          FirebaseMessaging.instance.subscribeToTopic("${Static.admin}_$id");
          Get.offAllNamed(AdminApproate.adminHome);
        } else {
          FirebaseMessaging.instance.subscribeToTopic(Static.user);
          FirebaseMessaging.instance.subscribeToTopic("${Static.user}_$id");
          Get.offAllNamed(Approute.Homescreen);
        }
      } else {
        Get.toNamed(
          Approute.Veryficode,
          arguments: {"email": email.text, "isexiting": true},
        );
      }
    } else {
      statusrequest = Statusrequest.failure;
    }

    update();
  }

  Future<void> signup() async {
    statusrequest = Statusrequest.loading;
    update();

    var response = await signupdata.postdata(
      username.text,
      email.text,
      passward.text,
    );
    statusrequest = handling(response);

    if (statusrequest == Statusrequest.checkinterner) {
      update();
      return;
    }

    if (statusrequest == Statusrequest.success) {
      if (response['status'] == true) {
        Get.offNamed(
          Approute.Veryficode,
          arguments: {"email": email.text, "isexiting": false},
        );
      } else {
        Get.defaultDialog(title: "Warning", middleText: "email are Exist");
        statusrequest = Statusrequest.failure;
      }
    }

    update();
  }

  @override
  void dispose() {
    email.dispose();
    passward.dispose();
    username.dispose();
    super.dispose();
  }
}
