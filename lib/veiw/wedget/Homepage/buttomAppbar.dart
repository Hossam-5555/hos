// import 'package:flutter/material.dart';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

// ─────────────────────────────────────────
// موديل الـ Tab
// ─────────────────────────────────────────
class NavItem {
  final String label;
  final String? svgAsset; // لو الأيقونة SVG
  final String? imageAsset; // لو الأيقونة Image عادية
  final IconData? icon; // لو الأيقونة Material Icon

  const NavItem({
    required this.label,
    this.svgAsset,
    this.imageAsset,
    this.icon,
  });
}

// ─────────────────────────────────────────
// الـ Widget المستقل
// ─────────────────────────────────────────
class CustomBottomNavBar extends StatelessWidget {
  final List items;
  final int currentIndex;
  final ValueChanged<int> onTap;
  final bool visible;
  final int cartcount;
  final bool? isbadgeActive;
  const CustomBottomNavBar({
    super.key,
    required this.items,
    required this.currentIndex,
    required this.onTap,
    this.visible = true,
    this.cartcount = 0,
    this.isbadgeActive
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final width = MediaQuery.of(context).size.width;

    return AnimatedSlide(
      offset: visible ? Offset.zero : const Offset(0, 2),
      duration: const Duration(milliseconds: 100),
      curve: Curves.easeInQuad,
      child: IgnorePointer(
        ignoring: !visible,
        child: ClipRRect(
          borderRadius: BorderRadiusGeometry.circular(40),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
            child: Container(
              padding: EdgeInsets.all(5),
              width: width * 0.9,
              height: 65,
              decoration: BoxDecoration(
                color: Colors.white.withAlpha(30),

                borderRadius: BorderRadius.circular(40),
                border: Border.all(
                  color: isDark
                      ? Colors.white.withOpacity(0.28)
                      : Colors.grey.shade300,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.12),
                    blurRadius: 12,
                    spreadRadius: -5,
                    offset: Offset(0, 8),
                  ),
                ],
              ),
              child: Row(
                children: List.generate(items.length, (index) {
                  final isSelected = currentIndex == index;
                  final item = items[index];

                  return Expanded(
                    child: GestureDetector(
                      onTap: () => onTap(index),
                      child: AnimatedContainer(
                        // margin: const EdgeInsets.symmetric(horizontal: 5),
                        duration: const Duration(milliseconds: 250),
                        decoration: BoxDecoration(
                          color: isSelected ? Colors.black : null,
                          borderRadius: BorderRadius.circular(40),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // ── الأيقونة ──
                            Badge(
                              isLabelVisible:index==2 ,
                              label: Text("$cartcount"),
                              child: _buildIcon(item, isSelected),
                            ),
                            const SizedBox(height: 2),
                            // ── النص ──
                            Text(
                              item.label,
                              style: TextStyle(
                                fontSize: isSelected ? 12 : 10,
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.w200,
                                color: isSelected
                                    ? Colors.white
                                    : isDark
                                    ? Colors.grey.shade400
                                    : Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIcon(NavItem item, bool isSelected) {
    final size = isSelected ? 25.0 : 22.0;

    // Image Asset
    if (item.imageAsset != null) {
      return ClipOval(
        child: SizedBox(
          height: size,
          width: size,
          child: Image.asset(item.imageAsset!, fit: BoxFit.contain),
        ),
      );
    }

    // SVG Asset
    if (item.svgAsset != null) {
      return SvgPicture.asset(
        item.svgAsset!,
        height: size,
        width: size,
        colorFilter: ColorFilter.mode(
          isSelected ? Colors.white : Colors.black.withOpacity(0.7),
          BlendMode.srcIn,
        ),
      );
    }

    // Material Icon
    if (item.icon != null) {
      return Icon(
        item.icon,
        size: size,
        color: isSelected ? Colors.blue : Colors.grey,
      );
    }

    return const SizedBox.shrink();
  }
}
