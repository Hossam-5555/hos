import 'dart:async';

import 'package:flutter/foundation.dart';
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
import 'package:hos/data/model/addres_model.dart';
import 'package:hos/veiw/userscreen/screen/profile/addres/viewaddres.dart';
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
  TextEditingController? phone;

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
      if (kDebugMode) {
        print("Geocoding error: $e");
      }
    }

    update();
    return point; // ✅ رجّع النقطة عشان الـ widget يحط العلامة عليها
  }

  @override
  void onInit() {
    name = TextEditingController();
    city = TextEditingController();
    street = TextEditingController();
    phone = TextEditingController();
    viewaddres();
    super.onInit();
  }

  /////////////////////
  final RxBool isuccess = false.obs;
  Future<void> addaddres(BuildContext context) async {
    isuccess.value = false;

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
      phone!.text,
    );

    statusrequest = handling(response);
    if (Statusrequest.success == statusrequest) {
      if (response['status'] == true) {
        isuccess.value = true;

        await viewaddres();
        if (Get.isRegistered<Checkoutcontroller>()) {
          Checkoutcontroller controller = Get.find<Checkoutcontroller>();
          await controller.getaddress();
        }
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

  Future<void> updatedefault(int id) async {
    isdefault = id;
    update();
    var response = await addresdata.setdefault(id);
    statusrequest = handling(response);
    if (Statusrequest.success == statusrequest) {
      if (response['status'] == true) {
        listaddresdata.map((e) => isdefault == e.id);
      }
    }
    update();
  }

  // ignore: non_constant_identifier_names
  final GlobalKey<AnimatedListState> Addressket =
      GlobalKey<AnimatedListState>();

  void deleteAddres(int addresid, BuildContext context) {
    int index = listaddresdata.indexWhere((e) => e.id == addresid);

    if (index != -1) {
      var removedItem = listaddresdata[index];

      if (Addressket.currentState != null) {
        Addressket.currentState!.removeItem(
          index,
          (context, animation) => SizeTransition(
            sizeFactor: animation,
            child: AddressCard(
              address: removedItem,
              isDefault: false,
              onDelete: () {},
              onSetDefault: () {},
            ),
          ),
          duration: const Duration(milliseconds: 300),
        );
      }

      listaddresdata.removeAt(index);
      addresdata.deleteAddresdata(addresid);

      if (listaddresdata.isEmpty) {
        statusrequest = Statusrequest.failure;
      }

      update();
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
