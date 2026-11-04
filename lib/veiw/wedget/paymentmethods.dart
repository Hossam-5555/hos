import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:hos/controler/usercontroller/checkout&cart/checkoutcontroller.dart';

// ==========================================
// دوال بناء الواجهة
// ==========================================

Widget buildPaymentMethod({
  required String title,
  required IconData icon,
  required String method,
  String? subtitle,
  Color? iconColor,
  controller,
}) {
  final isSelected = controller.selectedMethod == method;

  return GestureDetector(
    onTap: () => controller.changePaymentMethod(method),
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(14)),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: (iconColor ?? Colors.black).withAlpha(25),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor ?? Colors.black87, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                if (subtitle != null) ...[
                  Text(
                    subtitle,
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                ],
              ],
            ),
          ),
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 22,
            height: 22,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isSelected ? Colors.green : Colors.transparent,
              border: Border.all(color: Colors.grey),
            ),
            child: isSelected
                ? const Icon(Icons.check_rounded, size: 14, color: Colors.black)
                : null,
          ),
        ],
      ),
    ),
  );
}

Widget buildFormContent(Checkoutcontroller controller) {
  switch (controller.selectedMethod) {
    case "card":
      return buildCreditCardForm();
    case "wallet":
      return buildmobileForm();
    case "cash":
      return buildCODForm();
    default:
      return const SizedBox.shrink();
  }
}

// ───────────── Card ─────────────
Widget buildCreditCardForm() {
  return Column(
    key: const ValueKey('card'),
    children: [
      Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF1E1E1E), Color(0xFF434343)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(51),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(
                  Icons.contactless_rounded,
                  color: Colors.white70,
                  size: 28,
                ),
                Icon(Icons.credit_card, color: Colors.white70, size: 28),
              ],
            ),
            const SizedBox(height: 28),
            const Text(
              '••••  ••••  ••••  ••••',
              textDirection: TextDirection.ltr,
              style: TextStyle(
                color: Colors.white,
                fontSize: 21,
                letterSpacing: 2,
                fontFamily: 'Courier',
              ),
            ),
            const SizedBox(height: 22),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'CARD HOLDER',
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
                Text(
                  'MM/YY',
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
          ],
        ),
      ),
    ],
  );
}

// ───────────── Wallet ─────────────
Widget buildmobileForm() {
  return buildInfoBox(
    key: const ValueKey('wallet'),
    title: 'wallet'.tr,
    message:
        'بعد تأكيد الطلب سيتم تحويلك إلى صفحة الدفع لإكمال العملية عبر '
        'فودافون كاش أو أورنج كاش أو اتصالات كاش.',
    icon: Icons.account_balance_wallet_outlined,
    color: const Color(0xFFE53935),
  );
}

// ───────────── Cash on Delivery ─────────────
Widget buildCODForm() {
  return buildInfoBox(
    key: const ValueKey('cash'),
    title: 'cash on delivery'.tr,
    message:
        'ادفع قيمة الطلب نقداً للمندوب عند التوصيل. '
        'يُرجى تجهيز المبلغ المناسب قدر الإمكان.',
    icon: Icons.local_shipping_outlined,
    color: const Color(0xFF2E7D32),
  );
}

// ───────────── Shared ─────────────
Widget buildInfoBox({
  Key? key,
  required String title,
  required String message,
  required IconData icon,
  required Color color,
}) {
  return Container(
    key: key,
    width: double.infinity,
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: color.withAlpha(20),
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: color.withAlpha(70)),
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          child: Icon(icon, color: Colors.white, size: 22),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              const SizedBox(height: 4),
              Text(message, style: const TextStyle(fontSize: 13, height: 1.5)),
            ],
          ),
        ),
      ],
    ),
  );
}


