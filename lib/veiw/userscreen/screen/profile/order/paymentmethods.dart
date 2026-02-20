import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hos/controler/usercontroller/profile/paymentcontroller.dart';
import 'package:hos/veiw/wedget/appbarbackicon.dart';

class PaymentScreen extends StatelessWidget {
  PaymentScreen({Key? key}) : super(key: key);

  // حقن (Inject) الكنترولر في الشاشة
  final PaymentController controller = Get.put(PaymentController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: Appbarbackicon(title: "طرق الدفع", herotag: "paymentScreen"),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: controller.formKey, // ربط الـ key من الكنترولر
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'اختر طريقة الدفع',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),

                // 1. قسم اختيار طريقة الدفع (مغلف بـ Obx ليتفاعل مع التغيير)
                Obx(
                  () => Row(
                    children: [
                      _buildPaymentOption(
                        title: 'بطاقة ائتمان',
                        icon: Icons.credit_card,
                        method: PaymentMethod.creditCard,
                      ),
                      const SizedBox(width: 10),
                      _buildPaymentOption(
                        title: 'محفظة إلكترونية',
                        icon: Icons.account_balance_wallet,
                        method: PaymentMethod.mobileWallet,
                      ),
                      const SizedBox(width: 10),
                      _buildPaymentOption(
                        title: 'كاش',
                        icon: Icons.money,
                        method: PaymentMethod.cod,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                const Divider(),

                ListTile(
                  leading: const Icon(
                    Icons.info_outline,
                    color: Colors.blueAccent,
                  ),
                  title: const Text(
                    'ملاحظة: يرجى التأكد من صحة بيانات الدفع لتجنب أي تأخير في معالجة طلبك.',
                    style: TextStyle(color: Colors.blueAccent, fontSize: 13),
                  ),
                ),
                const Divider(),

                // 2. قسم عرض الـ Form الخاص بكل طريقة (مغلف بـ Obx)
                Obx(
                  () => AnimatedSwitcher(
                    switchInCurve: Curves.easeIn,
                    duration: const Duration(milliseconds: 300),
                    child: buildPaymentForm(),
                  ),
                ),

                const SizedBox(height: 40),

                // 3. زر إتمام الدفع
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed:
                        controller.addpayment, // استدعاء الدالة من الكنترولر
                    child: const Text(
                      'Add payment method',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // --- دوال بناء الواجهة للمكونات المختلفة ---

  Widget _buildPaymentOption({
    required String title,
    required IconData icon,
    required PaymentMethod method,
  }) {
    // قراءة القيمة الحالية من الكنترولر
    final isSelected = controller.selectedMethod.value == method;
    return Expanded(
      child: GestureDetector(
        onTap: () => controller.changePaymentMethod(
          method,
        ), // تحديث القيمة عبر الكنترولر
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: isSelected ? Colors.blue.withAlpha(25) : Colors.white,
            border: Border.all(
              color: isSelected ? Colors.blueAccent : Colors.grey.shade300,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              Icon(
                icon,
                color: isSelected ? Colors.blueAccent : Colors.grey,
                size: 30,
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: TextStyle(
                  color: isSelected ? Colors.blueAccent : Colors.grey,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildPaymentForm() {
    switch (controller.selectedMethod.value) {
      case PaymentMethod.creditCard:
        return _buildCreditCardForm();
      case PaymentMethod.mobileWallet:
        return _buildMobileWalletForm();
      case PaymentMethod.cod:
        return _buildCODForm();
      case PaymentMethod.none:
        throw UnimplementedError();
    }
  }

  Widget _buildCreditCardForm() {
    return Column(
      key: const ValueKey('CreditCard'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SavedCardItem(
          lastFourDigits: '1234',
          expiryDate: '12/24',
          isSelected:
              controller.selectedMethod.value == PaymentMethod.creditCard,
          onTap: () => controller.changePaymentMethod(PaymentMethod.creditCard),
        ),

        const Text(
          'بيانات البطاقة',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        _customTextField(
          label: 'اسم حامل البطاقة',
          icon: Icons.person_outline,
          keyboardType: TextInputType.name,
        ),
        const SizedBox(height: 16),
        _customTextField(
          label: 'رقم البطاقة',
          icon: Icons.credit_card,
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _customTextField(
                label: 'تاريخ الانتهاء (MM/YY)',
                icon: Icons.date_range,
                keyboardType: TextInputType.datetime,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _customTextField(
                label: 'رمز (CVV)',
                icon: Icons.lock_outline,
                keyboardType: TextInputType.number,
                obscureText: true,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMobileWalletForm() {
    return Column(
      key: const ValueKey('MobileWallet'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SavedCardItem(
          lastFourDigits: '5778',
          expiryDate: '12/24',
          isSelected:
              controller.selectedMethod.value == PaymentMethod.mobileWallet,
          onTap: () =>
              controller.changePaymentMethod(PaymentMethod.mobileWallet),
        ),
        Divider(),
        const Text(
          'بيانات المحفظة الإلكترونية',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        _customTextField(
          label: 'رقم الهاتف المرتبط بالمحفظة',
          icon: Icons.phone_android,
          keyboardType: TextInputType.phone,
        ),
        const SizedBox(height: 10),
        const Text(
          'سيتم إرسال إشعار الدفع إلى هذا الرقم لإتمام العملية.',
          style: TextStyle(color: Colors.grey, fontSize: 13),
        ),
      ],
    );
  }

  Widget _buildCODForm() {
    return Container(
      key: const ValueKey('COD'),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.orange.withAlpha(25),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.orange.shade200),
      ),
      child: const Row(
        children: [
          Icon(Icons.info_outline, color: Colors.orange),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              'سوف تقوم بدفع قيمة الطلب نقداً عند توصيله إلى باب منزلك. قد يتم تطبيق رسوم إضافية لخدمة الدفع عند الاستلام.',
              style: TextStyle(height: 1.5),
            ),
          ),
        ],
      ),
    );
  }

  Widget _customTextField({
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
  }) {
    return TextFormField(
      keyboardType: keyboardType,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.grey),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.blueAccent, width: 2),
        ),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'هذا الحقل مطلوب';
        }
        return null;
      },
    );
  }
}

class SavedCardItem extends StatelessWidget {
  final String lastFourDigits;
  final String expiryDate;
  final bool isSelected;
  final VoidCallback onTap;

  const SavedCardItem({
    super.key,
    required this.lastFourDigits,
    required this.expiryDate,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue.shade50 : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? Colors.blueAccent : Colors.grey.shade200,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(8),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // أيقونة البطاقة
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isSelected
                    ? Colors.blueAccent.withAlpha(25)
                    : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.credit_card,
                color: isSelected ? Colors.blueAccent : Colors.grey.shade600,
                size: 28,
              ),
            ),
            const SizedBox(width: 16),

            // بيانات البطاقة
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '**** **** **** $lastFourDigits',
                    textDirection:
                        TextDirection.ltr, // للحفاظ على اتجاه الأرقام
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2.0,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'تاريخ الانتهاء: $expiryDate',
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                  ),
                ],
              ),
            ),

            // علامة الاختيار
            if (isSelected)
              const Icon(
                Icons.check_circle,
                color: Colors.blueAccent,
                size: 28,
              ),
          ],
        ),
      ),
    );
  }
}
