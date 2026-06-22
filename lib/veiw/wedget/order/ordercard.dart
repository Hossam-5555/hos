import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jiffy/jiffy.dart';

// ignore: must_be_immutable
class OrderCard extends StatelessWidget {
  OrderCard({
    super.key,
    this.onTap,
    required this.h,
    required this.w,
    required this.order,
    required this.status,
    required this.color,
    required this.orderimage,
  });

  final void Function()? onTap;
  final double w;
  final double h;
  final dynamic order;
  final String status;
  final Color color;
  final Map<String, dynamic> orderimage;

  @override
  Widget build(BuildContext context) {
    // 1. اكتشاف وضع الثيم الحالي (مظلم أو فاتح)
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // 2. تحديد الألوان بناءً على الثيم
    final primaryTextColor = isDark ? Colors.white : Colors.black87;
    final secondaryTextColor = isDark ? Colors.white70 : Colors.black54;
    final overlayColor = isDark
        ? Colors.black.withOpacity(0.75) // تعتيم قوي للوضع المظلم
        : Colors.white.withOpacity(0.75); // تفتيح قوي للوضع الفاتح
    final shadowColor = isDark ? Colors.black54 : const Color.fromARGB(255, 223, 220, 220).withOpacity(0.2);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: h * 0.01, horizontal: w * 0.01),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: shadowColor,
              offset: const Offset(0, 0.2), // ظل سينمائي ناعم يعطي عمق
            ),
          ],
          // الصورة الخلفية
          image: DecorationImage(
            image: AssetImage(orderimage[status]!),
            fit: BoxFit.cover,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(25),
          child: BackdropFilter(
            // تأثير البلور (Glassmorphism)
            filter: ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
            child: Container(
              // التدرج اللوني فوق الصورة
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomLeft,
                  colors: [
                    overlayColor.withOpacity(
                      isDark ? 0.3 : 0.2,
                    ), // شفاف من الأعلى
                    overlayColor, // مركز من الأسفل لضمان وضوح النص
                  ],
                  stops: const [0.0, 0.9],
                ),
                // border: Border.all(
                //   color: isDark
                //       ? Colors.white54
                //       : Colors.black12, // إطار خفيف جداً
                //   width: 1,
                // ),
              ),
              padding: EdgeInsets.symmetric(
                vertical: h * 0.02,
                horizontal: w * 0.04,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // --- القسم الأول: الوقت وحالة الطلب بأسلوب Badge ---
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        Jiffy.parse(
                          isUtc: true,
                          order.createdAt,
                          pattern: 'yyyy-MM-dd hh:mm a',
                        ).fromNow(),
                        style: TextStyle(
                          fontSize: w * 0.035,
                          fontWeight: FontWeight.w600,
                          color: secondaryTextColor,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: color.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: color.withOpacity(0.5)),
                        ),
                        child: Text(
                          "${'Status'.tr}: $status",
                          style: TextStyle(
                            color: color, // لون الحالة المرسل في المتغيرات
                            fontWeight: FontWeight.bold,
                            fontSize: w * 0.035,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: h * 0.015),

                  // --- القسم الثاني: رقم الطلب (بارز وسينمائي) ---
                  Text(
                    "${'Order numper'.tr} #${order.orderNumber}",
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: w * 0.05,
                      color: primaryTextColor,
                      letterSpacing: 1.0,
                    ),
                  ),
                  SizedBox(height: h * 0.015),

                  // --- القسم الثالث: تفاصيل الدفع والسعر الإجمالي ---
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${'paymentMethod'.tr}: ${order.paymentMethod}",
                            style: TextStyle(
                              color: secondaryTextColor,
                              fontSize: w * 0.035,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "${'Payment'.tr}: ${order.paymentStatus}",
                            style: TextStyle(
                              color: isDark
                                  ? Colors.blue[300]
                                  : const Color.fromARGB(255, 74, 158, 25),
                              fontWeight: FontWeight.w600,
                              fontSize: w * 0.035,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        "\$${order.totalAmount}",
                        style: TextStyle(
                          color: isDark
                              ? Colors.greenAccent
                              : Colors.black87,
                          fontSize: w * 0.06,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),

                  // --- القسم الرابع: التقييم (يظهر فقط إذا كان الطلب مستلماً) ---
                  if (order.status == "delivered") ...[
                    SizedBox(height: h * 0.015),
                    Row(
                      children: [
                        Icon(
                          Icons.star_rounded,
                          color: Colors.amber,
                          size: w * 0.05,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          "4 ⭐ (1k) ${'reviews'.tr ?? 'reviews'}",
                          style: TextStyle(
                            color: secondaryTextColor,
                            fontWeight: FontWeight.w500,
                            fontSize: w * 0.035,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
