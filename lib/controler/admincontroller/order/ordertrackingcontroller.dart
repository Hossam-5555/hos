import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

class Trackingordercontroller extends GetxController {
  Getcurrentlocation() async {
    final LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 100,
    );
    Position position = await Geolocator.getCurrentPosition(
      locationSettings: locationSettings,
    );
    print("============================================");
    print(position.latitude);

    print(position.longitude);
    print("============================================");
  }
}