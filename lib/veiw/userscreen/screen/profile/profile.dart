import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hos/core/conistant/imageasset.dart';
import 'package:hos/core/conistant/routs.dart';
import 'package:hos/core/serveces/myservisec.dart';
import 'package:hos/veiw/userscreen/screen/profile/order/paymentmethods.dart';
import 'package:hos/veiw/userscreen/screen/profile/settings/settings.dart';

class ProfilePage extends StatelessWidget {
  ProfilePage({super.key});

  final Myservisec myservisec = Get.find();

  // لون أساسي مريح للتطبيق يمكن تغييره حسب الهوية البصرية لمشروعك
  final Color primaryColor = const Color.fromARGB(
    255,
    4,
    134,
    173,
  ); // لون نيلي عصري

  @override
  Widget build(BuildContext context) {
    // final h = Get.height;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildProfileHeader(Colors.lightBlue),

            Container(
              decoration: BoxDecoration(
                color: ThemeMode == ThemeMode.light ? Colors.white : null,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  _buildListTile(
                    gradientColors: [
                      const Color.fromARGB(255, 3, 60, 218),
                      Colors.blue,
                    ],
                    icon: Icons.local_mall_outlined,
                    title: "Orders".tr,
                    onTap: () => Get.toNamed(Approute.Orders),
                  ),
                  _buildListTile(
                    gradientColors: [
                      const Color.fromARGB(255, 243, 9, 9),
                      Colors.red,
                    ],
                    icon: Icons.favorite_border,
                    title: "Favorite".tr,
                    onTap: () => Get.toNamed(Approute.myfavorite),
                  ),
                  _buildListTile(
                    gradientColors: [
                      const Color.fromARGB(255, 31, 253, 2),
                      Colors.green,
                    ],
                    icon: Icons.location_on_outlined,
                    title: "Saved Addresses".tr,
                    onTap: () => Get.toNamed(Approute.viewmyaddres),
                  ),
                  _buildListTile(
                    gradientColors: [
                      const Color.fromARGB(255, 196, 136, 8),
                      Colors.orange,
                    ],
                    icon: Icons.credit_card_outlined,
                    title: "Payment Methods".tr,
                    onTap: () => Get.to(
                      () => PaymentScreen(),
                      transition: Transition.cupertino,
                    ),
                  ),

                  _buildListTile(
                    icon: Icons.settings_outlined,
                    title: "App Settings".tr,
                    isLast: true, // لإزالة الفاصل في العنصر الأخير
                    onTap: () => Get.to(
                      () => Settings(),
                      transition: Transition.cupertino,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ================= Header =================
  Widget _buildProfileHeader(Color color) {
    String userName =
        myservisec.sharedPreferences.getString("usersname") ?? "User Name";
    String email =
        myservisec.sharedPreferences.getString("email") ?? "user@email.com";

    return Column(
      children: [
        Stack(
          children: [
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.grey,
                  width: 2,
                  style: BorderStyle.solid,
                ),
              ),
              child: CircleAvatar(
                radius: 55,
                // backgroundColor: Colors.blue,
                backgroundImage: AssetImage(Imageasset.twetter),
                onBackgroundImageError: (_, _) {},
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: ClipPath(
                clipper: ShapeBorderClipper(shape: CircleBorder()),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Container(
                    margin: EdgeInsetsDirectional.symmetric(horizontal: 5),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white.withAlpha(75),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.camera_alt_outlined,
                      color: color.withBlue(150),
                      size: 20,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          userName,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 4),
        Text(email, style: TextStyle(color: Colors.grey[600], fontSize: 14)),
      ],
    );
  }

  // ================= Quick Action Cards =================

  // ================= Settings Group Items =================
  Widget _buildListTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isLast = false,
    List<Color>? gradientColors, // أضفت باراميتر لتخصيص الألوان لكل أيقونة
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            // الحاوية المعدلة مع التدرج اللوني
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                // استخدام Linear Gradient هنا
                gradient: LinearGradient(
                  colors:
                      gradientColors ??
                      [Colors.blue.shade400, Colors.blue.shade700],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: (gradientColors?.last ?? Colors.blue.shade700)
                        .withOpacity(0.3),
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(
                icon,
                color: Colors.white,
                size: 22,
              ), // جعلت الأيقونة بيضاء لتتناسب مع التدرج
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              color: Colors.grey[400],
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}
