import 'package:flutter/material.dart';
import 'package:hos/core/conistant/app_colors.dart';
import 'package:jiffy/jiffy.dart';

// افترض أن كلاس AppColors موجود في نفس الملف أو تم عمل import له
// import 'app_colors.dart';

class NotificationCard extends StatelessWidget {
  final String title;
  final String body;
  final String time;
  final bool isSelected;
  final bool isLoading;
  final bool selectionMode;
  final void Function()? onLongPress;
  final void Function()? onTap;
  final bool isread;
  final IconData iconData;
  final Color colors;

  const NotificationCard({
    super.key,
    required this.title,
    required this.body,
    required this.time,
    required this.isSelected,
    required this.isLoading,
    required this.selectionMode,
    this.onLongPress,
    required this.isread,
    this.onTap,
    required this.colors,
    required this.iconData,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // --- Responsive Configuration ---
    // جعل الكارت متجاوباً مع حجم الشاشة (موبايل / تابلت)
    final screenWidth = MediaQuery.sizeOf(context).width;
    final bool isTablet = screenWidth > 600;

    final double basePadding = isTablet ? 24.0 : 16.0;
    final double titleFontSize = isTablet ? 17.0 : 15.0;
    final double bodyFontSize = isTablet ? 15.0 : 13.0;
    final double iconSize = isTablet ? 56.0 : 48.0;

    // --- استخدام AppColors ---
    final primaryColor = AppColors.primary;

    // تحويل الشفافية إلى Alpha (مثال: 0.2 تصبح 51 لأن 255 * 0.2 = 51)
    final cardBg = isSelected
        ? primaryColor.withAlpha(isDark ? 51 : 20)
        : (isDark ? AppColors.darkSurface : AppColors.lightSurface);

    final borderColor = isSelected
        ? primaryColor.withAlpha(102) // بدلاً من 0.4
        : (isDark
              ? AppColors.white.withAlpha(13) // بدلاً من 0.05
              : AppColors.black.withAlpha(10)); // بدلاً من 0.04

    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: isTablet ? 6 : 4,
        horizontal: isTablet ? 6 : 2,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onLongPress: onLongPress,
          onTap: onTap,
          borderRadius: BorderRadius.circular(22),
          splashColor: primaryColor.withAlpha(13), // بدلاً من 0.05
          highlightColor: primaryColor.withAlpha(5), // بدلاً من 0.02
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOutCubic,
            padding: EdgeInsets.all(basePadding),
            decoration: BoxDecoration(
              color: cardBg,
              borderRadius: BorderRadius.circular(22),
              border: Border.all(
                color: borderColor,
                width: isSelected ? 1.5 : 1,
              ),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: primaryColor.withAlpha(31), // بدلاً من 0.12
                        blurRadius: 8,
                        offset: const Offset(0, 0.5),
                      ),
                    ]
                  : [
                      BoxShadow(
                        color: AppColors.black.withAlpha(
                          isDark ? 77 : 8,
                        ), // بدلاً من 0.3 و 0.03
                        blurRadius: 8,
                        offset: const Offset(0, 0.5),
                      ),
                    ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // --- دائرة الاختيار بأسلوب iOS (تظهر في وضع التحديد) ---
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  transitionBuilder: (child, anim) =>
                      ScaleTransition(scale: anim, child: child),
                  child: selectionMode
                      ? Container(
                          margin: const EdgeInsetsDirectional.only(end: 12),
                          width: isTablet ? 26 : 22,
                          height: isTablet ? 26 : 22,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isSelected
                                ? primaryColor
                                : Colors.transparent,
                            border: Border.all(
                              color: isSelected
                                  ? primaryColor
                                  : (isDark
                                        ? AppColors.white.withAlpha(
                                            97,
                                          ) // بدلاً من Colors.white38
                                        : AppColors.black.withAlpha(
                                            66,
                                          )), // بدلاً من Colors.black26
                              width: 1.5,
                            ),
                          ),
                          child: isSelected
                              ? Icon(
                                  Icons.check_rounded,
                                  size: isTablet ? 16 : 14,
                                  color: AppColors.white,
                                )
                              : null,
                        )
                      : const SizedBox.shrink(),
                ),

                // --- قسم الأيقونة الجمالية ---
                Container(
                  height: iconSize,
                  width: iconSize,
                  decoration: BoxDecoration(
                    color: primaryColor.withAlpha(
                      isDark ? 38 : 20,
                    ), // بدلاً من 0.15 و 0.08
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    iconData,
                    color: colors,
                    size: isTablet ? 26 : 22,
                  ),
                ),
                SizedBox(width: isTablet ? 18 : 14),

                // --- قسم النصوص ---
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: titleFontSize,
                                letterSpacing: -0.3,
                                color: isDark
                                    ? AppColors.white
                                    : AppColors.black,
                              ),
                            ),
                          ),
                          if (!isLoading && time.isNotEmpty) ...[
                            const SizedBox(width: 8),
                            Text(
                              Jiffy.parse(time).fromNow(),
                              style: TextStyle(
                                fontSize: isTablet ? 14 : 12,
                                fontWeight: FontWeight.w400,
                                color: AppColors
                                    .mutedText, // لون موحد هادئ من الكلاس
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        body,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: (isDark ? AppColors.white : AppColors.black)
                              .withAlpha(153), // بدلاً من Opacity 0.6
                          fontSize: bodyFontSize,
                          height: 1.35,
                          letterSpacing: -0.1,
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
    );
  }
}
