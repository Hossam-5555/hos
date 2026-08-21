import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:hos/core/conistant/routs.dart';
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

  Map userdata = {"user": "user", "admin": "admin", 'driver': "driver"};
  //logout تسجيل الخروج من البرنامج
  void logout() {
    int id = myservisec.sharedPreferences.getInt("id")!;
    FirebaseMessaging.instance.unsubscribeFromTopic("${userdata[usrtype]}");
    FirebaseMessaging.instance.unsubscribeFromTopic("${userdata[usrtype]}$id");
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

  Future<void> makePhoneCall() async {
    isLoading.value = true;

    // ✅ تأخير بسيط قبل تنفيذ العملية (مثلاً ثانية)
    await Future.delayed(const Duration(milliseconds: 750));

    final Uri phoneUri = Uri(scheme: 'tel', path: '+201023426561');

    try {
      await launchUrl(phoneUri);
    } catch (e) {
      Get.snackbar("خطأ", "تعذر فتح تطبيق الاتصال 😢");
    }

    // ✅ تأخير بسيط بعد العملية لتجميل الحركة
    await Future.delayed(const Duration(milliseconds: 500));

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
