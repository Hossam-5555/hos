// import 'package:flutter/material.dart';
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
  final List<NavItem> items;
  final int currentIndex;
  final ValueChanged<int> onTap;
  final bool visible;

  const CustomBottomNavBar({
    super.key,
    required this.items,
    required this.currentIndex,
    required this.onTap,
    this.visible = true,
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
        child: Container(
          padding: EdgeInsets.all(5),
          // margin: const EdgeInsets.only(bottom: 5),
          width: width * 0.9,
          height: 65,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: isDark
                  ? [Colors.grey.shade900, Colors.grey.shade800]
                  : [
                        const Color.fromARGB(255, 0, 2, 90), // لمعة زرقاء (وضع فاتح)
                        Colors.grey,
                        Colors.blueAccent.withOpacity(0.2),
                      ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(40),
            border: Border.all(color: Colors.grey.withAlpha(50)),
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
                      color: isSelected
                          ? Colors.blue.withAlpha(50)
                          : null,
                      borderRadius: BorderRadius.circular(40),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // ── الأيقونة ──
                        _buildIcon(item, isSelected),
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
                                ? Colors.blue
                                : Colors.white,
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
          isSelected ? Colors.blue : const Color.fromARGB(255, 4, 28, 48),
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
