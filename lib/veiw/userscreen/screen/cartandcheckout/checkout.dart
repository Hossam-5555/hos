import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hos/controler/usercontroller/checkout&cart/checkoutcontroller.dart';
import 'package:hos/core/class/crud.dart';
import 'package:hos/core/class/handlingdataview.dart';
import 'package:hos/veiw/userscreen/screen/profile/addres/add.dart';
import 'package:hos/veiw/wedget/appbarbackicon.dart';
import 'package:hos/veiw/wedget/auth/checkbutton.dart';
import 'package:hos/veiw/wedget/paymentmethods.dart';

class Checkout extends StatelessWidget {
  const Checkout({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.put(Checkoutcontroller());

    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GetBuilder<Checkoutcontroller>(
          builder: (controller) => Checkbutton(
            width: MediaQuery.of(context).size.width * 0.9,
            buttonColor: Colors.black,
            onTap: () {
              c.checkoutoder();
            },
            buttonName: "Pay Now".tr,
            statusrequest: c.statusrequest,
          ),
        ),
      ),
      appBar: Appbarbackicon(title: "confirm order".tr, herotag: "checkout"),
      body: GetBuilder<Checkoutcontroller>(
        builder: (c) => ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          children: [
            // ================= طرق الدفع =================
            _buildCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GetBuilder<Checkoutcontroller>(
                    builder: (c) => Column(
                      children: [
                        buildPaymentMethod(
                          controller: c,
                          title: 'بطاقة ائتمان',
                          subtitle: '******** 8463',
                          icon: Icons.credit_card_rounded,
                          iconColor: const Color(0xFFEB5757),
                          method: "card",
                        ),
                        buildPaymentMethod(
                          controller: c,
                          title: 'محفظة',
                          subtitle: 'orb****@gmail.com',
                          icon: Icons.account_balance_wallet_rounded,
                          iconColor: const Color(0xFF2D9CDB),
                          method: "wallet",
                        ),
                        buildPaymentMethod(
                          controller: c,
                          title: 'كاش',
                          icon: Icons.attach_money_rounded,
                          iconColor: Colors.green,
                          method: "cash",
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            GetBuilder<Checkoutcontroller>(
              builder: (c) => AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                switchInCurve: Curves.easeOutCubic,
                transitionBuilder: (child, animation) => FadeTransition(
                  opacity: animation,
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0, 0.05),
                      end: Offset.zero,
                    ).animate(animation),
                    child: child,
                  ),
                ),
                child: buildFormContent(c),
              ),
            ),
            const SizedBox(height: 16),

            // ================= عنوان التوصيل =================
            HandlingDataView(
              mode: HandlingMode.skeleton,
              statusrequest: Statusrequest.none,
              widget: _buildCard(
                child: c.listaddresdata.isEmpty
                    ? ListTile(
                        contentPadding: EdgeInsets.zero,
                        onTap: () => Get.to(() => AddNewAddres()),
                        leading: const Icon(Icons.add_location_alt),
                        title: Text(
                          "Add new address".tr,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        trailing: const Icon(Icons.add_circle),
                      )
                    : _buildAddressSelector(c, context),
              ),
            ),
            const SizedBox(height: 16),

            // ================= ملخص الطلب =================
            _buildCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Order Summary".tr,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildPriceRow("Order Amount".tr, "\$${c.totalprice}"),
                  const SizedBox(height: 10),
                  _buildPriceRow("Delivery".tr, "\$50"),
                  const SizedBox(height: 16),
                  const Divider(height: 1),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Total Amount".tr,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      Text(
                        '\$${c.totalprice}',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFFFF7A45),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // ================= الفورم الديناميكي + زرار التأكيد =================
          ],
        ),
      ),
    );
  }

  // ================= دوال التصميم الفرعية =================

  Widget _buildCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(Get.context!).cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(10),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _buildAddressSelector(Checkoutcontroller c, BuildContext con) {
    return Obx(() {
      if (c.selectedAddress.value == null) {
        return const Row(
          children: [
            SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
            SizedBox(width: 12),
            Text("جاري تحميل العنوان الافتراضي..."),
          ],
        );
      }

      final addr = c.selectedAddress.value!;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Delivery Address".tr,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 12),
          InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () => _showAddressesSheet(c, con),
            child: Row(
              children: [
                const Icon(Icons.location_on_rounded, size: 20),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        addr.street ?? "غير معروف",
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        addr.city ?? "غير معروف",
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 14,
                  color: Colors.grey,
                ),
              ],
            ),
          ),
        ],
      );
    });
  }

  void _showAddressesSheet(Checkoutcontroller c, BuildContext context) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: context.isDarkMode ? const Color(0xff323538) : Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "shipping address".tr,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              ...c.listaddresdata.map(
                (addr) => Obx(
                  () => RadioListTile<int>(
                    value: addr.id ?? 0,
                    // ignore: deprecated_member_use
                    groupValue: c.selectedAddress.value?.id,
                    activeColor: Colors.green,
                    title: Text(addr.city ?? ""),
                    subtitle: Text(
                      addr.street ?? "",
                      style: const TextStyle(color: Colors.grey),
                    ),
                    // ignore: deprecated_member_use
                    onChanged: (val) {
                      if (val != null) {
                        c.chooseAddres(addr);
                        Get.back();
                      }
                    },
                  ),
                ),
              ),
              const SizedBox(height: 10),

              Checkbutton(
                width: MediaQuery.of(context).size.width,
                buttonColor: Colors.black,
                onTap: () {
                  Get.back();
                  Get.to(() => AddNewAddres());
                },
                buttonName: "Add new address".tr,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPriceRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.grey,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
        ),
      ],
    );
  }
}
