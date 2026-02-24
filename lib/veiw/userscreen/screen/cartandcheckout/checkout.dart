import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hos/controler/usercontroller/checkout&cart/checkoutcontroller.dart';
import 'package:hos/controler/usercontroller/profile/paymentcontroller.dart';
import 'package:hos/core/class/handlingdataview.dart';
import 'package:hos/core/conistant/appcolor.dart';
import 'package:hos/veiw/userscreen/screen/profile/settings/addres/add.dart';
import 'package:hos/veiw/wedget/appbarbackicon.dart';

class Checkout extends StatelessWidget {
  const Checkout({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(Checkoutcontroller());
    final h = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F8), // لون خلفية أحدث وأكثر نعومة
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(65),
        child: Appbarbackicon(herotag: '', title: "إتمام الطلب"),
      ),
      // شريط الفاتورة الثابت بالأسفل
      bottomNavigationBar: GetBuilder<Checkoutcontroller>(
        builder: (_) => _bottomSummary(controller, h),
      ),
      // جسم الشاشة الرئيسي
      body: GetBuilder<Checkoutcontroller>(
        builder: (_) {
          return Handlingdataview(
            statusrequest: controller.statusrequest!,
            widget: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.only(left: 16, right: 16, top: 20, bottom: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// ===== 1. Delivery Address (تصميم احترافي جديد) =====
                  _buildSectionHeader(Icons.location_on_rounded, "التوصيل إلى"),
                  const SizedBox(height: 12),
                  // ✅ تم إزالة Obx من هنا لإصلاح خطأ GetX (GetBuilder يتكفل بالتحديث)
                  controller.listaddresdata.isEmpty
                      ? _emptyAddressCard()
                      : _selectedAddressCard(controller),

                  const SizedBox(height: 28),

                  /// ===== 2. Payment Method (تصميم البطاقات التفاعلية) =====
                  _buildSectionHeader(Icons.account_balance_wallet_rounded, "طريقة الدفع"),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: _cardDecoration(),
                    child: Column(
                      children: [
                        _paymentMethodsSelector(controller),
                        const SizedBox(height: 16),
                        Obx(() => buildPaymentForm(controller)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // ================= UI Helpers =================
  BoxDecoration _cardDecoration() => BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      );

  Widget _buildSectionHeader(IconData icon, String title) => Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Appcolor.primaryColor.withOpacity(0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: Appcolor.primaryColor, size: 20),
          ),
          const SizedBox(width: 12),
          Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
        ],
      );

  // ================= Address Section =================
  Widget _selectedAddressCard(Checkoutcontroller controller) {
    // ✅ Obx هنا فقط لأننا نقرأ قيمة متغيرة (addressid.value)
    return Obx(() {
      final selectedAddress = controller.listaddresdata.firstWhere(
        (e) => e.addresId == controller.addressid.value,
        orElse: () => controller.listaddresdata.first,
      );

      return Container(
        padding: const EdgeInsets.all(16),
        decoration: _cardDecoration(),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: Colors.grey[100], shape: BoxShape.circle),
              child: const Icon(Icons.location_city_rounded, color: Colors.grey, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("العنوان الحالي", style: TextStyle(fontSize: 12, color: Colors.grey)),
                  const SizedBox(height: 4),
                  Text(
                    selectedAddress.addresName ?? "عنوان غير معروف",
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            // زر التغيير الذي يفتح الـ BottomSheet
            TextButton(
              onPressed: () => _showAddressesBottomSheet(controller),
              style: TextButton.styleFrom(
                backgroundColor: Appcolor.primaryColor.withOpacity(0.1),
                foregroundColor: Appcolor.primaryColor,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text("تغيير", style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      );
    });
  }

  void _showAddressesBottomSheet(Checkoutcontroller controller) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(width: 40, height: 5, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(10))),
            const SizedBox(height: 20),
            const Text("اختر عنوان التوصيل", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            Flexible(
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: controller.listaddresdata.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final addr = controller.listaddresdata[index];
                  return Obx(() {
                    final isSelected = controller.addressid.value == addr.addresId;
                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Icon(
                        isSelected ? Icons.check_circle_rounded : Icons.location_on_outlined,
                        color: isSelected ? Appcolor.primaryColor : Colors.grey,
                      ),
                      title: Text(addr.addresName ?? "", style: TextStyle(fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
                      onTap: () {
                        controller.chooseAddres(addr.addresId!);
                        Get.back(); // إغلاق النافذة بعد الاختيار
                      },
                    );
                  });
                },
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  Get.back();
                  Get.to(() => AddNewAddres());
                },
                icon: const Icon(Icons.add),
                label: const Text("إضافة عنوان جديد"),
                style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 12), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
              ),
            )
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }

  Widget _emptyAddressCard() => GestureDetector(
        onTap: () => Get.to(() => AddNewAddres(), transition: Transition.cupertino),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Appcolor.primaryColor.withOpacity(0.05),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Appcolor.primaryColor.withOpacity(0.3), width: 1.5, style: BorderStyle.solid),
          ),
          child: Row(
            children: [
              Icon(Icons.add_location_alt_rounded, color: Appcolor.primaryColor, size: 30),
              const SizedBox(width: 16),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("إضافة عنوان للتوصيل", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    SizedBox(height: 4),
                    Text("يرجى إضافة عنوان لإتمام الطلب بنجاح.", style: TextStyle(fontSize: 13, color: Colors.grey)),
                  ],
                ),
              ),
            ],
          ),
        ),
      );

  // ================= Payment Section =================
  Widget _paymentMethodsSelector(Checkoutcontroller controller) => SizedBox(
        height: 80,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          itemCount: controller.paymentMethodEnum.length,
          separatorBuilder: (_, __) => const SizedBox(width: 12),
          itemBuilder: (context, i) {
            // ✅ تم إصلاح الفهرس لتجنب RangeError
            final methodList = controller.paymentMethodEnum[i]; 
            final methodEnum = methodList[0]; // نوع الدفع
            // final methodImage = methodList[1]; // في حال أردت استخدام الصورة لاحقاً

            return Obx(() {
              final isSelected = controller.selectedMethod.value == methodEnum;
              return GestureDetector(
                onTap: () => controller.changePaymentMethod(methodEnum),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  width: 90,
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: isSelected ? Appcolor.primaryColor.withOpacity(0.05) : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isSelected ? Appcolor.primaryColor : Colors.grey[300]!,
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Icon(
                        methodEnum == PaymentMethod.cod ? Icons.payments_outlined : Icons.credit_card,
                        color: isSelected ? Appcolor.primaryColor : Colors.grey,
                        size: 32,
                      ),
                      if (isSelected)
                        Positioned(
                          top: -4,
                          right: -4,
                          child: Container(
                            padding: const EdgeInsets.all(2),
                            decoration:  BoxDecoration(color: Appcolor.primaryColor, shape: BoxShape.circle),
                            child: const Icon(Icons.check, size: 12, color: Colors.white),
                          ),
                        ),
                    ],
                  ),
                ),
              );
            });
          },
        ),
      );

  // ================= Bottom Summary =================
  Widget _bottomSummary(Checkoutcontroller controller, double h) => Container(
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 30),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 20, offset: const Offset(0, -5))],
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _priceRow("المجموع الفرعي", controller.totalprice),
              _priceRow("رسوم التوصيل", "10.0"), // قم بتغييرها لمتغير إن وجد
              const SizedBox(height: 8),
              const Divider(color: Colors.black12),
              const SizedBox(height: 8),
              _priceRow("الإجمالي (يشمل الضريبة)", controller.totalprice, isTotal: true),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Appcolor.primaryColor,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    elevation: 0,
                  ),
                  onPressed: () => controller.checkoutoder(h - 100),
                  child: const Text("تأكيد الطلب", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      );

  Widget _priceRow(String label, String value, {bool isTotal = false}) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: isTotal ? 16 : 14, fontWeight: isTotal ? FontWeight.bold : FontWeight.w500, color: Colors.grey[700])),
          Text("\$$value", style: TextStyle(fontSize: isTotal ? 22 : 16, fontWeight: FontWeight.w900, color: Appcolor.primaryColor)),
        ],
      );
}

