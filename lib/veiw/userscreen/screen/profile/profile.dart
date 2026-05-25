import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hos/core/conistant/imageasset.dart';
import 'package:hos/core/conistant/routs.dart';
import 'package:hos/core/serveces/myservisec.dart';
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      OrderCard("الطلبات و\nالمشتريات", Imageasset.order, () {
                        Get.toNamed(Approute.Orders);
                      }),
                      OrderCard("نقاط\nالمكافأه", Imageasset.goold, () {}),
                      OrderCard(
                        "الاعدادات و\nالخصوصيه",
                        Imageasset.settings,
                        () {
                          Get.to(
                            () => Settings(),
                            transition: Transition.fadeIn,
                            duration: Duration(milliseconds: 400),
                            curve: Curves.fastOutSlowIn,
                          );
                        },
                      ),
                    ],
                  ),

                  _buildListTile(
                    gradientColors: [
                      const Color.fromARGB(255, 95, 182, 8),
                      const Color.fromARGB(255, 97, 97, 97),
                    ],
                    icon: Icons.location_on_outlined,
                    title: "Saved Addresses".tr,
                    onTap: () => Get.toNamed(Approute.viewmyaddres),
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
                    icon: Icons.settings_outlined,
                    title: "App Settings".tr,
                    isLast: true, // لإزالة الفاصل في العنصر الأخير
                    onTap: () => Get.to(
                      () => Settings(),
                      transition: Transition.leftToRightWithFade,
                      duration: Duration(milliseconds: 500),
                      curve: Curves.fastOutSlowIn,
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

Widget OrderCard(String title, String image, Function()? onTap) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.white.withOpacity(
            0.15,
          ), // الحواف المضيئة الخفيفة اللي باينة في الصورة
          width: 1,
        ),
        borderRadius: BorderRadius.circular(15),
        color: Colors.grey[600],
        gradient: RadialGradient(
          center: Alignment(0.0, -0.2), // مكان بؤرة الإضاءة (مرفوعة لفوق شوية)
          radius: 1.2,
          colors: [
            Color(0xFF555A60), // الدرجة الفاتحة المائل للرمادي/الفضي في المنتصف
            Color.fromARGB(255, 144, 148, 153), // الدرجة الأغمق اللي بتقفل على الأطراف
            Color(0xFF1A1C1E), 
            // الدرجة الداكنة جداً عند الزوايا
          ],
          stops: const [0.0, 0.6, 1.0],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            blurRadius: 10,
            offset: const Offset(0, 4), // الظل الخفيف تحت الكارت
          ),
        ],
      ),
      height: 300,
      width: 120,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(textAlign: TextAlign.center,
            title,
            style: TextStyle(
              fontSize: 25,
              color: Colors.grey[50],
              fontWeight: FontWeight.bold,
            ),
          ),
          Image.asset(
            filterQuality: FilterQuality.low,fit: BoxFit.cover,
            image,
            errorBuilder: (context, imageProvider, s) =>
                Icon(Icons.error_outline),
          ),
        ],
      ),
    ),
  );
}
