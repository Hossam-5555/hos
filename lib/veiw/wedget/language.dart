import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hos/core/conistant/app_colors.dart';
import 'package:hos/core/localization/changlocal.dart';

class LanguageTile extends StatelessWidget {
  final LocalController controller;

  const LanguageTile({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isArabic = controller.selectedLanguage.value == 'ar';

      return Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                gradient: LinearGradient(
                  colors: [
                    AppColors.languageStart,
                    AppColors.languageEnd,
                  ],
                ),
              ),
              child: const Icon(
                Icons.language_rounded,
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
                    'Language'.tr,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    isArabic ? 'العربية' : 'English',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.mutedText,
                    ),
                  ),
                ],
              ),
            ),

            _languageButton(
              label: 'العربية',
              selected: isArabic,
              onTap: () => controller.changeLang('ar'),
            ),
            const SizedBox(width: 6),
            _languageButton(
              label: 'English',
              selected: !isArabic,
              onTap: () => controller.changeLang('en'),
            ),
          ],
        ),
      );
    });
  }

  Widget _languageButton({
    required String label,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 9,
        ),
        decoration: BoxDecoration(
          color: selected ? AppColors.languageStart : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: selected
                ? AppColors.languageStart
                : AppColors.mutedText.withAlpha(70),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: selected ? Colors.white : AppColors.mutedText,
          ),
        ),
      ),
    );
  }
}