import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hos/core/conistant/imageasset.dart';
import 'package:hos/core/conistant/routs.dart';
import 'package:hos/core/serveces/myservisec.dart';
import 'package:hos/veiw/userscreen/screen/profile/review.dart';
import 'package:hos/veiw/userscreen/screen/profile/settings/settings.dart';

class ProfilePage extends StatelessWidget {
  ProfilePage({super.key});

  final Myservisec myservisec = Get.find();

  // لون أساسي مريح للتطبيق يمكن تغييره حسب الهوية البصرية لمشروعك
  final Color primaryColor = const Color.fromARGB(
    255,
    44,
    46,
    46,
  ); // لون نيلي عصري

  @override
  Widget build(BuildContext context) {
    // final h = Get.height;
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildProfileHeader(Colors.black),

            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      orderCard("الطلبات و\nالمشتريات", Imageasset.order, () {
                        Get.toNamed(Approute.Orders);
                      }, context),
                      orderCard(
                        "نقاط\nالمكافأه",
                        Imageasset.goold,
                        () {},
                        context,
                      ),
                      orderCard(
                        "App Settings and Privacy".tr,
                        Imageasset.settings,
                        () {
                          Get.to(
                            () => Settings(),
                            transition: Transition.fadeIn,
                            duration: Duration(milliseconds: 400),
                            curve: Curves.fastOutSlowIn,
                          );
                        },
                        context,
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Container(
                    padding: EdgeInsets.all(5),
                    margin: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      gradient: isDarkMode
                          ? AppGradients.darkTitanium
                          : AppGradients.lightPlatinum,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.grey.withAlpha(50)),
                    ),
                    child: Column(
                      children: [
                        _buildListTile(
                          gradientColors: [
                            const Color.fromARGB(255, 95, 182, 8),
                            const Color.fromARGB(255, 96, 192, 17),
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
                          icon: Icons.note_alt_sharp,
                          title: "مراجعاتي",
                          isLast: true, // لإزالة الفاصل في العنصر الأخير
                          onTap: () => Get.to(
                            () => MyReviewsPage(),
                            transition: Transition.cupertino,
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
              decoration: BoxDecoration(shape: BoxShape.circle),
              child: CircleAvatar(
                radius: 55,
                // backgroundColor: Colors.blue,
                backgroundImage: AssetImage(Imageasset.twetter),
                onBackgroundImageError: (_, _) {},
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Text(
          userName,
          style: const TextStyle(
            fontSize: 20,
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
              padding: const EdgeInsets.all(5),
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

Widget orderCard(String title, String image, Function()? onTap, context) {
  bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
  return GestureDetector(
    onTap: onTap,
    child: ClipRRect(
      // تم تعديل BorderRadius لتجنب مشاكل الـ Geometry ولتتطابق مع الـ Container بالداخل
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          height: 240,
          width: 120,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            // الحواف المضيئة الخفيفة (نفس الـ Stroke اللي في الصورة)
            border: Border.all(color: Colors.white.withOpacity(0.18), width: 1),

            gradient: isDarkMode
                ? AppGradients.darkTitanium
                : AppGradients.lightPlatinum,
            // ظل خفيف جداً وناعم يتناسب مع الخلفية الغامقة
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.5),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 16.0,
              horizontal: 8.0,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment
                  .spaceBetween, // لتوزيع النص فوق والصورة تحت زي الصورة
              children: [
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize:
                        16, // تصغير الخط ليناسب عرض الكارت (120) ولا يحدث OverFlow
                    // color: Colors.white,
                    fontWeight: FontWeight.bold,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: Image.asset(
                    image,
                    filterQuality: FilterQuality.medium,
                    fit: BoxFit
                        .contain, // contain أفضل هنا عشان تفاصيل الـ 3D تظهر كاملة بدون قص
                    errorBuilder: (context, error, stackTrace) => const Icon(
                      Icons.error_outline,
                      color: Colors.white54,
                      size: 40,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}

class AppGradients {
  // 1. التدرج الداكن الفخم (ألوانك الأصلية) - ممتاز لخلفيات أو كروت الثيم الأسود
  static const LinearGradient darkTitanium = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFF4A4B4D), // مركز الإضاءة الفضي الداكن
      Color(0xFF232526), // الدرجة الوسطى الرمادية
      Color(0xFF111314), // الأطراف الداكنة
    ],
  );

  // 2. التدرج الفاتح المقابل (Silver/Platinum) - ممتاز لخلفيات أو كروت الثيم الأبيض
  static const LinearGradient lightPlatinum = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFFFFFFFF),
      Color(0xFFD0D5DD), // الأطراف الفضية الراقية
      // مركز الإضاءة الأبيض المشع
      Color(0xFFF2F4F7), // البلاتينيوم الناعم
    ],
  );
}
