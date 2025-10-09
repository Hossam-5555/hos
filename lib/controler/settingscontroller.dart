import 'package:get/get.dart';
import 'package:hos/core/conistant/routs.dart';
import 'package:hos/core/serveces/myservisec.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsController extends GetxController {
  Myservisec myservisec = Get.put(Myservisec());
  // استخدام .obs لجعل المتغيرات تفاعلية (reactive)
  var notificationsEnabled = true.obs;
  var selectedTheme = 'Light'.obs;

  @override
  void onInit() {
    super.onInit();
    loadSettings(); // تحميل الإعدادات عند بدء تشغيل الـ controller
  }

  goaddres() {
    Get.toNamed(Approute.viewmyaddres);
  }

  //logout تسجيل الخروج من البرنامج
  logout() {
    myservisec.sharedPreferences.clear();
    Get.offAndToNamed(Approute.login);
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