// ================= Payment Form Switcher =================
Widget buildPaymentForm(Checkoutcontroller controller) {
  // ✅ المفاتيح (ValueKey) تمنع تعطل الأنيميشن والـ RangeError
  return AnimatedSwitcher(
    duration: const Duration(milliseconds: 300),
    child: _getPaymentFormWidget(controller),
  );
}

Widget _getPaymentFormWidget(Checkoutcontroller controller) {
  switch (controller.selectedMethod.value) {
    case PaymentMethod.creditCard:
      return Container(
        key: const ValueKey('credit'),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: Colors.grey[50], borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey[200]!)),
        child: const Row(
          children: [
            Icon(Icons.credit_card, color: Colors.blueGrey),
            SizedBox(width: 12),
            Text("البطاقة تنتهي بـ 1234", style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      );
    case PaymentMethod.mobileWallet:
      return Container(
        key: const ValueKey('wallet'),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: Colors.grey[50], borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey[200]!)),
        child: const Row(
          children: [
            Icon(Icons.account_balance_wallet, color: Colors.blueGrey),
            SizedBox(width: 12),
            Text("المحفظة الإلكترونية", style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      );
    case PaymentMethod.cod:
      return Container(
        key: const ValueKey('cod'),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(color: Colors.orange.withOpacity(0.1), borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.orange.withOpacity(0.3))),
        child: Row(
          children: [
            const Icon(Icons.delivery_dining_rounded, color: Colors.orange),
            const SizedBox(width: 12),
            Expanded(child: Text("الدفع نقداً عند الاستلام. يرجى تحضير المبلغ.", style: TextStyle(fontSize: 14, color: Colors.orange[800]))),
          ],
        ),
      );
    case PaymentMethod.none:
    return const SizedBox(key: ValueKey('empty'), height: 50); 
  }
}