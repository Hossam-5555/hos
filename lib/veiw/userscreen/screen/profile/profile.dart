import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hos/controler/usercontroller/profile/settingscontroller.dart';
import 'package:hos/core/conistant/app_colors.dart';
import 'package:hos/core/conistant/imageasset.dart';
import 'package:hos/core/conistant/routs.dart';
import 'package:hos/core/conistant/static.dart';
import 'package:hos/core/localization/changlocal.dart';
import 'package:hos/veiw/adminscreen/brands/brandveiw.dart';
import 'package:hos/veiw/userscreen/screen/profile/about_us_page.dart';
import 'package:hos/veiw/wedget/bulidfooter.dart';

class ProfilePage extends StatelessWidget {
  ProfilePage({super.key});

  // final Myservisec myservisec = Get.find();
  final SettingsController settingsController = Get.put(SettingsController());
  final LocalController localController = Get.put(LocalController());
  bool get isadmin => settingsController.usrtype == Static.admin;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final width = MediaQuery.sizeOf(context).width;
    final isTablet = width >= 600;
    final maxContentWidth = width >= 900 ? 900.0 : double.infinity;
    final horizontalPadding = isTablet ? 20.0 : 8.0;
    final contentWidth =
        (width < maxContentWidth ? width : maxContentWidth) -
        horizontalPadding * 2;
    final cardWidth = (contentWidth - 12) / 2;
    final cardHeight = (cardWidth * 1.35).clamp(140.0, 240.0);

    return Scaffold(
      body: SafeArea(
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
                  const SizedBox(height: 20),
                  _GroupLabel(title: "QUICK ACCESS".tr),

                  Row(
                    children: [
                      orderCard(
                        !isadmin ? "Orders".tr : "Brands".tr,
                        isadmin ? Imageasset.pending : Imageasset.order,
                        () {
                          isadmin
                              ? Get.to(() => const AdminBrandsPage())
                              : Get.toNamed(Approute.Orders);
                        },
                        context,
                        width: cardWidth,
                        height: cardHeight,
                      ),
                      const SizedBox(width: 12),
                      orderCard(
                        isadmin ? "Coupons".tr : "Saved Addresses".tr,
                        isadmin ? Imageasset.processing : Imageasset.settings,
                        () {
                          isadmin
                              ? Get.toNamed(Approute.coupon)
                              : Get.toNamed(Approute.viewmyaddres);
                        },
                        context,
                        width: cardWidth,
                        height: cardHeight,
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),
                  _GroupLabel(title: "General".tr),

                  // ------- المفضلة / العناوين / المراجعات -------
                  _GradientGroup(
                    isDarkMode: isDarkMode,
                    children: [
                      settingsController.usrtype == Static.user1
                          ? _ListTile(
                              gradientColors: const [
                                AppColors.favoriteStart,
                                AppColors.favoriteEnd,
                              ],
                              icon: Icons.favorite_border,
                              title: "Favorite".tr,
                              onTap: () => Get.toNamed(Approute.myfavorite),
                            )
                          : SizedBox.shrink(),
                      _ListTile(
                        gradientColors: [
                          AppColors.languageStart,
                          AppColors.languageEnd,
                        ],
                        icon: Icons.language_outlined,
                        title: "Languages".tr,
                        onTap: () => _showLanguageDialog(context),
                      ),
                      _ThemeTile(controller: localController),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // ------- الإعدادات: الثيم -------

                  // ------- الإعدادات: الدعم -------
                  _GroupLabel(title: "Support".tr),
                  _GradientGroup(
                    isDarkMode: isDarkMode,
                    children: [
                      _ListTile(
                        gradientColors: [
                          AppColors.aboutStart,
                          AppColors.aboutEnd,
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
                          AppColors.contactStart,
                          AppColors.contactEnd,
                        ],
                        icon: Icons.headset_mic_outlined,
                        title: "Contact Us".tr,
                        onTap: () {
                          settingsController.openWhatsApp(
                            phone:
                                '201023426561', // اكتب رقمك هنا مع كود الدولة
                            message:
                                'مرحباً، أود الاستفسار عن بعض الخدمات', // رسالة ترحيبية اختيارية
                          );
                        },
                        subtitle: "Chat with our support team",
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
                                  color: AppColors.mutedText,
                                  size: 16,
                                ),
                        ),
                      ),
                      _ListTile(
                        gradientColors: [
                          AppColors.logoutStart,
                          AppColors.logoutEnd,
                        ],
                        icon: Icons.logout_rounded,
                        title: "Logout".tr,
                        titleColor: AppColors.logout,
                        showArrow: false,
                        onTap: () =>
                            _confirmLogout(context, settingsController),
                      ),
                    ],
                  ),

                  // ------- تسجيل الخروج -------
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
        child: Text("Cancel".tr, style: TextStyle(color: AppColors.mutedText)),
      ),
      confirm: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.logout,
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
            color: AppColors.arabic,
            onTap: () {
              localController.changeLang('ar');
              Get.back();
            },
          ),
          const SizedBox(height: 4),
          _languageOption(
            label: "English",
            icon: Icons.language,
            color: AppColors.english,
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
            color: AppColors.mutedText,
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
        boxShadow: [
          BoxShadow(
            blurRadius: 6,
            color: AppColors.shadow,
            offset: Offset(0, 0.2),
          ),
        ],
        gradient: isDarkMode
            ? AppGradients.darkTitanium
            : AppGradients.lightPlatinum,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
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
                      [AppColors.primaryStart, AppColors.primaryEnd],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: (gradientColors?.last ?? AppColors.primaryEnd)
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
                        color: AppColors.mutedText,
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
                        color: AppColors.mutedText,
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
                  colors: [AppColors.themeStart, AppColors.themeEnd],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.themeEnd.withOpacity(0.3),
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
                    style: TextStyle(fontSize: 12, color: AppColors.mutedText),
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
                  color: isDark ? Colors.black : Colors.white,
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
                            Icons.dark_mode_outlined,
                            key: ValueKey('dark'),
                            color: Colors.white,
                            size: 20,
                          )
                        : const Icon(
                            Icons.lightbulb_outline_rounded,
                            key: ValueKey('light'),
                            color: AppColors.themeLightIcon,
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
  double width = 250,
  double height = 200,
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
          color: isDarkMode ? AppColors.darkBorder : AppColors.lightBorder,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: isDarkMode ? AppColors.darkShadow : AppColors.lightShadow,
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
              flex: 6,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: isDarkMode
                      ? AppColors.darkImageSurface
                      : AppColors.lightImageSurface,
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
                      ? AppColors.darkCardSurface
                      : AppColors.lightCardSurface,
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
