import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hos/core/conistant/routs.dart';
import 'package:hos/core/conistant/static.dart';
import 'package:hos/core/serveces/myservisec.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsController extends GetxController {
  Myservisec myservisec = Get.put(Myservisec());
  // استخدام .obs لجعل المتغيرات تفاعلية (reactive)
  var notificationsEnabled = true.obs;
  var selectedTheme = 'Light'.obs;
  String? get usrtype => myservisec.sharedPreferences.getString("usertype");
  String? get username => myservisec.sharedPreferences.getString("usersname");

  @override
  void onInit() {
    super.onInit();

    loadSettings(); // تحميل الإعدادات عند بدء تشغيل الـ controller
  }

  //logout تسجيل الخروج من البرنامج
  void logout() {
    int id = myservisec.sharedPreferences.getInt("id")!;

    if (usrtype == Static.admin) {
      FirebaseMessaging.instance.unsubscribeFromTopic(Static.admin);
      FirebaseMessaging.instance.unsubscribeFromTopic("${Static.admin}_$id");
    } else {
      FirebaseMessaging.instance.unsubscribeFromTopic(Static.user);
      FirebaseMessaging.instance.unsubscribeFromTopic("${Static.user}_$id");
    }

    myservisec.sharedPreferences.clear();
    Get.offAllNamed(Approute.login);
    update();
  }

  // دالة لتحميل الإعدادات المحفوظة
  Future<void> loadSettings() async {
    final prefs = myservisec.sharedPreferences;
    // نقوم بتحديث قيمة المتغيرات التفاعلية
    notificationsEnabled.value = prefs.getBool('notificationsEnabled') ?? true;
    selectedTheme.value = prefs.getString('appTheme') ?? 'Light';
  }

  // دالة لحفظ إعداد الإشعارات
  void toggleNotifications(bool value) async {
    notificationsEnabled.value = value;
    final prefs = myservisec.sharedPreferences;
    await prefs.setBool('notificationsEnabled', value);
  }

  var isLoading = false.obs;

  Future<void> openWhatsApp({
    required String phone,
    String message = '',
  }) async {
    isLoading.value = true;

    // تجهيز الرابط المباشر للواتساب
    final Uri url = Uri.parse(
      'https://wa.me/$phone?text=${Uri.encodeComponent(message)}',
    );

    if (await canLaunchUrl(url)) {
      await launchUrl(
        url,
        mode: LaunchMode.externalApplication, // يفتح في تطبيق الواتساب نفسه
      );
    } else {
      debugPrint('تعذر فتح الواتساب');
    }
    isLoading.value = false;
  }

  // دالة لحفظ إعداد المظهر
  void changeTheme(String? newTheme) async {
    if (newTheme != null) {
      selectedTheme.value = newTheme;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('appTheme', newTheme);
      // يمكنك هنا إضافة الكود لتغيير مظهر التطبيق الفعلي باستخدام Get.changeThemeMode
    }
  }
}
