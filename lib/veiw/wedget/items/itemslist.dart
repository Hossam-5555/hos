import 'package:flutter/material.dart';
import 'package:hos/core/conistant/app_colors.dart';

/// شريط chips أفقي قابل لإعادة الاستخدام في أي مكان.
/// ياخد القائمة والـ index المختار وخلاص، من غير أي controller.
class ChipsBar extends StatelessWidget {
  const ChipsBar({
    super.key,
    required this.labels,
    required this.selectedIndex,
    required this.onSelected,
    this.height = 52,
    this.padding = const EdgeInsets.symmetric(horizontal: 8),
  });

  final List<String> labels;
  final int selectedIndex;
  final ValueChanged<int> onSelected;
  final double height;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: padding,
        itemCount: labels.length,
        itemBuilder: (_, i) => AppChip(
          label: labels[i],
          isSelected: i == selectedIndex,
          onTap: () => onSelected(i),
        ),
      ),
    );
  }
}

/// chip واحد (نفس تصميم BuildCategoryItems).
class AppChip extends StatelessWidget {
  const AppChip({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.icon = false,
  });

  const AppChip.brand({
    super.key,
    required this.label,
    this.icon,
    required this.isSelected,
    required this.onTap,
  });

  final bool? icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final chipBg = isDark
        ? AppColors.sortChipDarkBg
        : AppColors.sortChipLightBg;
    final chipBorder = isDark
        ? AppColors.sortChipDarkBorder
        : AppColors.sortChipLightBorder;
    final chipPrimary = isDark
        ? AppColors.sortChipDarkPrimary
        : AppColors.sortChipLightPrimary;
    final chipOnPrimary = isDark
        ? AppColors.sortChipDarkOnPrimary
        : AppColors.sortChipLightOnPrimary;
    final chipTextSecondary = isDark
        ? AppColors.sortChipDarkTextSecondary
        : AppColors.sortChipLightTextSecondary;

    return Padding(
      padding: const EdgeInsetsDirectional.only(end: 10),
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          margin: EdgeInsets.only(right: 2, bottom: 10, top: 2),
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 11),
          decoration: BoxDecoration(
            color: isSelected ? chipPrimary : chipBg,
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: isSelected ? chipPrimary : chipBorder),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon == true) ...[
                Icon(
                  Icons.discount,
                  size: 16,
                  color: isSelected ? chipOnPrimary : chipTextSecondary,
                ),
                const SizedBox(width: 5),
              ],
              Text(
                label,
                maxLines: 1,
                style: TextStyle(
                  fontSize: 13.5,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  color: isSelected ? chipOnPrimary : chipTextSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
