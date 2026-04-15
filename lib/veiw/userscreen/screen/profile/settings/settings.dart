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
    // حقن الـ Controller في الـ View. سيتم إنشاؤه مرة واحدة فقط
    final SettingsController controller = Get.put(SettingsController());

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: Appbarbackicon(herotag: 'settings', title: "Settings"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSettingsGroup(
              context,
              title: "Acount",
              children: [
                _buildSettingsTile(
                  icon: Icons.person,
                  title: "user",
                  subtitle: 'Edit Account'.tr,
                  onTap: () {},
                ),
                builddivider(),

                _buildSettingsTile(
                  icon: Icons.language_sharp,
                  title: "Languages".tr,
                  subtitle: 'Choose language'.tr,
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          title: Text(
                            "Choose language".tr,
                            textAlign: TextAlign.center,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          content: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  controllerlang.Changelang('ar');
                                  Navigator.pop(context);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                ),
                                child: const Text("العربية"),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  controllerlang.Changelang('en');
                                  Navigator.pop(context);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color.fromARGB(
                                    255,
                                    9,
                                    181,
                                    194,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                ),
                                child: const Text("English"),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
            _buildSettingsGroup(
              context,
              title: 'General'.tr,
              children: [
                // استخدم Obx لإعادة بناء هذه الويدجت فقط عند تغيير قيمتها
                Obx(
                  () => SwitchListTile(
                    secondary: const Icon(Icons.notifications_outlined),
                    title: Text('Enable notifications'.tr),
                    value: controller.notificationsEnabled.value,
                    onChanged: controller.toggleNotifications,
                    activeColor: Theme.of(context).colorScheme.secondary,
                  ),
                ),
                builddivider(),

                ListTile(
                  leading: const Icon(Icons.color_lens_outlined),
                  title: Text('Theme'.tr),
                  trailing: Obx(
                    () => DropdownButton<String>(
                      value: controller.selectedTheme.value,
                      items: <String>['Light', 'Dark', 'System']
                          .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(
                                value,
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            );
                          })
                          .toList(),
                      onChanged: controller.changeTheme,
                      underline: const SizedBox(), // لإخفاء الخط السفلي
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _buildSettingsGroup(
              context,
              title: 'Support'.tr,
              children: [
                _buildSettingsTile(
                  icon: Icons.info_outline,
                  title: 'About the app'.tr,
                  subtitle: '${"version".tr} 1.0.0',
                  onTap: () {
                    Get.to(
                      EnglishAbout(),
                      curve: Curves.easeInOut,
                      transition: Transition.fade,
                      duration: Duration(milliseconds: 400),
                    );
                  },
                ),
                builddivider(),
                _buildSettingsTile(
                  icon: Icons.call_outlined,
                  title: 'Contact us'.tr,
                  onTap: controller.makePhoneCall,
                  trailing: Obx(
                    () => controller.isLoading.value
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const SizedBox(
                            child: Icon(Icons.arrow_forward_ios, size: 16),
                          ),
                  ),
                ),
                builddivider(),

                ListTile(trailing:Icon(Icons.arrow_forward_ios, size: 16) ,
                  leading: const Icon(Icons.logout, color: Colors.black),
                  title: Text('Logout'.tr, style: TextStyle(color: Colors.red)),
                  onTap: () {
                    controller.logout();
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // ويدجت مخصصة لتجميع الإعدادات في بطاقة
  Widget _buildSettingsGroup(
    BuildContext context, {
    required String title,
    required List<Widget> children,
  }) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(
              top: 16.0,
              left: 16.0,
              right: 16.0,
              bottom: 8.0,
            ),
            child: Text(
              title,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w700,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ),
          ...children,
        ],
      ),
    );
  }

  // ويدجت مخصصة لعناصر الإعدادات العادية
  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
    Widget? trailing, // ← أضفنا ده
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      subtitle: subtitle != null ? Text(subtitle) : null,
      trailing:
          trailing ??
          const Icon(Icons.arrow_forward_ios, size: 16), // ← افتراضيًا السهم
      onTap: onTap,
    );
  }
}

Widget builddivider() {
  return Padding(
    padding: const EdgeInsets.only(left: 60, right: 20), // لترك مساحة للأيقونة
    child: Divider(height: 1, color: Colors.grey[200]),
  );
}
