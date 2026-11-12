import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hos/core/conistant/app_colors.dart';
import 'package:hos/core/localization/changlocal.dart';

class ThemeTile extends StatelessWidget {
  final LocalController controller;
  const ThemeTile({required this.controller});

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