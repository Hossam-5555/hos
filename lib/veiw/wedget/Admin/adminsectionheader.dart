import 'package:flutter/material.dart';
import 'package:hos/veiw/wedget/appbarbackicon.dart';
import 'package:hos/veiw/wedget/items/itemslist.dart';

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
    this.horizontalPadding = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 6),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: isCompact ? 10 : 14,
          vertical: 10,
        ),

        child: Row(
          children: [
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Homescrenaction(
                    herotag: "Admincat",
                    child: Icon(Icons.category_outlined, color: Colors.black),
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
                          style: TextStyle(color: Colors.black,
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
            AppChip(label: addButtonText, isSelected: true, onTap: onAdd),
          ],
        ),
      ),
    );
  }
}
