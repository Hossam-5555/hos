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
  Color? iconColor,
  context,
  required Checkoutcontroller controller,
}) {
  final isSelected = controller.selectedMethod == method;
  final checkSize = (w * 0.055).clamp(20.0, 26.0);
  final r = Rsp.of(context);

  return GestureDetector(
    onTap: () => controller.changePaymentMethod(method),
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: EdgeInsets.all((r.s(4))),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular((w * 0.035).clamp(12.0, 18.0)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(r.s(10)),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(r.s(12)),
              color: (iconColor ?? AppColors.black).withAlpha(25),
            ),
            child: Icon(icon, color: iconColor ?? AppColors.white, size: sp(19)),
          ),
          SizedBox(width: r.s(10)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: sp(12),
                    fontWeight: FontWeight.w700,
                  ),
                ),
                if (subtitle != null) ...[
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: sp(12),
                      color: AppColors.grey,
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
                ? Icon(Icons.check_rounded, size: sp(14), color: AppColors.white)
                : null,
          ),
        ],
      ),
    ),
  );
}
