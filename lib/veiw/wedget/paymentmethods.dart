import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
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
              color: (iconColor ?? Colors.black).withOpacity(0.1),
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
              border: Border.all(
                color:Colors.grey ,
              ),
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

buildFormContent(Checkoutcontroller controller) {
  switch (controller.selectedMethod) {
    case "credit":
      return buildCreditCardForm();
    case "mobile":
      return buildCreditCardForm();
    case "cash":
      return buildCODForm();
  }
}

// ✨ تصميم البطاقة الائتمانية كأنها فيزا حقيقية
Widget buildCreditCardForm() {
  return Column(
    key: const ValueKey('CreditCard'),
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      // شكل الكارت الفخم
      Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF1E1E1E), Color(0xFF3A3A3A)], // تدرج أسود فخم
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Icon(
                  Icons.contactless_rounded,
                  color: Colors.white70,
                  size: 28,
                ),
                // صورة لوجو ماستركارد من النت كمثال للاحترافية
                CachedNetworkImage(
                  imageUrl:
                      "https://upload.wikimedia.org/wikipedia/commons/thumb/2/2a/Mastercard-logo.svg/1280px-Mastercard-logo.svg.png",
                  imageBuilder: (context, imageProvider) => Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  placeholder: (context, url) => CircularProgressIndicator(),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ],
            ),
            const SizedBox(height: 30),
            const Text(
              '**** **** **** 1234',
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                letterSpacing: 2,
                fontFamily: 'Courier',
              ),
              textDirection: TextDirection.ltr,
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'MOHAMED AHMED',
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
                const Text(
                  '12/24',
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ],
            ),
          ],
        ),
      ),
    ],
  );
}

Widget buildCODForm() {
  return buildInfoBox(
    'الدفع عند الاستلام متاح.\nسوف تقوم بدفع قيمة الطلب نقداً للمندوب عند التوصيل.',
    key: const ValueKey('COD'),
    icon: Icons.local_shipping_outlined,
  );
}

// ==========================================
// ويدجتس مساعدة (Helper Widgets)
// ==========================================

Widget buildInfoBox(
  String text, {
  Key? key,
  IconData icon = Icons.info_outline,
}) {
  return Container(
    key: key,
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.lightGreen.withAlpha(50), // رمادي فاتح جداً بدل البرتقالي
      borderRadius: BorderRadius.circular(12),
    ),
    child: Row(
      children: [
        Icon(icon, color: Colors.black87),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            // style: TextStyle(color: Colors.grey.shade800, height: 1.5),
          ),
        ),
      ],
    ),
  );
}

Widget buildTextField({
  required String label,
  required IconData icon,
  required TextInputType type,
  bool isSecure = false,
}) {
  return TextFormField(
    keyboardType: type,
    obscureText: isSecure,
    decoration: InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: Colors.black, size: 20),
      filled: true,
      contentPadding: const EdgeInsets.symmetric(vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.black, width: 1.5),
      ),
    ),
    validator: (v) => v!.trim().isEmpty ? 'مطلوب' : null,
  );
}
