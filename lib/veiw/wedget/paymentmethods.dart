import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hos/controler/usercontroller/checkout&cart/checkoutcontroller.dart';
import 'package:hos/controler/usercontroller/profile/paymentcontroller.dart';

// ==========================================
// دوال بناء الواجهة
// ==========================================

Widget buildPaymentMethod({
  required String title,
  required IconData icon,
  required PaymentMethod method,
  controller,
}) {
  final isSelected = controller.selectedMethod.value == method;
  return Expanded(
    child: GestureDetector(
      onTap: () => controller.changePaymentMethod(method),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: isSelected ? Colors.black : Colors.transparent,
          border: Border.all(
            color: isSelected ? Colors.black : Colors.grey.shade300,
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.white : Colors.grey.shade700,
              size: 28,
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.grey.shade700,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

Widget buildFormContent(Checkoutcontroller controller) {
  switch (controller.selectedMethod.value) {
    case PaymentMethod.creditCard:
      return buildCreditCardForm();
    case PaymentMethod.mobileWallet:
      return buildMobileWalletForm();
    case PaymentMethod.cod:
      return buildCODForm();
    case PaymentMethod.none:
      return const SizedBox.shrink(); // لو مفيش حاجة مختارة
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
        padding: const EdgeInsets.all(20),
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
      const SizedBox(height: 24),
      const Text(
        'بيانات البطاقة الجديدة',
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
      const SizedBox(height: 16),
      buildTextField(
        label: 'رقم البطاقة',
        icon: Icons.credit_card,
        type: TextInputType.number,
      ),
      const SizedBox(height: 16),
      Row(
        children: [
          Expanded(
            child: buildTextField(
              label: 'MM/YY',
              icon: Icons.calendar_month,
              type: TextInputType.datetime,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: buildTextField(
              label: 'CVV',
              icon: Icons.lock,
              type: TextInputType.number,
              isSecure: true,
            ),
          ),
        ],
      ),
    ],
  );
}

Widget buildMobileWalletForm() {
  return Column(
    key: const ValueKey('Wallet'),
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      buildInfoBox('يرجى التأكد من أن المحفظة مفعلة وبها رصيد كافٍ.'),
      const SizedBox(height: 16),
      buildTextField(
        label: 'رقم الهاتف المرتبط بالمحفظة',
        icon: Icons.phone_iphone_rounded,
        type: TextInputType.phone,
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
      color: const Color(0xFFF8F9FA), // رمادي فاتح جداً بدل البرتقالي
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: Colors.grey.shade200),
    ),
    child: Row(
      children: [
        Icon(icon, color: Colors.black87),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: TextStyle(color: Colors.grey.shade800, height: 1.5),
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
