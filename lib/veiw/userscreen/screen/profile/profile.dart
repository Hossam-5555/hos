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
import 'package:hos/veiw/wedget/profile/swicthsetting.dart';

class ProfilePage extends StatelessWidget {
  ProfilePage({super.key});

  final SettingsController settingsController = Get.put(SettingsController());
  final LocalController localController = Get.put(LocalController());
  bool get isadmin => settingsController.usrtype == Static.admin;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final size = MediaQuery.sizeOf(context);
    final width = size.width;
    final height = size.height;

    final isTablet = width >= 600;
    final maxContentWidth = width >= 900 ? 850.0 : double.infinity;

    // دوال التناسب الديناميكية بدلاً من القيم الثابتة
    double wp(double percent) => width * percent;
    double hp(double percent) => height * percent;
    double sp(double baseSize) =>
        (width * (baseSize / 375)).clamp(baseSize * 0.85, baseSize * 1.3);

    final horizontalPadding = isTablet ? wp(0.03) : wp(0.035);
    final gapBetweenCards = (width * 0.03).clamp(10.0, 20.0);

    final effectiveWidth = width < maxContentWidth ? width : maxContentWidth;
    final contentWidth = effectiveWidth - (horizontalPadding * 2);
    final cardWidth = (contentWidth - gapBetweenCards) / 2;
    final cardHeight = (cardWidth * 1.15).clamp(135.0, 240.0);

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
                top: hp(0.01),
                bottom: hp(0.02),
              ),
              child: Column(
                children: [
                  SizedBox(height: hp(0.012)),
                  _GroupLabel(title: "QUICK ACCESS".tr, w: width, sp: sp),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                        sp: sp,
                      ),
                      SizedBox(width: gapBetweenCards),
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
                        sp: sp,
                      ),
                    ],
                  ),

                  SizedBox(height: hp(0.018)),
                  _GroupLabel(title: "General".tr, w: width, sp: sp),

                  // ------- المفضلة / اللغة / الثيم -------
                  _GradientGroup(
                    isDarkMode: isDarkMode,
                    w: width,
                    children: [
                      if (settingsController.usrtype == Static.user1)
                        _ListTile(
                          w: width,
                          sp: sp,
                          gradientColors: const [
                            AppColors.favoriteStart,
                            AppColors.favoriteEnd,
                          ],
                          icon: Icons.favorite_border,
                          title: "Favorite".tr,
                          onTap: () => Get.toNamed(Approute.myfavorite),
                        ),
                      // التيم
                      Obx(() {
                        final isDark =
                            localController.selectedTheme.value == 'Dark';
                        return SettingSwitchTile(
                          icon: Icons.palette_outlined,
                          gradient: [AppColors.themeStart, AppColors.themeEnd],
                          title: 'Theme'.tr,
                          subtitle: (isDark ? 'Dark mode' : 'Light mode').tr,
                          value: isDark,
                          onChanged: localController.changeTheme,
                          activeColor: Colors.black,
                          inactiveColor: Colors.white,
                          onThumb: const Icon(
                            Icons.dark_mode_outlined,
                            color: Colors.white,
                          ),
                          offThumb: const Icon(
                            Icons.sunny,
                            color: AppColors.themeLightIcon,
                          ),
                        );
                      }),

                      // اللغة
                      Obx(() {
                        final isArabic =
                            localController.selectedLanguage.value == 'ar';
                        return SettingSwitchTile(
                          icon: Icons.language_rounded,
                          gradient: [
                            AppColors.languageStart,
                            AppColors.languageEnd,
                          ],
                          title: 'Language'.tr,
                          subtitle: isArabic ? 'العربية' : 'English',
                          value: isArabic,
                          onChanged: (v) =>
                              localController.changeLang(v ? 'ar' : 'en'),
                          activeColor: AppColors.languageStart,
                          inactiveColor: AppColors.iconscolor,
                          onThumb: const Text(
                            'ع',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          offThumb: const Text(
                            'EN',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 11,
                            ),
                          ),
                        );
                      }),
                    ],
                  ),

                  SizedBox(height: hp(0.018)),

                  // ------- الإعدادات: الدعم -------
                  _GroupLabel(title: "Support".tr, w: width, sp: sp),
                  _GradientGroup(
                    isDarkMode: isDarkMode,
                    w: width,
                    children: [
                      _ListTile(
                        w: width,
                        sp: sp,
                        gradientColors: const [
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
                        w: width,
                        sp: sp,
                        gradientColors: const [
                          AppColors.contactStart,
                          AppColors.contactEnd,
                        ],
                        icon: Icons.headset_mic_outlined,
                        title: "Contact Us".tr,
                        onTap: () {
                          settingsController.openWhatsApp(
                            phone: '201023426561',
                            message: 'مرحباً، أود الاستفسار عن بعض الخدمات',
                          );
                        },
                        subtitle: "Chat with our support team",
                        trailing: Obx(
                          () => settingsController.isLoading.value
                              ? SizedBox(
                                  width: sp(18),
                                  height: sp(18),
                                  child: const CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  color: AppColors.mutedText,
                                  size: sp(16),
                                ),
                        ),
                      ),
                      _ListTile(
                        w: width,
                        sp: sp,
                        gradientColors: const [
                          AppColors.logoutStart,
                          AppColors.logoutEnd,
                        ],
                        icon: Icons.logout_rounded,
                        title: "Logout".tr,
                        titleColor: AppColors.logout,
                        showArrow: false,
                        onTap: () => _confirmLogout(
                          context,
                          settingsController,
                          width,
                          sp,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: hp(0.025)),
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
  void _confirmLogout(
    BuildContext context,
    SettingsController controller,
    double w,
    double Function(double) sp,
  ) {
    Get.defaultDialog(
      title: "Logout".tr,
      titleStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: sp(18)),
      middleText: "Are you sure you want to logout?".tr,
      middleTextStyle: TextStyle(fontSize: sp(14)),
      radius: (w * 0.04).clamp(14.0, 22.0),
      cancel: TextButton(
        onPressed: () => Get.back(),
        child: Text(
          "Cancel".tr,
          style: TextStyle(color: AppColors.mutedText, fontSize: sp(14)),
        ),
      ),
      confirm: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.logout,
          padding: EdgeInsets.symmetric(
            horizontal: (w * 0.05).clamp(16.0, 28.0),
            vertical: (w * 0.02).clamp(8.0, 14.0),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular((w * 0.03).clamp(10.0, 16.0)),
          ),
        ),
        onPressed: () {
          Get.back();
          controller.logout();
        },
        child: Text(
          "Logout".tr,
          style: TextStyle(color: Colors.white, fontSize: sp(14)),
        ),
      ),
    );
  }
}

