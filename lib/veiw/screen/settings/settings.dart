import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hos/controler/settingscontroller.dart';

class Settings extends StatelessWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context) {
    // حقن الـ Controller في الـ View. سيتم إنشاؤه مرة واحدة فقط
    final SettingsController controller = Get.put(SettingsController());

    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          // الخطوة 1: إضافة هامش قياسي ليكون بعيدًا عن الحافة
          padding: const EdgeInsets.only(left: 16.0),
          child: Hero(
            // الخطوة 2: جعل الـ Hero يلتف حول الدائرة بالكامل
            tag: 'settengtag',
            child: Container(
              width: 48, // الخطوة 3: تحديد حجم قياسي (لمسة مريحة للمستخدم)
              height: 48,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  // إضافة ظل خفيف ليعطي عمقاً
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: IconButton(
                onPressed: () {
                  Get.back();
                },
                icon: Icon(Icons.arrow_back_ios),
                iconSize: 24, // الخطوة 4: تحديد حجم قياسي للأيقونة
                splashRadius: 24, // لجعل تأثير الضغط لا يخرج عن الدائرة
              ),
            ),
          ),
        ),
      ),
      body: Container(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSettingsGroup(
                context,
                title: 'الحساب',
                children: [
                  _buildSettingsTile(
                    icon: Icons.person_outline,
                    title: 'تعديل الملف الشخصي',
                    onTap: () {},
                  ),
                  _buildSettingsTile(
                    icon: Icons.lock_outline,
                    title: 'تغيير كلمة المرور',
                    onTap: () {},
                  ),
                  _buildSettingsTile(
                    icon: Icons.location_on,
                    title: '  address',
                    onTap: () {
                      controller.goaddres();
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),
              _buildSettingsGroup(
                context,
                title: 'التخصيص والإشعارات',
                children: [
                  // استخدم Obx لإعادة بناء هذه الويدجت فقط عند تغيير قيمتها
                  Obx(
                    () => SwitchListTile(
                      secondary: const Icon(Icons.notifications_outlined),
                      title: const Text('تفعيل الإشعارات'),
                      value: controller.notificationsEnabled.value,
                      onChanged: controller.toggleNotifications,
                      activeColor: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.color_lens_outlined),
                    title: const Text('المظهر'),
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
                title: 'حول',
                children: [
                  _buildSettingsTile(
                    icon: Icons.info_outline,
                    title: 'عن التطبيق',
                    subtitle: 'الإصدار 1.0.0',
                    onTap: () {},
                  ),
                  _buildSettingsTile(
                    icon: Icons.description_outlined,
                    title: 'الشروط والأحكام',
                    onTap: () {},
                  ),
                  ListTile(
                    leading: const Icon(Icons.logout, color: Colors.red),
                    title: const Text(
                      'تسجيل الخروج',
                      style: TextStyle(color: Colors.red),
                    ),
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
      elevation: 20,
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
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
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
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      subtitle: subtitle != null ? Text(subtitle) : null,
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }
}
