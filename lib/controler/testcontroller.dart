import 'dart:async';

import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hos/core/class/crud.dart';
import 'package:hos/core/functions/handlingdata.dart';
import 'package:hos/core/serveces/myservisec.dart';
import 'package:hos/data/datasource/remote/addresdata.dart';
import 'package:hos/data/model/Addresmodel.dart';

class Testcontroller extends GetxController {
  Addresdata addresdata = Get.put(Addresdata(Get.find()));
  Statusrequest statusrequest = Statusrequest.none;
  Myservisec myservisec = Get.put(Myservisec());
  List dataaddres = [];
  getaddress() async {
    // statusrequest = Statusrequest.loading;
    // update();
    var response = await addresdata.viewAddresdata(
      myservisec.sharedPreferences.getString("id")!,
    );
    statusrequest = handling(response);
    if (Statusrequest.success == statusrequest) {
      if (response["status"] == "success") {
        List responsedata = response["data"];
        dataaddres.addAll(responsedata.map((e) => Addresmodel.fromJson(e)));
      } else {
        statusrequest = Statusrequest.failure;
      }
    }
    update();
  }

  @override
  void onInit() {
    getaddress();
    // getposition();
    super.onInit();
  }
  // var x = 20.0.obs;
  // var y = 500.0.obs;

  // void fun(DragUpdateDetails details) {
  //   x.value += details.delta.dx;
  //   y.value += details.delta.dy;
  // }
  // StreamSubscription<Position>? positionStream;
  // Future<Position?> getposition() async {
  //   bool serviceEnabled;
  //   LocationPermission permission;

  //   serviceEnabled = await Geolocator.isLocationServiceEnabled();
  //   if (serviceEnabled == false) {
  //     return null;
  //   }

  //   permission = await Geolocator.checkPermission();
  //   if (permission == LocationPermission.denied) {
  //     permission = await Geolocator.requestPermission();

  //     if (permission == LocationPermission.denied) {
  //       return Future.error('Location permissions are denied');
  //     }
  //   }

  //   if (permission == LocationPermission.deniedForever) {
  //     return Future.error(
  //       'Location permissions are permanently denied, we cannot request permissions.',
  //     );
  //   }
  //   if (permission == LocationPermission.whileInUse) {
  //     // positionStream = Geolocator.getPositionStream().listen((
  //     //   Position? position,
  //     // ) {
  //     //   print(
  //     //     '======${position!.latitude}'
  //     //     '======${position.longitude}',
  //     //   );
  //     // });
  //   }
  // }

  // @override
  // void dispose() {
  //   if (positionStream != null) {
  //     positionStream!.cancel();
  //   }
  //   super.dispose();
  // }
}
