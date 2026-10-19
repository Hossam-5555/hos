import 'package:flutter/material.dart';

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
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final borderGradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      stops: const [0.0, 0.5, 1.0],
      colors: isSelected
          ? (isDark
                ? [
                    const Color(0xFFE9E4DB).withAlpha(210),
                    const Color.fromARGB(255, 2, 101, 240),
                    const Color(0xFFB8A98F).withAlpha(150),
                  ]
                : [
                    const Color(0xFF0A192F),
                    const Color(0xFF526782),
                    const Color(0xFFE9E4DB),
                  ])
          : (isDark
                ? [
                    const Color(0xFF526782).withAlpha(150),
                    const Color.fromARGB(255, 52, 56, 63),
                    Colors.white.withAlpha(25),
                  ]
                : [
                    const Color(0xFFD6DCE5),
                    const Color(0xFFF7F9FF),
                    const Color(0xFFE9E4DB),
                  ]),
    );

   final innerColor = isSelected
    ? (isDark
        ? const Color.fromARGB(255, 10, 4, 90)
        : const Color(0xFF0A192F))
    : (isDark
        ? const Color.fromARGB(255, 44, 49, 56)
        : const Color(0xFFF7F9FF));

    final boxShadow = isSelected
        ? [
            BoxShadow(
              color: isDark
                  ? Colors.black.withAlpha(90)
                  : const Color(0xFF0A192F).withAlpha(24),
              blurRadius: 12,
              spreadRadius: 0,
              offset: const Offset(0, 4),
            ),
            BoxShadow(
              color: isDark
                  ? const Color(0xFFE9E4DB).withAlpha(12)
                  : const Color(0xFFE9E4DB).withAlpha(100),
              blurRadius: 6,
              offset: const Offset(0, 1),
            ),
          ]
        : <BoxShadow>[];

    final activeColor = const Color(0xFFE9E4DB);

    final inactiveColor = isDark
        ? const Color(0xFFB8C2D1)
        : const Color(0xFF737F91);

    return Padding(
      // Directional: يشتغل صح مع العربي والإنجليزي
      padding: const EdgeInsetsDirectional.only(end: 6, top: 5, bottom: 5),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.fastLinearToSlowEaseIn,
        padding: const EdgeInsets.all(1),
        decoration: BoxDecoration(
          color: isDark ? const Color.fromARGB(255, 215, 15, 255) : const Color(0xFFD6DCE5),
          borderRadius: BorderRadius.circular(30),
          gradient: borderGradient,
          boxShadow: boxShadow,
        ),
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
              onTap: onTap,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                child: Center(
                  widthFactor: 1,
                  child: AnimatedDefaultTextStyle(
                    duration: const Duration(milliseconds: 300),
                    style: TextStyle(
                      color: isSelected ? activeColor : inactiveColor,
                      fontSize: 14,
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.w500,
                      letterSpacing: 0.3,
                    ),
                    child: Text(label, maxLines: 1),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
