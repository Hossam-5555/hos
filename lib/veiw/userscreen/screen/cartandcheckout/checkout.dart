import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hos/controler/usercontroller/checkout&cart/checkoutcontroller.dart';
import 'package:hos/core/class/handlingdataview.dart';
import 'package:hos/veiw/userscreen/screen/profile/settings/addres/add.dart';
import 'package:hos/veiw/wedget/appbarbackicon.dart';

class Checkout extends StatelessWidget {
  const Checkout({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(Checkoutcontroller());

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(65),
        child: Appbarbackicon(herotag: '', title: "confirm order".tr),
      ),
      bottomNavigationBar: GetBuilder<Checkoutcontroller>(
        builder: (c) => _buildModernBottomBar(context, c),
      ),
      body: GetBuilder<Checkoutcontroller>(
        builder: (c) => Handlingdataview(
          statusrequest: c.statusrequest,
          widget: ListView(
            padding: const EdgeInsets.all(16),
            physics: const BouncingScrollPhysics(),
            children: [
              // قسم عنوان التوصيل
              _buildSectionCard(
                title: "shipping address".tr,
                icon: Icons.location_on_rounded,
                child: c.listaddresdata.isEmpty
                    ? ListTile(
                        onTap: () => Get.to(() => AddNewAddres()),
                        tileColor: const Color(0xFFF8F9FA),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        leading: const Icon(
                          Icons.add_location_alt,
                          color: Colors.black87,
                        ),
                        title: Text(
                          "Add new address".tr,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        trailing: const Icon(
                          Icons.add_circle,
                          color: Colors.black,
                        ),
                      )
                    : _buildAddressSelector(c),
              ),
              const SizedBox(height: 16),
              // قسم طرق الدفع (بالتصميم الجديد)
              _buildSectionCard(
                title: "Payment Methods".tr,
                icon: Icons.account_balance_wallet_rounded,
                child: GetBuilder<Checkoutcontroller>(
                  builder: (c) => Column(
                    children: c.paymentMethodEnum.map((methodList) {
                      final method = methodList[0];
                      return _buildPaymentOption(method, c);
                    }).toList(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ================= دوال التصميم =================

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

  Widget _buildAddressSelector(Checkoutcontroller c) {
    return Obx(() {
      final addr = c.listaddresdata.firstWhere(
        (e) => e.id == c.addressid.value,
        orElse: () => c.listaddresdata.first,
      );
      return ListTile(
        contentPadding: EdgeInsets.zero,
        leading: const CircleAvatar(
          backgroundColor: Color(0xFFE3F2FD),
          child: Icon(Icons.home_work, color: Colors.blue),
        ),
        title: Text(
          addr.name ?? "غير معروف",
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          "Change address".tr,
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () => _showAddressesSheet(c),
      );
    });
  }

  // تصميم طرق الدفع الجديد (كروت عمودية قابلة للتحديد)
  Widget _buildPaymentOption(String method, Checkoutcontroller c) {
    final isSelected = c.selectedMethod == method;
    final details =
        {
          "credit": {
            "icon": Icons.credit_card,
            "title": "البطاقة البنكية",
            "sub": "دفع إلكتروني آمن",
          },
          "mobile": {
            "icon": Icons.phone_android,
            "title": "محفظة إلكترونية",
            "sub": "دفع سريع وآمن",
          },
          "cash": {
            "icon": Icons.local_atm,
            "title": "الدفع نقداً",
            "sub": "الدفع عند الاستلام",
          },
        }[method] ??
        {"icon": Icons.payment, "title": method, "sub": ""};

    return InkWell(
      onTap: () => c.changePaymentMethod(method),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected
              ? Colors.blue.withOpacity(0.05)
              : const Color(0xFFF8F9FA),
          border: Border.all(
            color: isSelected ? Colors.blueAccent : Colors.grey.shade200,
            width: isSelected ? 1.5 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(
              details["icon"] as IconData,
              color: isSelected ? Colors.blueAccent : Colors.black54,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    details["title"] as String,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isSelected ? Colors.blueAccent : Colors.black87,
                    ),
                  ),
                  Text(
                    details["sub"] as String,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
            Icon(
              isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
              color: isSelected ? Colors.blueAccent : Colors.grey,
            ),
          ],
        ),
      ),
    );
  }

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
            Text(
              "shipping address".tr,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ...c.listaddresdata.map(
              (addr) => Obx(
                () => RadioListTile(
                  value: addr.id,
                  groupValue: c.addressid.value,
                  activeColor: Colors.blueAccent,
                  title: Text(addr.name ?? ""),
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
              label: Text("Add new address".tr),
            ),
          ],
        ),
      ),
    );
  }

  // تم الحفاظ على شريط الدفع السفلي كما هو بدون تغيير
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

                onPressed: () {
                  c.checkoutoder();
                },
                child: Text(
                  "Confirm order".tr,
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
