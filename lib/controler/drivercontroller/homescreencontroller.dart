import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:hos/core/conistant/imageasset.dart';
import 'package:hos/core/conistant/routs.dart';
import 'package:hos/core/serveces/myservisec.dart';
import 'package:hos/veiw/driverscreen/driveraccepted.dart';
import 'package:hos/veiw/driverscreen/driverpending.dart';

class DriverHomeController extends GetxController {
  // ignore: non_constant_identifier_names
  int Currentpage = 0;

  void changpage(int i) {
    Currentpage = i;
    update();
  }

  Myservisec myservisec = Get.put(Myservisec());
  void logout() {
    String id = myservisec.sharedPreferences.getString("id")!;
    FirebaseMessaging.instance.subscribeToTopic("users");
    FirebaseMessaging.instance.subscribeToTopic("users$id");
    myservisec.sharedPreferences.clear();
    Get.offAndToNamed(Approute.login);
  }

  final List<Widget> driverpage = [
    Driverpending(),

    Driveraccepted(), // 🔹 صفحة الهوم
  ];

  var x = 20.0.obs;
  var y = 500.0.obs;

  void fun(DragUpdateDetails details) {
    x.value += details.delta.dx;
    y.value += details.delta.dy;
  }

  final ScrollController scrollController = ScrollController();
  bool upordown = true;
  void secrolcotroller() {
    if (scrollController.position.userScrollDirection ==
        ScrollDirection.reverse) {
      upordown = false;
    } else if (scrollController.position.userScrollDirection ==
        ScrollDirection.forward) {
      upordown = true;
    }
    update();
  }

  @override
  void onInit() {
    super.onInit();
    scrollController.addListener(secrolcotroller);
  }

  @override
  void onClose() {
    scrollController.removeListener(secrolcotroller);
    scrollController.dispose();
  }

  List<List<dynamic>> driverAppbartitle = [
    ['Pending', Imageasset.offer],

    ['Accepted', Imageasset.homesvg],
  ];
}
