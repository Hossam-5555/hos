import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/route_manager.dart';

Future<void> requestpermition() async {
  FirebaseMessaging.instance.requestPermission(
    announcement: false,
    alert: true,
    badge: true,
    sound: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
  );
}

appmassging() {
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    FlutterRingtonePlayer().playNotification();
    Get.snackbar(message.notification!.title!, message.notification!.body!);
  });
}

  Future<Position> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.',
      );
    }
    
    if(permission==LocationPermission.whileInUse){
      print("Hossam =LocationPermission.whileInUse==========");
    }
    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }

