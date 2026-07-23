import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hos/controler/usercontroller/profile/settingscontroller.dart';
import 'package:hos/core/localization/changlocal.dart';
import 'package:hos/veiw/userscreen/screen/profile/settings/Editprofile.dart';
import 'package:hos/veiw/userscreen/screen/profile/settings/about_us_page.dart';
import 'package:hos/veiw/wedget/appbarbackicon.dart';

/// ==================================================
///                    UI THEME
/// ==================================================
class _STColors {
  static const primary = Color(0xFF2962FF);
  // static const primaryDark = Color(0xFF0039CB);
}

class Settings extends StatelessWidget {
  Settings({super.key});
  final controllerlang = Get.put(LocalController());

  @override
  Widget build(BuildContext context) {
    final SettingsController controller = Get.put(SettingsController());
    LocalController local = Get.put(LocalController());
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

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
                  vertical: 14,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // ------- بطاقة الترويسة (الملف الشخصي) -------
                    _buildProfileHeader(
                      isDarkMode,
                      controller.username ?? "User",
                    ),

                    const SizedBox(height: 24),

                    // المجموعة الأولى: الحساب
                    _buildSettingsGroup(
                      context,
                      title: "Account".tr,
                      children: [
                        // _buildSettingsTile(
                        //   icon: Icons.person_outline,
                        //   title: "Profile".tr,
                        //   subtitle: 'Edit Account'.tr,
                        //   onTap: () {
                        //     Get.to(() => EditProfileView());
                        //   },
                        //   gradientColors: [
                        //     Colors.indigo.shade400,
                        //     Colors.indigo.shade700,
                        //   ],
                        // ),
                        // _buildDivider(),
                        _buildThemeTile(local),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // المجموعة الثانية: الدعم
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
                                    width: 18,
                                    height: 18,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
                                : Icon(
                                    Icons.arrow_forward_ios,
                                    size: 14,
                                    color: Colors.grey.shade400,
                                  ),
                          ),
                          gradientColors: [
                            Colors.cyan.shade400,
                            Colors.cyan.shade700,
                          ],
                        ),
                        _buildSettingsTile(
                          icon: Icons.ios_share,
                          title: "Share App",
                          onTap: () {},
                          gradientColors: [
                            Colors.green.shade400,
                            Colors.green.shade700,
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // المجموعة الثالثة: تسجيل الخروج (منفصلة بصريًا لخطورتها)
                    _buildSettingsGroup(
                      context,
                      title: 'Session'.tr,
                      children: [
                        _buildSettingsTile(
                          icon: Icons.logout_rounded,
                          title: 'Logout'.tr,
                          onTap: () => _confirmLogout(context, controller),
                          gradientColors: [
                            Colors.red.shade400,
                            Colors.red.shade700,
                          ],
                          titleColor: Colors.red.shade600,
                          showArrow: false,
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

  // ---------------- بطاقة الملف الشخصي أعلى الصفحة ----------------
  Widget _buildProfileHeader(bool isDarkMode, String username) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Theme.of(Get.context!).cardColor,
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () =>
            Get.to(() => EditProfileView(), transition: Transition.cupertino),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.grey.withOpacity(0.6),
                  width: 1.5,
                ),
              ),
              child: const CircleAvatar(
                radius: 28,
                backgroundColor: Colors.white24,
                child: Icon(Icons.person, size: 28),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "$username",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    "Manage your account".tr,
                    style: TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(shape: BoxShape.circle),
              child: const Icon(Icons.arrow_forward_ios, size: 13),
            ),
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
          padding: const EdgeInsetsDirectional.only(start: 6, bottom: 8),
          child: Text(
            title.toUpperCase(),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12.5,
              letterSpacing: 0.6,
              color: Colors.grey.shade500,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 12,
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
    Color? titleColor,
    bool showArrow = true,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
          child: ListTile(
            leading: Container(
              padding: const EdgeInsets.all(9),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: gradientColors,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: gradientColors.last.withOpacity(0.35),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Icon(icon, color: Colors.white, size: 19),
            ),
            title: Text(
              title,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: titleColor,
              ),
            ),
            subtitle: subtitle != null
                ? Text(
                    subtitle,
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                  )
                : null,
            trailing:
                trailing ??
                (showArrow
                    ? Icon(
                        Icons.arrow_forward_ios,
                        size: 13,
                        color: Colors.grey.shade400,
                      )
                    : null),
          ),
        ),
      ),
    );
  }

  // ويدجت الثيم (Dark/Light) بنفس منطق GetX الأصلي
  Widget _buildThemeTile(LocalController controller) {
    return Obx(() {
      bool isDark = controller.selectedTheme.value == 'Dark';

      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
        child: ListTile(
          leading: Container(
            padding: const EdgeInsets.all(9),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.purple.shade400, Colors.purple.shade700],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.purple.withOpacity(0.35),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: const Icon(
              Icons.palette_outlined,
              color: Colors.white,
              size: 19,
            ),
          ),
          title: Text(
            'Theme'.tr,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
          ),
          subtitle: Text(
            (isDark ? 'Dark mode' : 'Light mode').tr,
            style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
          ),
          trailing: GestureDetector(
            onTap: () => controller.changeTheme(!isDark),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: 55,
              height: 32,
              padding: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: isDark ? Colors.black : Colors.grey.shade300,
              ),
              child: AnimatedAlign(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                alignment: isDark
                    ? Alignment.centerRight
                    : Alignment.centerLeft,
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  transitionBuilder: (child, animation) {
                    return RotationTransition(
                      turns: animation,
                      child: ScaleTransition(scale: animation, child: child),
                    );
                  },
                  key: ValueKey<bool>(isDark),
                  child: isDark
                      ? const Icon(
                          Icons.dark_mode,
                          key: ValueKey('dark'),
                          color: Colors.white,
                          size: 20,
                        )
                      : const Icon(
                          Icons.sunny,
                          key: ValueKey('light'),
                          color: Colors.orange,
                          size: 20,
                        ),
                ),
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget _buildDivider() => Divider(
    height: 1,
    indent: 62,
    endIndent: 12,
    color: Colors.grey.withOpacity(0.1),
  );

  Widget _buildFooter() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 18),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: _STColors.primary.withOpacity(0.08),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.storefront_outlined,
              color: _STColors.primary,
              size: 22,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "HOS App",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.grey[500],
              letterSpacing: 1.2,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            "© 2026 All Rights Reserved",
            style: TextStyle(color: Colors.grey[400], fontSize: 11),
          ),
        ],
      ),
    );
  }

  // ---------------- تأكيد تسجيل الخروج ----------------
  void _confirmLogout(BuildContext context, SettingsController controller) {
    Get.defaultDialog(
      title: "Logout".tr,
      titleStyle: const TextStyle(fontWeight: FontWeight.bold),
      middleText: "Are you sure you want to logout?".tr,
      radius: 16,
      cancel: TextButton(
        onPressed: () => Get.back(),
        child: Text("Cancel".tr, style: TextStyle(color: Colors.grey.shade600)),
      ),
      confirm: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red.shade500,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: () {
          Get.back();
          controller.logout();
        },
        child: Text("Logout".tr, style: const TextStyle(color: Colors.white)),
      ),
    );
  }

  void _showLanguageDialog(BuildContext context) {
    Get.defaultDialog(
      title: "Choose Language".tr,
      titleStyle: const TextStyle(fontWeight: FontWeight.bold),
      radius: 16,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _languageOption(
            label: "العربية",
            icon: Icons.language,
            color: Colors.green,
            onTap: () {
              controllerlang.changeLang('ar');
              Get.back();
            },
          ),
          const SizedBox(height: 4),
          _languageOption(
            label: "English",
            icon: Icons.language,
            color: Colors.blue,
            onTap: () {
              controllerlang.changeLang('en');
              Get.back();
            },
          ),
        ],
      ),
    );
  }

  Widget _languageOption({
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: ListTile(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          tileColor: color.withOpacity(0.06),
          leading: Icon(icon, color: color),
          title: Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }
}
