
import 'package:flutter/material.dart';

class AdminSectionHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final int count;
  final String countLabel;
  final IconData icon;
  final VoidCallback onAdd;
  final String addButtonText;

  final bool isDark;
  final bool isCompact;
  final double horizontalPadding;

  const AdminSectionHeader({
    super.key,
    required this.title,
    required this.subtitle,
    required this.count,
    required this.countLabel,
    required this.icon,
    required this.onAdd,
    this.addButtonText = 'إضافة',
    this.isDark = false,
    this.isCompact = false,
    this.horizontalPadding = 16,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: 6,
      ),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: isCompact ? 10 : 14,
          vertical: 10,
        ),
        decoration: BoxDecoration(
          color: isDark
              ? const Color(0xFF323538)
              : const Color(0xFFE0E3E8),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(8),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(isCompact ? 6 : 8),
                    decoration: const BoxDecoration(
                      color: Color(0x1F00F2FE),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      icon,
                      color: const Color(0xFF0284C7),
                      size: isCompact ? 17 : 19,
                    ),
                  ),
                  SizedBox(width: isCompact ? 7 : 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: isCompact ? 11 : 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '$count $countLabel',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: isCompact ? 10 : 11,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF00F2FE),
                    Color(0xFF4FACFE),
                  ],
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF4FACFE).withAlpha(89),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: onAdd,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: isCompact ? 9 : 12,
                      vertical: 9,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.add_rounded,
                          color: Colors.white,
                          size: 18,
                        ),
                        if (!isCompact) ...[
                          const SizedBox(width: 4),
                          Text(
                            addButtonText,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
