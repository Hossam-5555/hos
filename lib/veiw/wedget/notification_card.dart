import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';

// ignore: must_be_immutable
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

  NotificationCard({
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
    required this.iconData
  });
   IconData iconData;
   Color colors;

 

  @override
  Widget build(BuildContext context) {
    
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // ألوان نمط Apple
    final primaryColor = const Color(0xFF007AFF); // iOS System Blue
    final cardBg = isSelected
        ? primaryColor.withOpacity(isDark ? 0.2 : 0.08)
        : (isDark ? const Color(0xFF1C1C1E) : const Color(0xFFFFFFFF));

    final borderColor = isSelected
        ? primaryColor.withOpacity(0.4)
        : (isDark
              ? Colors.white.withOpacity(0.05)
              : Colors.black.withOpacity(0.04));

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 2),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onLongPress: onLongPress,
          onTap: onTap,
          borderRadius: BorderRadius.circular(22),
          splashColor: primaryColor.withOpacity(0.05),
          highlightColor: primaryColor.withOpacity(0.02),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOutCubic,
            padding: const EdgeInsets.all(16),
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
                        color: primaryColor.withOpacity(0.12),
                        blurRadius: 16,
                        offset: const Offset(0, 4),
                      ),
                    ]
                  : [
                      BoxShadow(
                        color: Colors.black.withOpacity(isDark ? 0.3 : 0.03),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
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
                          margin: const EdgeInsets.only(right: 12),
                          width: 22,
                          height: 22,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isSelected
                                ? primaryColor
                                : Colors.transparent,
                            border: Border.all(
                              color: isSelected
                                  ? primaryColor
                                  : (isDark ? Colors.white38 : Colors.black26),
                              width: 1.5,
                            ),
                          ),
                          child: isSelected
                              ? const Icon(
                                  Icons.check_rounded,
                                  size: 14,
                                  color: Colors.white,
                                )
                              : null,
                        )
                      : const SizedBox.shrink(),
                ),

                // --- قسم الأيقونة الجمالية ---
                Container(
                  height: 48,
                  width: 48,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? primaryColor
                        : primaryColor.withOpacity(isDark ? 0.15 : 0.08),
                    borderRadius: BorderRadius.circular(16), // Rounded squircle
                  ),
                  child: Icon(
                    iconData, // أيقونة الأوردرات السلسة
                    color: colors,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 14),

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
                                fontSize: 15,
                                letterSpacing: -0.3,
                                color: isDark
                                    ? Colors.white
                                    : const Color(0xFF1D1D1F),
                              ),
                            ),
                          ),
                          if (!isLoading && time.isNotEmpty) ...[
                            const SizedBox(width: 8),
                            Text(
                              Jiffy.parse(time).fromNow(),
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: isDark
                                    ? const Color(0xFF8E8E93)
                                    : const Color(0xFF8E8E93),
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
                          color: isDark
                              ? const Color(0xFFEBEBF5).withOpacity(0.6)
                              : const Color(0xFF3C3C43).withOpacity(0.6),
                          fontSize: 13,
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
