import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hos/controler/usercontroller/profile/settingscontroller.dart';
import 'package:hos/core/conistant/imageasset.dart';
import 'package:hos/core/conistant/routs.dart';
import 'package:hos/core/localization/changlocal.dart';
import 'package:hos/core/serveces/myservisec.dart';
import 'package:hos/veiw/userscreen/screen/profile/review.dart';
import 'package:hos/veiw/userscreen/screen/profile/Editprofile.dart';
import 'package:hos/veiw/userscreen/screen/profile/about_us_page.dart';
import 'package:hos/veiw/wedget/bulidfooter.dart';
import 'package:hos/veiw/wedget/profiledailoge.dart';

class ProfilePage extends StatelessWidget {
  ProfilePage({super.key});

  // final Myservisec myservisec = Get.find();
  final SettingsController settingsController = Get.put(SettingsController());
  final LocalController localController = Get.put(LocalController());

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
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.only(
                left: horizontalPadding,
                right: horizontalPadding,
                top: 0,
                bottom: 20,
              ),
              child: Column(
                children: [
                  _ProfileHeader(
                    myservisec: settingsController.myservisec,
                    avatarRadius: avatarRadius,
                  ),
                  const SizedBox(height: 20),
                  settingsController.usrtype == "user"
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            orderCard(
                              "Orders".tr,
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
                              "Saved Addresses".tr,
                              Imageasset.settings,
                              () => Get.toNamed(Approute.viewmyaddres),
                              context,
                              width: cardWidth,
                              height: cardHeight,
                            ),
                          ],
                        )
                      : SizedBox.shrink(),
                  const SizedBox(height: 20),
                  _GroupLabel(title: "General"),

                  settingsController.usrtype == "user"
                      ? // ------- المفضلة / العناوين / المراجعات -------
                        _GradientGroup(
                          isDarkMode: isDarkMode,
                          children: [
                            _ListTile(
                              gradientColors: const [
                                Color.fromARGB(255, 95, 182, 8),
                                Color.fromARGB(255, 96, 192, 17),
                              ],
                              icon: Icons.person_pin,
                              title: "Edit Account".tr,
                              onTap: () {
                                Get.to(
                                  () => EditProfileView(),
                                  transition: Transition.cupertino,
                                  duration: const Duration(milliseconds: 500),
                                  curve: Curves.fastOutSlowIn,
                                );
                              },
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
                            _ThemeTile(controller: localController),
                          ],
                        )
                      : SizedBox.shrink(),

                  const SizedBox(height: 20),

                  // ------- الإعدادات: الثيم -------

                  // ------- الإعدادات: الدعم -------
                  _GroupLabel(title: "Support".tr),
                  _GradientGroup(
                    isDarkMode: isDarkMode,
                    children: [
                      _ListTile(
                        gradientColors: [
                          Colors.teal.shade400,
                          Colors.teal.shade700,
                        ],
                        icon: Icons.info_outline,
                        title: "About App".tr,
                        subtitle: '${"version".tr} 1.0.0',
                        onTap: () => Get.to(
                          () => EnglishAbout(),
                          transition: Transition.cupertino,
                        ),
                      ),
                      _ListTile(
                        gradientColors: [
                          Colors.orange.shade400,
                          Colors.orange.shade700,
                        ],
                        icon: Icons.language_outlined,
                        title: "Language".tr,
                        onTap: () => _showLanguageDialog(context),
                      ),
                      _ListTile(
                        gradientColors: [
                          Colors.cyan.shade400,
                          Colors.cyan.shade700,
                        ],
                        icon: Icons.headset_mic_outlined,
                        title: "Contact Us".tr,
                        onTap: settingsController.makePhoneCall,
                        trailing: Obx(
                          () => settingsController.isLoading.value
                              ? const SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  color: Colors.grey[400],
                                  size: 16,
                                ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // ------- تسجيل الخروج -------
                  _GroupLabel(title: "Session".tr),
                  _GradientGroup(
                    isDarkMode: isDarkMode,
                    children: [
                      _ListTile(
                        gradientColors: [
                          Colors.red.shade400,
                          Colors.red.shade700,
                        ],
                        icon: Icons.logout_rounded,
                        title: "Logout".tr,
                        titleColor: Colors.red.shade600,
                        showArrow: false,
                        onTap: () =>
                            _confirmLogout(context, settingsController),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),
                  buildFooter(),
                ],
              ),
            ),
          ),
        ),
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
              localController.changeLang('ar');
              Get.back();
            },
          ),
          const SizedBox(height: 4),
          _languageOption(
            label: "English",
            icon: Icons.language,
            color: Colors.blue,
            onTap: () {
              localController.changeLang('en');
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

// ---------------- عنوان مجموعة (Account / Support / Session) ----------------
class _GroupLabel extends StatelessWidget {
  final String title;
  const _GroupLabel({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(start: 6, bottom: 8),
      child: Align(
        alignment: AlignmentDirectional.centerStart,
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
    );
  }
}

// ---------------- الكونتينر الزجاجي الموحّد لكل مجموعة عناصر ----------------
class _GradientGroup extends StatelessWidget {
  final bool isDarkMode;
  final List<Widget> children;

  const _GradientGroup({required this.isDarkMode, required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        gradient: isDarkMode
            ? AppGradients.darkTitanium
            : AppGradients.lightPlatinum,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.withAlpha(50)),
      ),
      child: Column(children: children),
    );
  }
}

class _ListTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;
  final List<Color>? gradientColors;
  final Widget? trailing;
  final Color? titleColor;
  final bool showArrow;

  const _ListTile({
    required this.icon,
    required this.title,
    required this.onTap,
    this.subtitle,
    this.gradientColors,
    this.trailing,
    this.titleColor,
    this.showArrow = true,
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: titleColor,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      subtitle!,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            trailing ??
                (showArrow
                    ? Icon(
                        Icons.arrow_forward_ios_rounded,
                        color: Colors.grey[400],
                        size: 16,
                      )
                    : const SizedBox.shrink()),
          ],
        ),
      ),
    );
  }
}

// ---------------- عنصر الثيم (Dark/Light) بنفس منطق GetX الأصلي ----------------
class _ThemeTile extends StatelessWidget {
  final LocalController controller;
  const _ThemeTile({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      bool isDark = controller.selectedTheme.value == 'Dark';

      return Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                gradient: LinearGradient(
                  colors: [Colors.purple.shade400, Colors.purple.shade700],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.purple.withOpacity(0.3),
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Icon(
                Icons.palette_outlined,
                color: Colors.white,
                size: 22,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Theme'.tr,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    (isDark ? 'Dark mode' : 'Light mode').tr,
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                  ),
                ],
              ),
            ),
            GestureDetector(
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
          ],
        ),
      );
    });
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
              : Colors.black.withOpacity(0.09),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDarkMode ? 0.35 : 0.12),
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
                decoration: BoxDecoration(
                  color: isDarkMode
                      ? Colors.white.withOpacity(0.04)
                      : Colors.black.withOpacity(0.025),
                ),
                child: Image.asset(image, fit: BoxFit.cover),
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
                    color: isDarkMode ? Colors.white : Colors.black87,
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
    colors: [Color(0xFFFFFFFF), Color(0xFFF1F3F5), Color(0xFFDDE1E6)],
  );
}
