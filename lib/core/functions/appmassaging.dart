import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
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
