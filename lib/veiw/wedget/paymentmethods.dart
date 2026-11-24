import 'package:flutter/material.dart';
import 'package:hos/core/conistant/app_colors.dart';
import 'package:hos/controler/usercontroller/checkout&cart/checkoutcontroller.dart';
import 'package:hos/veiw/wedget/order/ordersdetails.dart';

// ==========================================
// دوال بناء الواجهة (Responsive)
// ==========================================

Widget buildPaymentMethod({
  required String title,
  required IconData icon,
  required String method,
  required double w,
  required double h,
  required double Function(double) sp,
  String? subtitle,
  context,
  required Checkoutcontroller controller,
}) {
  final isSelected = controller.selectedMethod == method;
  final checkSize = (w * 0.055).clamp(20.0, 26.0);
  final r = Rsp.of(context);
  final isDark = Theme.of(context).brightness == Brightness.dark;

  return GestureDetector(
    onTap: () => controller.changePaymentMethod(method),
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      // padding: EdgeInsets.all((r.s(4))),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular((w * 0.035).clamp(12.0, 18.0)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: r.s(38),
            height: r.s(38),
            decoration: BoxDecoration(
              color: isDark
                  ? AppColors.darkShadow.withAlpha(100)
                  : const Color(0xFFE0E3E8),
              borderRadius: BorderRadius.circular(r.s(12)),
            ),
            child: Icon(icon, size: r.s(19)),
          ),

          SizedBox(width: r.s(12)),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: r.s(11),
                  ),
                ),

                SizedBox(height: r.s(3)),

                if (subtitle != null) ...[
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: r.s(13),
                      fontWeight: FontWeight.w600,
                      height: 1.3,
                    ),
                  ),
                ],
              ],
            ),
          ),
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: checkSize,
            height: checkSize,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isSelected ? AppColors.success : Colors.transparent,
              border: Border.all(color: AppColors.grey),
            ),
            child: isSelected
                ? Icon(
                    Icons.check_rounded,
                    size: sp(14),
                    color: AppColors.white,
                  )
                : null,
          ),
        ],
      ),
    ),
  );
}
