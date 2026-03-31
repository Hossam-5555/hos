import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hos/controler/usercontroller/checkout&cart/checkoutcontroller.dart';
import 'package:hos/controler/usercontroller/profile/paymentcontroller.dart';
import 'package:hos/core/class/handlingdataview.dart';
import 'package:hos/veiw/userscreen/screen/profile/settings/addres/add.dart';
import 'package:hos/veiw/wedget/appbarbackicon.dart';

class Checkout extends StatelessWidget {
  const Checkout({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(Checkoutcontroller());

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F9), // خلفية عصرية رمادي فاتح
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(65),
        child: Appbarbackicon(herotag: '', title: "إتمام الطلب"),
      ),
      // دمجنا شريط الدفع السفلي ليكون عائم وشيك
      bottomNavigationBar: GetBuilder<Checkoutcontroller>(
        builder: (c) => _buildModernBottomBar(context, c),
      ),
      body: GetBuilder<Checkoutcontroller>(
        builder: (c) => Handlingdataview(
          statusrequest: c.statusrequest!,
          widget: ListView(
            padding: const EdgeInsets.all(16),
            physics: const BouncingScrollPhysics(),
            children: [
              _buildSectionCard(
                title: "عنوان التوصيل",
                icon: Icons.location_on_rounded,
                child: c.listaddresdata.isEmpty
                    ? _buildActionTile(
                        "إضافة عنوان جديد",
                        Icons.add_location_alt,
                        () => Get.to(() => AddNewAddres()),
                      )
                    : _buildAddressSelector(c),
              ),
              const SizedBox(height: 16),
              _buildSectionCard(
                title: "Payment Methods".tr,
                icon: Icons.account_balance_wallet_rounded,
                child: Column(
                  children: [
                    _buildPaymentChips(c),
                    Obx(() => _buildPaymentDetails(c.selectedMethod.value)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ================= دوال التصميم (Helper Methods) =================

  // 1. كارت موحد لكل قسم لتوحيد الشكل وتقليل الكود
  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Colors.blueAccent, size: 22),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
            const Divider(height: 24, thickness: 0.5),
            child,
          ],
        ),
      ),
    );
  }

  // 2. تصميم عنصر العنوان مع إمكانية تغييره
  Widget _buildAddressSelector(Checkoutcontroller c) {
    return Obx(() {
      final addr = c.listaddresdata.firstWhere(
        (e) => e.addresId == c.addressid.value,
        orElse: () => c.listaddresdata.first,
      );
      return ListTile(
        contentPadding: EdgeInsets.zero,
        leading: const CircleAvatar(
          backgroundColor: Color(0xFFE3F2FD),
          child: Icon(Icons.home_work, color: Colors.blue),
        ),
        title: Text(
          addr.addresName ?? "غير معروف",
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: const Text(
          "اضغط لتغيير العنوان",
          style: TextStyle(fontSize: 12, color: Colors.grey),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () => _showAddressesSheet(c),
      );
    });
  }

  // 3. أزرار الدفع العصرية (Chips)
  Widget _buildPaymentChips(Checkoutcontroller c) {
    return SizedBox(
      height: 50,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: c.paymentMethodEnum.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (_, i) {
          final method = c.paymentMethodEnum[i][0];
          return Obx(() {
            final isSelected = c.selectedMethod.value == method;
            return ChoiceChip(
              label: Text(method == PaymentMethod.cod ? "كاش" : "بطاقة/محفظة"),
              selected: isSelected,
              selectedColor: Colors.black,
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : Colors.black87,
                fontWeight: FontWeight.bold,
              ),
              backgroundColor: Colors.grey.shade100,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              onSelected: (_) => c.changePaymentMethod(method),
            );
          });
        },
      ),
    );
  }

  // 4. تفاصيل الدفع بناءً على الاختيار
  Widget _buildPaymentDetails(PaymentMethod method) {
    if (method == PaymentMethod.none) return const SizedBox.shrink();

    final details = {
      PaymentMethod.creditCard: {
        "icon": Icons.credit_card,
        "title": "البطاقة البنكية",
        "sub": "تنتهي بـ 1234",
      },
      PaymentMethod.mobileWallet: {
        "icon": Icons.phone_android,
        "title": "محفظة إلكترونية",
        "sub": "دفع سريع وآمن",
      },
      PaymentMethod.cod: {
        "icon": Icons.delivery_dining,
        "title": "الدفع عند الاستلام",
        "sub": "ادفع نقداً للمندوب",
      },
    }[method]!;

    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: _buildActionTile(
        details["title"] as String,
        details["icon"] as IconData,
        null,
        subtitle: details["sub"] as String,
      ),
    );
  }

  // 5. زر الأكشن (عنصر قائمة جاهز)
  Widget _buildActionTile(
    String title,
    IconData icon,
    VoidCallback? onTap, {
    String? subtitle,
  }) {
    return ListTile(
      onTap: onTap,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      tileColor: const Color(0xFFF8F9FA),
      leading: Icon(icon, color: Colors.black87),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
      ),
      subtitle: subtitle != null
          ? Text(subtitle, style: const TextStyle(fontSize: 12))
          : null,
      trailing: onTap != null
          ? const Icon(Icons.add_circle, color: Colors.black)
          : null,
    );
  }

  // 6. البوتوم شيت لاختيار العنوان (مبسط)
  void _showAddressesSheet(Checkoutcontroller c) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "اختر عنوان التوصيل",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ...c.listaddresdata.map(
              (addr) => Obx(
                () => RadioListTile(
                  value: addr.addresId,
                  // ignore: deprecated_member_use
                  groupValue: c.addressid.value,
                  activeColor: Colors.blueAccent,
                  title: Text(addr.addresName ?? ""),
                  // ignore: deprecated_member_use
                  onChanged: (val) {
                    c.chooseAddres(val!);
                    Get.back();
                  },
                ),
              ),
            ),
            TextButton.icon(
              onPressed: () {
                Get.back();
                Get.to(() => AddNewAddres());
              },
              icon: const Icon(Icons.add),
              label: const Text("إضافة عنوان جديد"),
            ),
          ],
        ),
      ),
    );
  }

  // 7. شريط الدفع السفلي (نظيف ومختصر)
  Widget _buildModernBottomBar(BuildContext context, Checkoutcontroller c) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 15,
            offset: Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "الإجمالي (شامل التوصيل):",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  '${double.parse(c.totalprice.toString()).toStringAsFixed(2)} \$',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    color: Colors.blueAccent,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40),
                  ),
                ),
                onPressed: () =>
                    c.checkoutoder(MediaQuery.of(context).size.height - 100),
                child: const Text(
                  "تأكيد الطلب",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
