import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hos/core/conistant/imageasset.dart';
import 'package:hos/core/conistant/routs.dart';
import 'package:hos/core/serveces/myservisec.dart';
import 'package:hos/veiw/userscreen/screen/profile/review.dart';
import 'package:hos/veiw/userscreen/screen/profile/settings/settings.dart';
import 'package:hos/veiw/wedget/profiledailoge.dart';

class ProfilePage extends StatelessWidget {
  ProfilePage({super.key});

  final Myservisec myservisec = Get.find();

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final width = MediaQuery.of(context).size.width;
    final isTablet = width >= 600;

    final maxContentWidth = isTablet ? 720.0 : double.infinity;
    final horizontalPadding = isTablet ? 24.0 : 8.0;
    final avatarRadius = isTablet ? 58.0 : 46.0;
    final cardGap = isTablet ? 20.0 : 10.0;
    final cardWidth =
        (width.clamp(0, maxContentWidth) -
            horizontalPadding * 2 -
            cardGap * 2) /
        3;
    final cardHeight = (cardWidth * (isTablet ? 1.3 : 1.9)).clamp(120.0, 240.0);

    return Scaffold(
      body: SafeArea(
        top: false,
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxContentWidth),
            child: SingleChildScrollView(
              padding: EdgeInsets.only(
                left: horizontalPadding,
                right: horizontalPadding,
                top: 0,
                bottom: 20,
              ),
              child: Column(
                children: [
                  _ProfileHeader(
                    myservisec: myservisec,
                    avatarRadius: avatarRadius,
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      orderCard(
                        "الطلبات و\nالمشتريات",
                        Imageasset.order,
                        () => Get.toNamed(Approute.Orders),
                        context,
                        width: cardWidth,
                        height: cardHeight,
                      ),
                      orderCard(
                        "نقاط\nالمكافأه",
                        Imageasset.goold,
                        () => ComingSoonOverlay.show(),
                        context,
                        width: cardWidth,
                        height: cardHeight,
                      ),
                      orderCard(
                        "App Settings and Privacy".tr,
                        Imageasset.settings,
                        () => Get.to(
                          () => Settings(),
                          transition: Transition.fadeIn,
                          duration: const Duration(milliseconds: 400),
                          curve: Curves.fastOutSlowIn,
                        ),
                        context,
                        width: cardWidth,
                        height: cardHeight,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      gradient: isDarkMode
                          ? AppGradients.darkTitanium
                          : AppGradients.lightPlatinum,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.grey.withAlpha(50)),
                    ),
                    child: Column(
                      children: [
                        _ListTile(
                          gradientColors: const [
                            Color.fromARGB(255, 95, 182, 8),
                            Color.fromARGB(255, 96, 192, 17),
                          ],
                          icon: Icons.location_on_outlined,
                          title: "Saved Addresses".tr,
                          onTap: () => Get.toNamed(Approute.viewmyaddres),
                        ),
                        _ListTile(
                          gradientColors: const [
                            Color.fromARGB(255, 243, 9, 9),
                            Colors.red,
                          ],
                          icon: Icons.favorite_border,
                          title: "Favorite".tr,
                          onTap: () => Get.toNamed(Approute.myfavorite),
                        ),
                        _ListTile(
                          icon: Icons.note_alt_sharp,
                          title: "مراجعاتي",
                          onTap: () => Get.to(
                            () => MyReviewsPage(),
                            transition: Transition.cupertino,
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.fastOutSlowIn,
                          ),
                        ),
                      ],
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
}

class _ProfileHeader extends StatelessWidget {
  final Myservisec myservisec;
  final double avatarRadius;

  const _ProfileHeader({required this.myservisec, required this.avatarRadius});

  @override
  Widget build(BuildContext context) {
    final userName =
        myservisec.sharedPreferences.getString("usersname") ?? "User Name";
    final email =
        myservisec.sharedPreferences.getString("email") ?? "user@email.com";

    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  padding: const EdgeInsets.all(3),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [Colors.black54, Colors.black],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: CircleAvatar(
                    radius: avatarRadius,
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                    backgroundImage: AssetImage(Imageasset.twetter),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.green,
                      border: Border.all(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        width: 2,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              userName,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
                letterSpacing: 0.3,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            Text(
              email,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(
                  context,
                ).textTheme.bodySmall?.color?.withValues(alpha: 0.7),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

class _ListTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final List<Color>? gradientColors;

  const _ListTile({
    required this.icon,
    required this.title,
    required this.onTap,
    this.gradientColors,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
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
              child: Icon(icon, color: Colors.white, size: 22),
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

Widget orderCard(
  String title,
  String image,
  VoidCallback onTap,
  BuildContext context, {
  double width = 160,
  double height = 240,
}) {
  final isDarkMode = Theme.of(context).brightness == Brightness.dark;

  return GestureDetector(
    onTap: onTap,
    child: Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: isDarkMode
            ? AppGradients.darkTitanium
            : AppGradients.lightPlatinum,
        border: Border.all(
          color: isDarkMode
              ? Colors.white.withOpacity(0.10)
              : Colors.black.withOpacity(0.08),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(
              isDarkMode ? 0.35 : 0.12,
            ),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Column(
          children: [

            // =========================
            // صورة المنتج
            // =========================
            Expanded(
              flex: 7,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isDarkMode
                      ? Colors.white.withOpacity(0.04)
                      : Colors.black.withOpacity(0.025),
                ),
                child: Image.asset(
                  image,
                  fit: BoxFit.contain,
                ),
              ),
            ),

            // =========================
            // اسم المنتج
            // =========================
            Expanded(
              flex: 3,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: isDarkMode
                      ? Colors.black.withOpacity(0.18)
                      : Colors.white.withOpacity(0.45),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(24),
                    bottomRight: Radius.circular(24),
                  ),
                ),
                alignment: Alignment.center,
                child: Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    height: 1.2,
                    fontWeight: FontWeight.w700,
                    color: isDarkMode
                        ? Colors.white
                        : Colors.black87,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

class AppGradients {
  static const LinearGradient darkTitanium = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF4A4B4D), Color(0xFF232526), Color(0xFF111314)],
  );

 static const LinearGradient lightPlatinum = LinearGradient(
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
  colors: [
    Color(0xFFFFFFFF),
    Color(0xFFF1F3F5),
    Color(0xFFDDE1E6),
  ],
);
}
