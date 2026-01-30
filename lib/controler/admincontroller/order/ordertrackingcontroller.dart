import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hos/core/class/crud.dart';
import 'package:hos/core/functions/getpolyline.dart';
import 'package:hos/data/model/ordersmodel.dart';

class Trackingorderadmin extends GetxController {
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
    // هذا الماركر من اجل مكان التوصيل
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
            (element) => element.mapsId.value == MarkerId('current'),
          );
          //هذا الماركر من اجل المكان الحالي  للساءق
          marker.add(
            Marker(
              markerId: MarkerId('current'),
              position: LatLng(currentlat!, currentlong!),
              infoWindow: InfoWindow(title: 'My Location'),
            ),
          );

          completercontroller!.animateCamera(
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
  Set<Polyline> polylines = {};

  inintpolyline() async {
    destlat = double.parse(order.addresLat.toString());
    destlong = double.parse(order.addresLang.toString());
    Future.delayed(Duration(seconds: 1));
    polylines = await Getpolyline(currentlat, currentlong, destlat, destlong);
    update();
  }

  @override
  void onInit() {
    order = Get.arguments["order"];

    // Getcurrentlocation();
    // inintpolyline();
    super.onInit();
  }

  @override
  void onClose() {
    positionStream?.cancel();
    completercontroller?.dispose();
    super.onClose();
  }
}