// ---------------- عنوان مجموعة (Account / Support / Session) ----------------
class _GroupLabel extends StatelessWidget {
  final String title;
  final double w;
  final double Function(double) sp;

  const _GroupLabel({required this.title, required this.w, required this.sp});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.only(
        start: (w * 0.018).clamp(6.0, 14.0),
        bottom: (w * 0.02).clamp(6.0, 12.0),
      ),
      child: Align(
        alignment: AlignmentDirectional.centerStart,
        child: Text(
          title.toUpperCase(),
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: sp(12.5),
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
  final double w;

  const _GradientGroup({
    required this.isDarkMode,
    required this.children,
    required this.w,
  });

  @override
  Widget build(BuildContext context) {
    final radius = (w * 0.05).clamp(16.0, 26.0);
    return Container(
      padding: EdgeInsets.all((w * 0.015).clamp(4.0, 10.0)),
      decoration: BoxDecoration(
        boxShadow: const [
          BoxShadow(
            blurRadius: 6,
            color: AppColors.shadow,
            offset: Offset(0, 0.2),
          ),
        ],
        gradient: isDarkMode
            ? AppGradients.darkTitanium
            : AppGradients.lightPlatinum,
        borderRadius: BorderRadius.circular(radius),
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
  final double w;
  final double Function(double) sp;

  const _ListTile({
    required this.icon,
    required this.title,
    required this.onTap,
    required this.w,
    required this.sp,
    this.subtitle,
    this.gradientColors,
    this.trailing,
    this.titleColor,
    this.showArrow = true,
  });

  @override
  Widget build(BuildContext context) {
    final tilePadding = (w * 0.028).clamp(10.0, 16.0);
    final iconPadding = (w * 0.018).clamp(6.0, 10.0);
    final iconRadius = (w * 0.028).clamp(10.0, 14.0);

    return InkWell(
      borderRadius: BorderRadius.circular(iconRadius),
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.all(tilePadding),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(iconPadding),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(iconRadius),
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
                        .withAlpha(76),
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(icon, color: Colors.white, size: sp(22)),
            ),
            SizedBox(width: (w * 0.04).clamp(12.0, 20.0)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: sp(15.5),
                      fontWeight: FontWeight.w500,
                      color: titleColor,
                    ),
                  ),
                  if (subtitle != null) ...[
                    SizedBox(height: (w * 0.006).clamp(2.0, 5.0)),
                    Text(
                      subtitle!,
                      style: TextStyle(
                        fontSize: sp(12),
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
                        size: sp(16),
                      )
                    : const SizedBox.shrink()),
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
  required double width,
  required double height,
  required double Function(double) sp,
}) {
  final isDarkMode = Theme.of(context).brightness == Brightness.dark;
  final cardRadius = (width * 0.12).clamp(18.0, 28.0);

  return GestureDetector(
    onTap: onTap,
    child: Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(cardRadius),
        gradient: isDarkMode
            ? AppGradients.darkTitanium
            : AppGradients.lightPlatinum,
        border: Border.all(
          color: isDarkMode ? AppColors.darkBorder : AppColors.lightBorder,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: isDarkMode
                ? AppColors.darkShadow.withAlpha(20)
                : AppColors.lightShadow,
            blurRadius: 8,
            offset: const Offset(0, 0.2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(cardRadius),
        child: Column(
          children: [
            // =========================
            // صورة البطاقة
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
            // عنوان البطاقة
            // =========================
            Expanded(
              flex: 3,
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(
                  horizontal: (width * 0.06).clamp(8.0, 16.0),
                  vertical: (height * 0.04).clamp(6.0, 12.0),
                ),
                decoration: BoxDecoration(
                  color: isDarkMode
                      ? AppColors.darkCardSurface
                      : AppColors.lightCardSurface,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(cardRadius),
                    bottomRight: Radius.circular(cardRadius),
                  ),
                ),
                alignment: Alignment.center,
                child: Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: sp(14.5),
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
