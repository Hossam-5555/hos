import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hos/core/class/crud.dart';
import 'package:hos/core/functions/getpolyline.dart';
import 'package:hos/core/serveces/myservisec.dart';
import 'package:hos/data/model/ordersmodel.dart';

class Trakingdrivercontroller extends GetxController {
  double? destlat;
  double? destlong;

  double? currentlat;
  double? currentlong;

  //  final Completer<GoogleMapController> completercontroller =
  Statusrequest statusrequest = Statusrequest.none;
  GoogleMapController? completercontroller;
  late OrderModel order;
  StreamSubscription<Position>? positionStream;
  CameraPosition? cameraPosition;

  List<Marker> marker = [];
  //===================================================================================
  Future<void> getcurrentlocation() async {
    final LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 100,
    );
    cameraPosition = CameraPosition(
      target: LatLng(
        double.parse(order.addresLat.toString()),
        double.parse(order.addresLang.toString()),
      ),
      zoom: 19.151926040649414,
    );
    //هذا الماركر بتاع المكان اللي هنوصلله
    marker.add(
      Marker(
        markerId: MarkerId('destination'),
        position: LatLng(
          double.parse(order.addresLat.toString()),
          double.parse(order.addresLang.toString()),
        ),
        infoWindow: InfoWindow(title: 'destination'),
      ),
    );
    // supply location settings to getPositionStream
    positionStream =
        Geolocator.getPositionStream(
          locationSettings: locationSettings,
        ).listen((Position? position) {
          // print(
          //   position == null
          //       ? 'Unknown'
          //       : '${position.latitude.toString()}, ${position.longitude.toString()}',
          // );
          currentlat = position!.latitude;
          currentlong = position.longitude;
          /*هنا بنمسح المكان القديم ونحط المكان الجديد عن طريق id */
          marker.removeWhere(
            // ignore: unrelated_type_equality_checks
            (element) => element.mapsId.value == MarkerId('current'),
          );
          // هنا بنضيف الماركر بتاع المكان الحالي
          marker.add(
            Marker(
              markerId: MarkerId('current'),
              position: LatLng(currentlat!, currentlong!),
              infoWindow: InfoWindow(title: 'My Location'),
            ),
          );
          completercontroller?.animateCamera(
            CameraUpdate.newCameraPosition(
              CameraPosition(
                target: LatLng(position.latitude, position.longitude),
                zoom: 19.151926040649414,
              ),
            ),
          );
          update();
        });
  }

  //===================================================================================
  //===================================================================================
  //===================================================================================
  Myservisec myservisec = Get.find();
  Timer? timer;
  Future<void> refreshlocationforuserApp()async {
   await Future.delayed(Duration(seconds: 10));
    timer = Timer(Duration(minutes: 1), () {
      FirebaseFirestore.instance.collection("orders").doc(order.ordersId).set({
        "driver_lat": currentlat,
        "driver_long": currentlong,
        "driverid": myservisec.sharedPreferences.getString("id"),
      });
    });
  }




  Set<Polyline> polylines = {};

  Future<void> inintpolyline() async {
    destlat = double.parse(order.addresLat.toString());
    destlong = double.parse(order.addresLang.toString());
    Future.delayed(Duration(seconds: 1));
    polylines = await getpolyline(currentlat, currentlong, destlat, destlong);
    update();
  }

  @override
  void onInit() {
    order = Get.arguments["order"];

    // getcurrentlocation();
    // refreshlocationforuserApp();
    // inintpolyline();
    super.onInit();
  }

  @override
  void onClose() {
    positionStream?.cancel();
    completercontroller?.dispose();
    timer!.cancel();
    super.onClose();
  }
}
