import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hos/core/class/crud.dart';
import 'package:hos/core/conistant/routs.dart';
import 'package:hos/core/functions/handlingdata.dart';
import 'package:hos/core/serveces/myservisec.dart';
import 'package:hos/data/datasource/userdata/auth/logindata.dart';
import 'package:hos/data/model/UserModel.dart';
import 'package:hos/veiw/userscreen/screen/auth/signup%20.dart';

class LoginController extends GetxController {
  void checkemailpage() {
    Get.toNamed(Approute.checkemailpage);
  }

  List<UserModel> userinfo = [];
  String? token;
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
    if (!loginkey.currentState!.validate()) return;

    statusrequest = Statusrequest.loading;
    update();

    var response = await logindata.postdata(email.text, passward.text);
    statusrequest = handling(response);

    if (statusrequest == Statusrequest.success && response['status'] == true) {
      print(response);

      var data = response['data'];
      var userJson = data['user'];
      var token = data['token'];

      // 🔥 تحويل المستخدم
      UserModel user = UserModel.fromJson(userJson);

      // 🔥 حفظ البيانات
      await myservisec.sharedPreferences.setInt("id", user.id!);
      await myservisec.sharedPreferences.setString("usersname", user.name!);
      await myservisec.sharedPreferences.setString("email", user.email!);
      await myservisec.sharedPreferences.setString("usertype", user.usersType!);
      await myservisec.sharedPreferences.setString("token", token);
      await myservisec.sharedPreferences.setString("step", "2");

      int id = user.id!;

      // 🔥 Check approval
      if (user.isAprove == 1) {
        if (user.usersType == "admin") {
          FirebaseMessaging.instance.subscribeToTopic("admin");
          FirebaseMessaging.instance.subscribeToTopic("admin$id");
          Get.offAllNamed(AdminApproate.adminHome);
        } else {
          FirebaseMessaging.instance.subscribeToTopic("users");
          FirebaseMessaging.instance.subscribeToTopic("users$id");
          Get.offAllNamed(Approute.Homescreen);
        }
      } else {
        Get.toNamed(Approute.veryfisign, arguments: {"email": email.text});
      }
    } else {
      statusrequest = Statusrequest.failure;
    }

    update();
  }
}
