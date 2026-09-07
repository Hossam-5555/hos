import 'package:flutter/material.dart';
import 'package:hos/data/model/categoriesmodel.dart';

class BuildCategoryItems extends StatelessWidget {
  final CategoriesModel catmodel;
  final bool isSelected;
  final VoidCallback onTap;

  const BuildCategoryItems({
    super.key,
    required this.catmodel,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final String name = catmodel.name ?? "";

    final isDarkMode =
        Theme.of(context).brightness == Brightness.dark;

    final borderGradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      stops: const [0.0, 0.5, 1.0],
      colors: isSelected
          ? (isDarkMode
              ? [
                  const Color.fromARGB(255, 145, 40, 45).withOpacity(0.8),
                  Colors.transparent,
                  Colors.white.withOpacity(0.3),
                ]
              : [
                  Colors.blue.withAlpha(125),
                  Colors.transparent,
                  Colors.blueAccent.withOpacity(0.2),
                ])
          : (isDarkMode
              ? [
                  Colors.white.withOpacity(0.1),
                  Colors.transparent,
                  Colors.white.withOpacity(0.02),
                ]
              : [
                  Colors.grey.shade300,
                  Colors.transparent,
                  Colors.grey.shade100,
                ]),
    );

    final innerColor = isSelected
        ? (isDarkMode ? const Color(0xFF120F11) : Colors.white)
        : (isDarkMode
            ? Colors.white.withOpacity(0.03)
            : Colors.grey.shade50);

    final boxShadow = isSelected
        ? [
            BoxShadow(
              color: isDarkMode
                  ? Colors.black.withOpacity(0.3)
                  : Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ]
        : <BoxShadow>[];

    return Padding(
      padding: const EdgeInsets.only(
        right: 10,
        bottom: 5,
        top: 5,
      ),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.fastLinearToSlowEaseIn,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          gradient: borderGradient,
          boxShadow: boxShadow,
        ),
        padding: const EdgeInsets.all(1.5),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.fastLinearToSlowEaseIn,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28.5),
            color: innerColor,
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(28.5),

              // هنا الـ Widget مش عارف إيه اللي هيحصل
              onTap: onTap,

              splashColor:
                  isDarkMode ? Colors.white10 : Colors.black12,
              highlightColor: Colors.transparent,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildTextSection(
                      isSelected,
                      name,
                      isDarkMode,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextSection(
    bool isSelected,
    String title,
    bool isDarkMode,
  ) {
    final activeColor =
        isDarkMode ? Colors.white : Colors.blue;

    final inactiveColor =
        isDarkMode ? Colors.grey.shade400 : Colors.grey.shade600;

    return AnimatedDefaultTextStyle(
      duration: const Duration(milliseconds: 300),
      style: TextStyle(
        color: isSelected ? activeColor : inactiveColor,
        fontSize: 14,
        fontWeight:
            isSelected ? FontWeight.bold : FontWeight.w500,
        letterSpacing: 0.3,
      ),
      child: Text(title),
    );
  }
}