import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart' show MapController, LatLngBounds;
import 'package:geocoding/geocoding.dart' as geocoding;
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:hos/controler/usercontroller/checkout&cart/checkoutcontroller.dart';
import 'package:hos/core/class/crud.dart';
import 'package:hos/core/functions/handlingdata.dart';
import 'package:hos/core/serveces/myservisec.dart';
import 'package:hos/data/datasource/userdata/addresdata.dart';
import 'package:hos/data/model/Addresmodel.dart';
import 'package:latlong2/latlong.dart';

class AddressController extends GetxController {
  Addresdata addresdata = Addresdata(Get.find());
  Myservisec myservisec = Get.find();
  Statusrequest? statusrequest;
  List<AddressModel> listaddresdata = <AddressModel>[].obs;
  GlobalKey<FormState> addadredKey = GlobalKey();

  // متغيرات الحقول
  TextEditingController? name;
  TextEditingController? city;
  TextEditingController? street;

  double lat = 30.0444;
  double long = 31.2357;

  final LatLngBounds egyptBounds = LatLngBounds(
    const LatLng(22.0, 25.0),
    const LatLng(31.7, 36.0),
  );

  /////////////////////////
  String? selectedGovernorate;
  String? selectedCity;
  String? selectedLocationType;
  MapController map = MapController();
  final List<String> locationTypes = [
    'منزل',
    'عمل',
    'كافيه',
    'فندق',
    'مستشفى',
    'مدرسة',
    'مصنع',
  ];

  void onGovernorateChanged(String? val) {
    selectedGovernorate = val;
    selectedCity = null;
    update();
  }

  void onCityChanged(String? val) {
    selectedCity = val;
    update();
  }

  void onLocationTypeChanged(String? val) {
    selectedLocationType = val;
    update();
  }

  Future<LatLng?> getcurrentlocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      Get.snackbar('Location Disabled', 'Please enable location service');
      return null;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        Get.snackbar('Permission Denied', 'Location access is required');
        return null;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      Get.snackbar(
        'Permission Required',
        'Please enable location from settings',
        mainButton: TextButton(
          onPressed: () => Geolocator.openAppSettings(),
          child: const Text('Open Settings'),
        ),
      );
      return null;
    }

    Position position = await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 100,
      ),
    );

    final newLat = position.latitude;
    final newLng = position.longitude;
    final point = LatLng(newLat, newLng);

    if (!egyptBounds.contains(point)) {
      Get.snackbar(
        'Outside Coverage',
        'Your current location is outside our delivery area',
      );
      return null;
    }

    lat = newLat;
    long = newLng;

    map.move(point, 15);

    try {
      List<geocoding.Placemark> placemarks = await geocoding
          .placemarkFromCoordinates(lat, long);
      if (placemarks.isNotEmpty) {}
    } catch (e) {
      print("Geocoding error: $e");
    }

    update();
    return point; // ✅ رجّع النقطة عشان الـ widget يحط العلامة عليها
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
    String cityText = city!.text = "$selectedGovernorate - $selectedCity";
    String nameText = name!.text = selectedLocationType ?? "منزل";

    statusrequest = Statusrequest.loading;
    update();

    var response = await addresdata.AddAddresdata(
      nameText,
      cityText,
      street!.text,
      lat.toString(),
      long.toString(),
      "+201034567820",
    );

    statusrequest = handling(response);
    if (Statusrequest.success == statusrequest) {
      if (response['status'] == true) {
        await viewaddres();
        if (Get.isRegistered<Checkoutcontroller>()) {
          Checkoutcontroller controller = Get.find<Checkoutcontroller>();
          await controller.getaddress();
        }
        Get.back();
      } else {
        response['message'] != null
            ? Get.snackbar("Error", response['message'])
            : Get.snackbar("Error", "Failed to add address");
      }
    }
    update();
  }

  int isdefault = 0;

  Future<void> viewaddres() async {
    statusrequest = Statusrequest.loading;
    update();

    var response = await addresdata.viewAddresdata();

    statusrequest = handling(response);
    if (Statusrequest.success == statusrequest) {
      if (response['status'] == true) {
        List data = response['data']['data'];
        isdefault = response['data']['is_default'];
        listaddresdata.clear();
        listaddresdata.addAll(data.map((e) => AddressModel.fromJson(e)));
      } else {
        statusrequest = Statusrequest.failure;
      }
    }
    update();
  }

  updatedefault(int id) async {
    isdefault = id;
    update();
    var response = await addresdata.setdefault(id);
    print(response);
    statusrequest = handling(response);
    if (Statusrequest.success == statusrequest) {
      if (response['status'] == true) {
        viewaddres();
      }
    }
    update();
  }

  final GlobalKey<AnimatedListState> Addressket =
      GlobalKey<AnimatedListState>();

  void deleteAddres(int addresid) {
    int index = listaddresdata.indexWhere((e) => e.id == addresid);

    if (index != -1) {
      var removedItem = listaddresdata[index];

      if (Addressket.currentState != null) {
        Addressket.currentState!.removeItem(
          index,
          (context, animation) => ScaleTransition(
            scale: animation,
            child: Card(
              margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: Colors.red.shade200, width: 1),
              ),
              color: Colors.green.shade50,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  margin: const EdgeInsets.all(5),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.03),
                        blurRadius: 2,
                        spreadRadius: 0.5,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 4,
                    ),
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.red.shade100,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.delete_sweep_rounded,
                        color: Colors.red.shade700,
                        size: 22,
                      ),
                    ),
                    title: Text(
                      "تم حذف ${removedItem.name ?? 'العنوان'}",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Colors.red.shade900,
                        fontFamily: "sans-serif",
                      ),
                    ),
                    subtitle: const Text(
                      "تم نقل العنصر للمهملات بنجاح",
                      style: TextStyle(fontSize: 12, color: Colors.black54),
                    ),
                  ),
                ),
              ),
            ),
          ),
          duration: const Duration(milliseconds: 500),
        );
      }

      listaddresdata.removeAt(index);
      addresdata.deleteAddresdata(addresid);

      if (listaddresdata.isEmpty) {
        statusrequest = Statusrequest.failure;
      }

      update();
    } else {
      print("خطأ: العنصر غير موجود في القائمة المحلية أساساً!");
    }
  }

  @override
  void dispose() {
    name!.dispose();
    city!.dispose();
    street!.dispose();
    super.dispose();
  }
}
