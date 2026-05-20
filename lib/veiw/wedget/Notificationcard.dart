import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';

class NotificationCard extends StatelessWidget {
  final String title;
  final String body;
  final String time;
  final bool isSelected;
  final bool isLoading;
  final bool selectionMode;
  final void Function()? onLongPress;
  final void Function()? onTap;
  final bool isactive;

  const NotificationCard({
    super.key,
    required this.isactive,
    required this.title,
    required this.body,
    required this.time,
    required this.isSelected,
    required this.isLoading,
    required this.selectionMode,
    this.onLongPress,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onLongPress: isLoading ? null : onLongPress,
        onTap: isLoading ? null : onTap,
        borderRadius: BorderRadius.circular(20),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
           
            color: isSelected
                ? Colors.blue.withOpacity(0.08)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isSelected
                  ? Colors.blue.withOpacity(0.5)
                  : Colors.grey.withAlpha(50),
              width: 1,
              strokeAlign: BorderSide.strokeAlignCenter,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- قسم الأيقونة ---
              Badge(isLabelVisible: isactive,
                child: Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: isSelected
                          ? [Colors.blue, Colors.blueAccent]
                          : [
                              Colors.blue.withOpacity(0.1),
                              Colors.blue.withOpacity(0.05),
                            ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.notifications_none_rounded,
                    color: isSelected ? Colors.white : Colors.blue,
                    size: 26,
                  ),
                ),
              ),
              const SizedBox(width: 15),

              // --- قسم النصوص ---
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            title,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: Colors
                                  .blueGrey[900], // يمكن ربطها بالثيم لو أردت
                            ),
                          ),
                        ),
                        if (!isLoading && !selectionMode)
                          Text(
                            Jiffy.parse(
                              pattern: 'yyyy-MM-dd hh:mm a',
                              isUtc: true,
                              time,
                            ).fromNow(),
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.grey[500],
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      body,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 13,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),

              // --- قسم تحديد الرسالة (Checkbox) ---
              if (selectionMode && !isLoading)
                Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Checkbox(
                    value: isSelected,
                    activeColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    onChanged: (val) {
                      if (onTap != null) onTap!();
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
