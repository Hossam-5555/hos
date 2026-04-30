import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hos/controler/usercontroller/profile/paymentcontroller.dart';
import 'package:hos/veiw/wedget/appbarbackicon.dart';

class PaymentScreen extends StatelessWidget {
  PaymentScreen({super.key});

  final PaymentController controller = Get.put(PaymentController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: Appbarbackicon(title: "طرق الدفع", herotag: "paymentScreen"),
      ),
      
      // ✨ التعديل الاحترافي: زر الدفع ثابت تحت عشان الكيبورد ميغطيش عليه
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Colors.grey.shade200)),
        ),
        child: SafeArea(
          child: SizedBox(
            height: 55,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black, // لون أسود فخم
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40),
                ),
              ),
              onPressed: controller.addpayment,
              child: const Text(
                'تأكيد الدفع',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          ),
        ),
      ),

      body: Form(
        key: controller.formKey,
        child: ListView( // 👈 ListView أفضل من SingleChildScrollView هنا
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(20.0),
          children: [
            const Text(
              'اختر طريقة الدفع',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 16),

            // 1. اختيارات الدفع (تصميم نظيف)
            Obx(
              () => Row(
                children: [
                  _buildPaymentMethod(
                    title: 'بطاقة ائتمان',
                    icon: Icons.credit_card_rounded,
                    method: PaymentMethod.creditCard,
                  ),
                  const SizedBox(width: 12),
                  _buildPaymentMethod(
                    title: 'محفظة',
                    icon: Icons.account_balance_wallet_rounded,
                    method: PaymentMethod.mobileWallet,
                  ),
                  const SizedBox(width: 12),
                  _buildPaymentMethod(
                    title: 'كاش',
                    icon: Icons.money_rounded,
                    method: PaymentMethod.cod,
                  ),
                ],
              ),
            ),

            const Padding(
              padding: EdgeInsets.symmetric(vertical: 24),
              child: Divider(height: 1),
            ),

            // 2. نموذج الدفع الديناميكي
            Obx(
              () => AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                switchInCurve: Curves.easeOutCubic,
                transitionBuilder: (child, animation) => FadeTransition(
                  opacity: animation,
                  child: SlideTransition(
                    position: Tween<Offset>(begin: const Offset(0, 0.05), end: Offset.zero).animate(animation),
                    child: child,
                  ),
                ),
                child: _buildFormContent(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================
  // دوال بناء الواجهة
  // ==========================================

  Widget _buildPaymentMethod({required String title, required IconData icon, required PaymentMethod method}) {
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
              Icon(icon, color: isSelected ? Colors.white : Colors.black87, size: 28),
              const SizedBox(height: 8),
              Text(
                title,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.black87,
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

  Widget _buildFormContent() {
    switch (controller.selectedMethod.value) {
      case PaymentMethod.creditCard:
        return _buildCreditCardForm();
      case PaymentMethod.mobileWallet:
        return _buildMobileWalletForm();
      case PaymentMethod.cod:
        return _buildCODForm();
      case PaymentMethod.none:
      return const SizedBox.shrink(); // لو مفيش حاجة مختارة
    }
  }

  // ✨ تصميم البطاقة الائتمانية كأنها فيزا حقيقية
  Widget _buildCreditCardForm() {
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
              BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 15, offset: const Offset(0, 8)),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Icon(Icons.contactless_rounded, color: Colors.white70, size: 28),
                  // صورة لوجو ماستركارد من النت كمثال للاحترافية
                  Image.network('https://upload.wikimedia.org/wikipedia/commons/thumb/2/2a/Mastercard-logo.svg/1280px-Mastercard-logo.svg.png', height: 24),
                ],
              ),
              const SizedBox(height: 30),
              const Text(
                '**** **** **** 1234',
                style: TextStyle(color: Colors.white, fontSize: 22, letterSpacing: 2, fontFamily: 'Courier'),
                textDirection: TextDirection.ltr,
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('MOHAMED AHMED', style: TextStyle(color: Colors.white70, fontSize: 14)),
                  const Text('12/24', style: TextStyle(color: Colors.white70, fontSize: 14)),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        const Text('بيانات البطاقة الجديدة', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        _buildTextField(label: 'رقم البطاقة', icon: Icons.credit_card, type: TextInputType.number),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(child: _buildTextField(label: 'MM/YY', icon: Icons.calendar_month, type: TextInputType.datetime)),
            const SizedBox(width: 16),
            Expanded(child: _buildTextField(label: 'CVV', icon: Icons.lock, type: TextInputType.number, isSecure: true)),
          ],
        ),
      ],
    );
  }

  Widget _buildMobileWalletForm() {
    return Column(
      key: const ValueKey('Wallet'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInfoBox('يرجى التأكد من أن المحفظة مفعلة وبها رصيد كافٍ.'),
        const SizedBox(height: 16),
        _buildTextField(label: 'رقم الهاتف المرتبط بالمحفظة', icon: Icons.phone_iphone_rounded, type: TextInputType.phone),
      ],
    );
  }

  Widget _buildCODForm() {
    return _buildInfoBox(
      'الدفع عند الاستلام متاح.\nسوف تقوم بدفع قيمة الطلب نقداً للمندوب عند التوصيل.',
      key: const ValueKey('COD'),
      icon: Icons.local_shipping_outlined,
    );
  }

  // ==========================================
  // ويدجتس مساعدة (Helper Widgets)
  // ==========================================

  Widget _buildInfoBox(String text, {Key? key, IconData icon = Icons.info_outline}) {
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
          Expanded(child: Text(text, style: TextStyle(color: Colors.grey.shade800, height: 1.5))),
        ],
      ),
    );
  }

  Widget _buildTextField({required String label, required IconData icon, required TextInputType type, bool isSecure = false}) {
    return TextFormField(
      keyboardType: type,
      obscureText: isSecure,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.grey.shade500, fontSize: 14),
        prefixIcon: Icon(icon, color: Colors.grey.shade400, size: 20),
        filled: true,
        fillColor: const Color(0xFFF8F9FA), // لون هادي للعين
        contentPadding: const EdgeInsets.symmetric(vertical: 16),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.black, width: 1.5)),
      ),
      validator: (v) => v!.trim().isEmpty ? 'مطلوب' : null,
    );
  }
}