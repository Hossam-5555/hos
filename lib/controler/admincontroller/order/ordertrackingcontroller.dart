import 'dart:async';

import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hos/core/class/crud.dart';
import 'package:hos/data/model/ordersmodel.dart';

class Trackingordercontroller extends GetxController {


  Statusrequest statusrequest = Statusrequest.none;
  late Completer<GoogleMapController> completercontroller;
  late OrderModel order;
  StreamSubscription<Position>? positionStream;
  CameraPosition? cameraPosition;

  List<Marker> marker = [];
  Getcurrentlocation() async {
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
          print(
            position == null
                ? 'Unknown'
                : '${position.latitude.toString()}, ${position.longitude.toString()}',
          );
          /*هنا بنمسح المكان القديم ونحط المكان الجديد عن طريق id */
          marker.removeWhere(
            (element) => element.mapsId.value == MarkerId('current'),
          );
          marker.add(
            Marker(
              markerId: MarkerId('current'),
              position: LatLng(
                double.parse(order.addresLat.toString()),
                double.parse(order.addresLang.toString()),
              ),
              infoWindow: InfoWindow(title: 'My Location'),
            ),
          );
          update();
        });
  }

  @override
  void onInit() {
    order = Get.arguments["order"];
    completercontroller = Completer<GoogleMapController>();
    super.onInit();
  }
}
