import 'package:flutter/material.dart';
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
  final checkSize = (w * 0.058).clamp(20.0, 26.0);
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
        children: [
          Container(
            padding: EdgeInsets.all(r.s(10)),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(r.s(12)),
              color: (iconColor ?? Colors.black).withAlpha(25),
            ),
            child: Icon(icon, color: iconColor ?? Colors.white, size: sp(19)),
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
                      color: Colors.grey.shade600,
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
              color: isSelected ? Colors.green : Colors.transparent,
              border: Border.all(color: Colors.grey),
            ),
            child: isSelected
                ? Icon(Icons.check_rounded, size: sp(14), color: Colors.white)
                : null,
          ),
        ],
      ),
    ),
  );
}
