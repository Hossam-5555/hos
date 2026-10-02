import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jiffy/jiffy.dart';

class OrderCard extends StatelessWidget {
  const OrderCard({
    super.key,
    this.onTap,
    required this.w,
    required this.order,
    required this.status,
    required this.color,
    required this.orderimage,
  });

  final void Function()? onTap;
  final double w;
  final dynamic order;
  final String status;
  final Color color;
  final Map<String, dynamic> orderimage;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryTextColor = isDark ? Colors.white : Colors.black87;
    final cardColor = isDark ? Colors.grey[900] : Colors.white;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(isDark ? 102 : 50),
              blurRadius: 14,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- صورة الطلب + الحالة + الوقت فوقها (Glassmorphism badges) ---
            Stack(
              children: [
                AspectRatio(
                  aspectRatio: 1.2,
                  child: Image.asset(
                    orderimage[status],
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                ),
                // تدرج خفيف تحت الصورة عشان الـ badges تبان
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withAlpha(64),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 8,
                  left: 8,
                  child: _glassBadge(
                    text: "${'Status'.tr}: $status",
                    textColor: color,
                  ),
                ),
                Positioned(
                  bottom: 8,
                  left: 8,
                  child: _glassBadge(
                    text:  Jiffy.parse(order.createdAt!).fromNow(),
                    textColor: Colors.white,
                  ),
                ),
              ],
            ),

            // --- تفاصيل الطلب (المحتوى بيحدد الارتفاع = تأثير الـ masonry) ---
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: w * 0.03,
                vertical: w * 0.025,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${'Order numper'.tr} #${order.orderNumber}",
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: w * 0.032,
                      color: primaryTextColor,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: w * 0.015),
                  Text(
                    "\$${order.totalAmount}",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: w * 0.048,
                      color: primaryTextColor,
                    ),
                  ),
                  SizedBox(height: w * 0.015),
                  Row(
                    children: [
                      Icon(Icons.credit_card, size: w * 0.032, color: Colors.grey),
                      SizedBox(width: w * 0.01),
                      Expanded(
                        child: Text(
                          order.paymentMethod,
                          style: TextStyle(fontSize: w * 0.028, color: Colors.grey),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.receipt_long, size: w * 0.032, color: isDark ? Colors.blue[300] : Colors.green[700]),
                      SizedBox(width: w * 0.01),
                      Expanded(
                        child: Text(
                          "${'Payment'.tr}: ${order.paymentStatus}",
                          style: TextStyle(
                            fontSize: w * 0.028,
                            fontWeight: FontWeight.w600,
                            color: isDark ? Colors.blue[300] : const Color.fromARGB(255, 31, 56, 16),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _glassBadge({required String text, required Color textColor}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: Colors.black.withAlpha(76),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withAlpha(51)),
          ),
          child: Text(
            text,
            style: TextStyle(
              color: textColor,
              fontSize: 10.5,
              fontWeight: FontWeight.w600,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }
}