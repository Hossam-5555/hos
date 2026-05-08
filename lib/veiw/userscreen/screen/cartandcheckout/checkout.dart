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
      bottomNavigationBar: GetBuilder<Checkoutcontroller>(
        builder: (c) => _buildModernBottomBar(context, c),
      ),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(65),
        child: Appbarbackicon(herotag: '', title: "confirm order".tr),
      ),
      body: GetBuilder<Checkoutcontroller>(
        builder: (c) => ListView(
          padding: const EdgeInsets.all(16),
          physics: const BouncingScrollPhysics(),
          children: [
            // قسم عنوان التوصيل
            Handlingdataview(
              isFullScreen: false,
              statusrequest: c.statusrequest,
              widget: _buildSectionCard(
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
            ),
            const SizedBox(height: 16),
            // قسم طرق الدفع (بالتصميم الجديد)
            _buildSectionCard(
              title: "Payment Methods".tr,
              icon: Icons.account_balance_wallet_rounded,
              child: GetBuilder<Checkoutcontroller>(
                builder: (c) => Row(
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
      // color: Colors.white,
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
        margin: const EdgeInsets.only(bottom: 5),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? Colors.blueAccent : Colors.transparent,
            width: isSelected ? 1.5 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(
              details["icon"] as IconData,
              color: isSelected ? Colors.blueAccent : Colors.amber,
            ),
            const SizedBox(width: 12),
            Text(
              details["title"] as String,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              details["sub"] as String,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(width: 12),

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
                  title: Text(
                    addr.name ?? "",
                    style: TextStyle(color: Colors.black),
                  ),
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
      margin: EdgeInsetsDirectional.all(20),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // تفاصيل السعر والتوصيل[]
            _buildPriceRow("Sipping".tr, "${50} \$"),
            const SizedBox(height: 8),
            _buildPriceRow("Subtotal".tr, "${c.totalprice} \$"),
            const SizedBox(height: 8),
            _buildPriceRow(
              "موعد التوصيل المتوقع:",
              "خلال 3 أيام",
              isDate: true,
            ),

            const Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Divider(thickness: 1),
            ),

            // الإجمالي الكلي
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Total price".tr,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  '${c.totalprice} \$',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    color: Colors.blueAccent,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // زر التأكيد
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
                onPressed: () => c.checkoutoder(),
                child: Text(
                  "Confirm order".tr,
                  style: const TextStyle(
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
    );
  }

  // "Widget" مساعد لبناء صفوف التفاصيل بشكل منسق
  Widget _buildPriceRow(String label, String value, {bool isDate = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: isDate ? Colors.green : Colors.blue,
          ),
        ),
      ],
    );
  }
}
