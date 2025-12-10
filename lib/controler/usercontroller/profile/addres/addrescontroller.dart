import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hos/core/class/crud.dart';
import 'package:hos/core/conistant/routs.dart';
import 'package:hos/core/functions/handlingdata.dart';
import 'package:hos/core/serveces/myservisec.dart';
import 'package:hos/data/datasource/userdata/addresdata.dart';
import 'package:hos/data/model/Addresmodel.dart';

class AddressController extends GetxController {
  Addresdata addresdata = Addresdata(Get.find());
  Myservisec myservisec = Get.find();
  Statusrequest? statusrequest;
  List<Addresmodel> ListAddresdata = [];
  GlobalKey<FormState> addadredKey = GlobalKey();

  // متغيرات الحقول
  TextEditingController? name;
  TextEditingController? city;
  TextEditingController? street;
  double lat = 23.3344;
  double long = 23.3344;

  /////////////////////////
  ///
  ///
  ///
  ///
  ///
  Completer<GoogleMapController>? completercontroller;

  List<Marker> markers = [];

  addMarkers(LatLng latLng) {
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

  Addadres() async {
    statusrequest = Statusrequest.loading;
    update();

    var response = await addresdata.AddAddresdata(
      myservisec.sharedPreferences.getString("id")!,
      name!.text,
      city!.text,
      street!.text,
      lat.toString(),
      long.toString(),
    );

    statusrequest = handling(response);
    if (Statusrequest.success == statusrequest) {
      if (response['status'] == 'success') {
        // تحديث القائمة بعد الإضافة
        await viewaddres();
        Get.offNamed(Approute.Homescreen);
        Get.snackbar("تم", "تم حفظ العنوان بنجاح");
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

    var response = await addresdata.viewAddresdata(
      myservisec.sharedPreferences.getString("id")!,
    );

    statusrequest = handling(response);
    if (Statusrequest.success == statusrequest) {
      if (response['status'] == 'success') {
        List data = response['data'];

        // تنظيف القائمة قبل الإضافة
        ListAddresdata.clear();
        ListAddresdata.addAll(data.map((e) => Addresmodel.fromJson(e)));

        if (ListAddresdata.isEmpty) {
          statusrequest = Statusrequest.failure;
        }
      } else {
        statusrequest = Statusrequest.failure;
      }
    }
    update();
  }

  // deleteAddres
  void deleteAddres(String addresid) {
    addresdata.deleteAddresdata(addresid);
    ListAddresdata.removeWhere((e) => e.addresId.toString() == addresid);
    Get.snackbar(
      "تم",
      "تم ازاله العنوان بنجاح",
      duration: Duration(milliseconds: 700),
    );

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
