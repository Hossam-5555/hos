import 'package:flutter/material.dart';
import 'package:hos/core/conistant/app_colors.dart';

class SettingSwitchTile extends StatelessWidget {
  final IconData icon;
  final List<Color> gradient;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;
  final Widget onThumb;      // اللي يظهر داخل السويتش في حالة ON
  final Widget offThumb;     // اللي يظهر في حالة OFF
  final Color activeColor;   // لون خلفية السويتش ON
  final Color inactiveColor; // لون خلفية السويتش OFF

  const SettingSwitchTile({
    super.key,
    required this.icon,
    required this.gradient,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
    required this.onThumb,
    required this.offThumb,
    required this.activeColor,
    required this.inactiveColor,
  });

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final tilePadding = (w * 0.028).clamp(10.0, 16.0);
    final iconPadding = (w * 0.018).clamp(6.0, 10.0);
    final iconRadius = (w * 0.028).clamp(10.0, 14.0);

    return Padding(
      padding: EdgeInsets.all(tilePadding),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(iconPadding),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(iconRadius),
              gradient: LinearGradient(
                colors: gradient,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: gradient.last.withAlpha(77),
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(icon, color: Colors.white, size: 22),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(fontSize: 12, color: AppColors.mutedText),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => onChanged(!value),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: w * 0.12,
              height: 32,
              padding: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: value ? activeColor : inactiveColor,
                border: Border.all(color: AppColors.mutedText.withAlpha(70)),
              ),
              child: AnimatedAlign(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                alignment:
                    value ? Alignment.centerRight : Alignment.centerLeft,
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  transitionBuilder: (child, animation) => RotationTransition(
                    turns: animation,
                    child: ScaleTransition(scale: animation, child: child),
                  ),
                  child: KeyedSubtree(
                    key: ValueKey<bool>(value),
                    child: value ? onThumb : offThumb,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}