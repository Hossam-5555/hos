import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hos/controler/usercontroller/profile/settingscontroller.dart';
import 'package:hos/core/localization/changlocal.dart';
import 'package:hos/veiw/userscreen/screen/profile/settings/about_us_page.dart';
import 'package:hos/veiw/wedget/appbarbackicon.dart';

class Settings extends StatelessWidget {
  Settings({super.key});
  final controllerlang = Get.put(LocalController());

  @override
  Widget build(BuildContext context) {
    final SettingsController controller = Get.put(SettingsController());
    LocalController local = Get.put(LocalController());
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: Appbarbackicon(herotag: 'settings', title: "Settings".tr),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 10,
                ),
                child: Column(
                  children: [
                    // المجموعة الأولى: الحساب
                    _buildSettingsGroup(
                      context,
                      title: "Account".tr,
                      children: [
                        _buildSettingsTile(
                          icon: Icons.person_outline,
                          title: "Profile".tr,
                          subtitle: 'Edit Account'.tr,
                          onTap: () {},
                          gradientColors: [
                            Colors.indigo.shade400,
                            Colors.indigo.shade700,
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // المجموعة الثانية: الإعدادات العامة
                    _buildSettingsGroup(
                      context,
                      title: 'General'.tr,
                      children: [
                        Obx(
                          () => _buildSwitchTile(
                            icon: Icons.notifications_none_outlined,
                            title: 'Notifications'.tr,
                            value: controller.notificationsEnabled.value,
                            onChanged: controller.toggleNotifications,
                            gradientColors: [
                              Colors.blue.shade400,
                              Colors.blue.shade700,
                            ],
                          ),
                        ),
                        _buildDivider(),
                        _buildThemeTile(local),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // المجموعة الثالثة: الدعم
                    _buildSettingsGroup(
                      context,
                      title: 'Support'.tr,
                      children: [
                        _buildSettingsTile(
                          icon: Icons.info_outline,
                          title: 'About App'.tr,
                          subtitle: '${"version".tr} 1.0.0',
                          onTap: () => Get.to(
                            () => EnglishAbout(),
                            transition: Transition.cupertino,
                          ),
                          gradientColors: [
                            Colors.teal.shade400,
                            Colors.teal.shade700,
                          ],
                        ),
                        _buildDivider(),
                        _buildSettingsTile(
                          icon: Icons.language_outlined,
                          title: "Language".tr,
                          onTap: () => _showLanguageDialog(context),
                          gradientColors: [
                            Colors.orange.shade400,
                            Colors.orange.shade700,
                          ],
                        ),
                        _buildDivider(),
                        _buildSettingsTile(
                          icon: Icons.headset_mic_outlined,
                          title: 'Contact Us'.tr,
                          onTap: controller.makePhoneCall,
                          trailing: Obx(
                            () => controller.isLoading.value
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Icon(Icons.arrow_forward_ios, size: 14),
                          ),
                          gradientColors: [
                            Colors.cyan.shade400,
                            Colors.cyan.shade700,
                          ],
                        ),
                        _buildDivider(),
                        _buildSettingsTile(
                          icon: Icons.logout_rounded,
                          title: 'Logout'.tr,
                          onTap: controller.logout,
                          gradientColors: [
                            Colors.red.shade400,
                            Colors.red.shade700,
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            // Footer Section
            _buildFooter(),
          ],
        ),
      ),
    );
  }

  // ويدجت مجموعة الإعدادات بتصميم Card عصري
  Widget _buildSettingsGroup(
    BuildContext context, {
    required String title,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8, bottom: 8),
          child: Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.blueGrey,
              fontSize: 14,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(children: children),
        ),
      ],
    );
  }

  // ويدجت عنصر الإعدادات مع الأيقونة المتدرجة
  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
    Widget? trailing,
    required List<Color> gradientColors,
  }) {
    return ListTile(
      onTap: onTap,
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradientColors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.white, size: 20),
      ),
      title: Text(
        title,
        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
      ),
      subtitle: subtitle != null
          ? Text(subtitle, style: const TextStyle(fontSize: 12))
          : null,
      trailing:
          trailing ??
          const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
    );
  }

  // ويدجت الـ Switch الخاص بالتنبيهات
  Widget _buildSwitchTile({
    required IconData icon,
    required String title,
    required bool value,
    required Function(bool) onChanged,
    required List<Color> gradientColors,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: gradientColors),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.white, size: 20),
      ),
      title: Text(
        title,
        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
      ),
      trailing: Switch.adaptive(
        thumbIcon: MaterialStateProperty.all(
          const Icon(Icons.notifications_active, size: 16, color: Colors.white),
        ),
        value: value,
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildThemeTile(LocalController controller) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.purple.shade400, Colors.purple.shade700],
          ),
          shape: BoxShape.circle,
        ),
        child: const Icon(
          Icons.palette_outlined,
          color: Colors.white,
          size: 20,
        ),
      ),
      title: Text(
        'Theme'.tr,
        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
      ),
      trailing: Switch.adaptive(
        // 1. تحديد لون المقبض (Thumb) في الوضع النشط والغير نشط
        activeColor: Colors.black, // لون الـ track لما يكون ON
        activeThumbColor: Colors.black, // لون الـ thumb لما يكون ON
        inactiveThumbColor: const Color.fromARGB(255, 230, 189, 8), // لون الشمس (أصفر ذهبي) لما يكون OFF
        inactiveTrackColor:
            Colors.white, // لون الـ track خفيف لما يكون OFF
        // 2. تطبيق تأثير تغيير الأيقونة باستخدام MaterialStateProperty
        thumbIcon: MaterialStateProperty.resolveWith<Icon?>((
          Set<MaterialState> states,
        ) {
          // إذا كان الـ Switch في حالة اختيار (يعني ON / Dark)
          if (states.contains(MaterialState.selected)) {
            return const Icon(
              Icons.dark_mode, // أيقونة الهلال
              size: 16,
              color: Colors.white,
            );
          }
          // إذا كان الـ Switch في حالة عدم اختيار (يعني OFF / Light)
          return const Icon(
            Icons.sunny, // أيقونة الشمس
            size: 16,
            color: Colors.black,
          );
        }),

        // 3. التحكم في الحالة واستدعاء الـ Controller
        value: controller.selectedTheme.value == 'Dark',
        onChanged: (value) => controller.changeTheme(value),
      ),
    );
  }

  Widget _buildDivider() =>
      Divider(height: 1, indent: 60, color: Colors.grey.withOpacity(0.1));

  Widget _buildFooter() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: [
          Text(
            "HOS App",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.grey[400],
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            "© 2026 All Rights Reserved",
            style: TextStyle(color: Colors.grey[500], fontSize: 11),
          ),
        ],
      ),
    );
  }

  void _showLanguageDialog(BuildContext context) {
    Get.defaultDialog(
      title: "Choose Language".tr,
      titleStyle: const TextStyle(fontWeight: FontWeight.bold),
      content: Column(
        children: [
          ListTile(
            title: const Text("العربية"),
            leading: const Icon(Icons.language, color: Colors.green),
            onTap: () {
              controllerlang.changeLang('ar');
              Get.back();
            },
          ),
          ListTile(
            title: const Text("English"),
            leading: const Icon(Icons.language, color: Colors.blue),
            onTap: () {
              controllerlang.changeLang('en');
              Get.back();
            },
          ),
        ],
      ),
      radius: 15,
    );
  }
}
