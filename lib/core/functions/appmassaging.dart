import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:hos/controler/admincontroller/order/pindingcontroller.dart';
import 'package:hos/data/model/ordersmodel.dart';
import 'package:hos/veiw/adminscreen/Home/orders/adminpending.dart';

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

void appMessaging() {
  // 1. والتطبيق مفتوح في الوش (Foreground)
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    FlutterRingtonePlayer().playNotification();

    // إشعار علوي سريع جوه التطبيق
    Get.snackbar(
      message.notification?.title ?? "إشعار جديد",
      message.notification?.body ?? "",
      snackPosition: SnackPosition.TOP,
      duration: const Duration(seconds: 4),
      onTap: (_) {
        // لو ضغط على الـ snackbar والتطبيق مفتوح يوديه برضه للـ أوردر
        _handleNotificationRouting(message.data);
      },
    );
  });

  // 2. والتطبيق في الخلفية (Background) والأدمن ضغط على الإشعار من شريط الإشعارات
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    _handleNotificationRouting(message.data);
  });

  // 3. والتطبيق مقفول تماماً (Terminated) والأدمن ضغط على الإشعار ليفتح التطبيق
  FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message) {
    if (message != null) {
      // بنعمل تأخير بسيط (Delay) عشان نضمن إن الـ Routes والـ GetX اتعملهم Initialize والتطبيق فتح الأول
      Future.delayed(const Duration(milliseconds: 500), () {
        _handleNotificationRouting(message.data);
      });
    }
  });
}

// 4. دالة التوجيه الذكي بناءً على الداتا اللي جاية من لارافيل
void _handleNotificationRouting(Map<String, dynamic> data) {
  if (data.containsKey('type') && data.containsKey('target_id')) {
    String type = data['type'];
    int targetId = int.parse(data['target_id']);
    if (type == 'new_order') {
      var c = Get.find<AdminPindingController>();
      OrderModel? orderModel = c.orderspending
          .where((e) => e.orderId == targetId)
          .first;
      if (orderModel.orderId == targetId) {
        Get.to(() => const Adminpending(),arguments: {"order":orderModel});
      }
      // هنا GetX بياخده لصفحة تفاصيل الطلب ويبعت الـ ID معاها
      // غير اسم الصفحة (OrderDetailsScreen) لاسم صفحتك الحقيقي
    }
    // تقدر هنا تضيف else if لو عندك أنواع إشعارات تانية مستقبلاً
  }
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

  if (permission == LocationPermission.whileInUse) {
    if (kDebugMode) {
      print("Hossam =LocationPermission.whileInUse==========");
    }
  }
  // When we reach here, permissions are granted and we can
  // continue accessing the position of the device.
  return await Geolocator.getCurrentPosition();
}
