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
    190,
    188,
    223,
  ); // لون نيلي عصري

  @override
  Widget build(BuildContext context) {
    final h = Get.height;

    return Scaffold(
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.only(
          top: h * 0.03,
          bottom: 40,
          left: 20,
          right: 20,
        ),
        child: Column(
          children: [
            _buildProfileHeader(),
            SizedBox(height: h * 0.04),

            /// ===== Quick Actions (Orders & Wishlist) =====
            Row(
              children: [
                Expanded(
                  child: _buildQuickActionCard(
                    icon: Icons.camera_alt_outlined,
                    title: "change profile image",
                    color: const Color.fromARGB(255, 6, 110, 179), // أحمر وردي
                    onTap: () => Get.toNamed(Approute.myfavorite),
                  ),
                ),
              ],
            ),

            SizedBox(height: h * 0.04),

            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(7),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  _buildListTile(
                    gradientColors: [Colors.black, Colors.blue],
                    icon: Icons.local_mall_outlined,
                    title: "Orders".tr,
                    onTap: () => Get.toNamed(Approute.Orders),
                  ),
                  _buildDivider(),
                  _buildListTile(
                    gradientColors: [Colors.black, Colors.red],
                    icon: Icons.favorite_border,
                    title: "Favorite".tr,
                    onTap: () => Get.toNamed(Approute.myfavorite),
                  ),
                  _buildDivider(),
                  _buildListTile(
                    gradientColors: [Colors.black, Colors.green],
                    icon: Icons.location_on_outlined,
                    title: "Saved Addresses".tr,
                    onTap: () => Get.toNamed(Approute.viewmyaddres),
                  ),
                  _buildDivider(),
                  _buildListTile(
                    gradientColors: [Colors.black, Colors.orange],
                    icon: Icons.credit_card_outlined,
                    title: "Payment Methods".tr,
                    onTap: () => Get.to(
                      () => PaymentScreen(),
                      transition: Transition.cupertino,
                    ),
                  ),
                  _buildDivider(),

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
  Widget _buildProfileHeader() {
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
                border: Border.all(color: primaryColor, width: 2),
              ),
              child: CircleAvatar(
                radius: 55,
                backgroundColor: Colors.white,
                backgroundImage: AssetImage(Imageasset.twetter),
                onBackgroundImageError: (_, _) {},
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
  Widget _buildQuickActionCard({
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(40),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsetsDirectional.all(5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withAlpha(25),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 28),
              ),
              SizedBox(width: 10),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ================= Settings Group Items =================
  Widget _buildListTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isLast = false,
    List<Color>? gradientColors, // أضفت باراميتر لتخصيص الألوان لكل أيقونة
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: isLast
            ? const BorderRadius.vertical(bottom: Radius.circular(20))
            : BorderRadius.zero,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Row(
            children: [
              // الحاوية المعدلة مع التدرج اللوني
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  // استخدام Linear Gradient هنا
                  gradient: LinearGradient(
                    colors:
                        gradientColors ??
                        [Colors.blue.shade400, Colors.blue.shade700],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: (gradientColors?.last ?? Colors.blue.shade700)
                          .withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
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
      ),
    );
  }

  // ================= Custom Divider =================
  Widget _buildDivider() {
    return Padding(
      padding: const EdgeInsets.only(
        left: 60,
        right: 20,
      ), // لترك مساحة للأيقونة
      child: Divider(height: 1, color: Colors.grey[200]),
    );
  }
}
