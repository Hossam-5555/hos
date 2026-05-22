import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hos/controler/usercontroller/checkout&cart/checkoutcontroller.dart';
import 'package:hos/core/class/crud.dart';
import 'package:hos/core/functions/handlingdata.dart';
import 'package:hos/core/functions/snackbar.dart';
import 'package:hos/core/serveces/myservisec.dart';
import 'package:hos/data/datasource/userdata/addresdata.dart';
import 'package:hos/data/model/Addresmodel.dart';

class AddressController extends GetxController {
  Addresdata addresdata = Addresdata(Get.find());
  Myservisec myservisec = Get.find();
  Statusrequest? statusrequest;
  List<AddresModel> listaddresdata = [];
  GlobalKey<FormState> addadredKey = GlobalKey();
  int get userid => myservisec.sharedPreferences.getInt("id")!;
  // متغيرات الحقول
  TextEditingController? name;
  TextEditingController? city;
  TextEditingController? street;
  double lat = 23.3344;
  double long = 23.3344;

  /////////////////////////
 
  Completer<GoogleMapController>? completercontroller;

  List<Marker> markers = [];

  void addMarkers(LatLng latLng) {
    markers.clear();
    markers.add(Marker(markerId: MarkerId("1"), position: latLng));
    lat = latLng.latitude;
    long = latLng.longitude;
    update();
  }

  @override
  void onInit() {
    name = TextEditingController();
    city = TextEditingController();
    street = TextEditingController();
    viewaddres();
    super.onInit();
  }

  /////////////////////

  Future<void> addaddres() async {
    statusrequest = Statusrequest.loading;
    update();

    var response = await addresdata.AddAddresdata(
      userid,
      name!.text,
      city!.text,
      street!.text,
      lat.toString(),
      long.toString(),
      "+201034567820",
    );

    statusrequest = handling(response);
    if (Statusrequest.success == statusrequest) {
      if (response['status'] == true) {
        // تحديث القائمة بعد الإضافة
        await viewaddres();
        if (Get.isRegistered<Checkoutcontroller>()) {
          Checkoutcontroller controller = Get.find<Checkoutcontroller>();
          await controller.getaddress();
        }
        Get.back();
      } else {
        statusrequest = Statusrequest.failure;
      }
    }
    update();
  }

  // viewaddress
  Future<void> viewaddres() async {
    statusrequest = Statusrequest.loading;
    update();

    var response = await addresdata.viewAddresdata(userid);

    statusrequest = handling(response);
    if (Statusrequest.success == statusrequest) {
      if (response['status'] == true) {
        List data = response['data'];
        // تنظيف القائمة قبل الإضافة
        listaddresdata.clear();

        listaddresdata.addAll(data.map((e) => AddresModel.fromJson(e)));
      } else {
        statusrequest = Statusrequest.failure;
      }
    }
    update();
  }

  final GlobalKey<AnimatedListState> listKey = GlobalKey<AnimatedListState>();

  void deleteAddres(int addresid) {
    // 🔹 نجيب index الصح
    addresdata.deleteAddresdata(addresid);

    // 🔹 نحذف من الليست مباشرة
    listaddresdata.removeWhere((e) => e.id == addresid);

    // 🔹 استدعاء API للحذف
    showSnackBar(Get.context!, "تم حذف العنوان بنجاح",Icon(Icons.check_circle));
    // 🔹 حالة الليست فاضية
    if (listaddresdata.isEmpty) {
      statusrequest = Statusrequest.failure;
    }

    // 🔹 تحديث الواجهة
    update();
  }

  // دالة الحفظ
  List<Marker> marker = [];
  void addmarker(LatLng latlang) {
    marker.clear();
    marker.add(Marker(markerId: MarkerId('1'), position: latlang));
    update();
  }

  @override
  void dispose() {
    name!.dispose();
    city!.dispose();
    street!.dispose();

    super.dispose();
  }
}
