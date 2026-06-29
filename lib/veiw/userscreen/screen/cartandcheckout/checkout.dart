import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hos/controler/usercontroller/checkout&cart/checkoutcontroller.dart';
import 'package:hos/controler/usercontroller/profile/paymentcontroller.dart';
import 'package:hos/core/class/handlingdataview.dart';
import 'package:hos/veiw/userscreen/screen/profile/settings/addres/add.dart';
import 'package:hos/veiw/wedget/appbarbackicon.dart';
import 'package:hos/veiw/wedget/auth/checkbutton.dart';
import 'package:hos/veiw/wedget/paymentmethods.dart';

class Checkout extends StatelessWidget {
  const Checkout({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(Checkoutcontroller());
    PaymentController controller1 = Get.put(PaymentController());

    return Scaffold(
      // شيلنا الـ bottomNavigationBar خالص لأن الزرار اتنقل جوة الشاشة
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(65),
        child: Appbarbackicon(herotag: '', title: "confirm order".tr),
      ),
      body: GetBuilder<Checkoutcontroller>(
        builder: (c) => ListView(
          padding: const EdgeInsets.all(16),
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
                    : _buildAddressSelector(c, context),
              ),
            ),
            const SizedBox(height: 16),

            const SizedBox(height: 16),

            // الـ Form وبداخله اختيارات الدفع وزرار التأكيد الجديد
            Form(
              key: controller1.formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'اختر طريقة الدفع',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 16),

                  // 1. اختيارات الدفع (بطاقة، محفظة، كاش)
                  GetBuilder<Checkoutcontroller>(
                    builder: (c) => Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        buildPaymentMethod(
                          controller: c,
                          title: 'بطاقة ائتمان',
                          icon: Icons.credit_card_rounded,
                          method: "credit",
                        ),
                        const SizedBox(width: 8),
                        buildPaymentMethod(
                          controller: c,
                          title: 'محفظة',
                          icon: Icons.account_balance_wallet_rounded,
                          method: "mobile",
                        ),
                        const SizedBox(width: 8),
                        buildPaymentMethod(
                          controller: c,
                          title: 'كاش',
                          icon: Icons.money_rounded,
                          method: "cash",
                        ),
                      ],
                    ),
                  ),

                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 24),
                    child: Divider(height: 1),
                  ),

                  // 2. نموذج الدفع الديناميكي (بيظهر حسب الاختيار)
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

                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 24),
                    child: Divider(thickness: 1),
                  ),

                  // 3. تفاصيل الحساب والأسعار تحت الـ Form مباشرة
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Total price".tr,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
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

                  const SizedBox(height: 24),

                  // 🔥 زرار التأكيد تم وضعه هنا (تحت الـ Form والأسعار مباشرة)
                  Checkbutton(
                    width: MediaQuery.of(context).size.width,
                    buttonColor: Colors.black,
                    onTap: () {
                      print("Hssa");
                      c.checkoutoder(); // الآن يستدعي الكنترولر بأمان بدون تعارض
                    },
                    buttonName: "confirm order".tr,
                    statusrequest: c.statusrequest,
                  ),
                  const SizedBox(height: 20), // مسافة أمان أسفل الشاشة
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ================= دوال التصميم الفرعية =================

  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(20),
      ),
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

  Widget _buildAddressSelector(Checkoutcontroller c, BuildContext con) {
    return Obx(() {
      // 1️⃣ حماية: لو لسه البيانات مفيش فيها عنوان مختار (الـ API بيحمل)
      if (c.selectedAddress.value == null) {
        return const ListTile(
          contentPadding: EdgeInsets.zero,
          leading: CircularProgressIndicator(),
          title: Text("جاري تحميل العنوان الافتراضي..."),
        );
      }

      // 2️⃣ الـ UI بياخد البيانات الجاهزة من الكنترولر فوراً وبدون أي لفة!
      final addr = c.selectedAddress.value!;

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
        onTap: () => _showAddressesSheet(c, con),
      );
    });
  }

  void _showAddressesSheet(Checkoutcontroller c, BuildContext context) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: context.isDarkMode ? Color(0xff323538) : Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
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
                    // 💡 تحديد الـ Type هنا كـ int أفضل لـ Radio
                    value:
                        addr.id ??
                        0, // الـ ID الخاص بهذا العنوان في اللفة الحالية
                    groupValue: c
                        .selectedAddress
                        .value
                        ?.id, // مقارنته بـ ID العنوان المختار بالكنترولر
                    activeColor: Colors.green,
                    title: Text(
                      addr.name ?? "",
                      style: const TextStyle(color: Colors.black),
                    ),
                    onChanged: (val) {
                      if (val != null) {
                        // 💡 التعديل الجوهري: بنباصي الـ addr بالكامل (الـ Object) مش الـ ID
                        c.chooseAddres(addr);
                        Get.back(); // إغلاق الـ BottomSheet بعد الاختيار
                      }
                    },
                  ),
                ),
              ),
              const SizedBox(height: 10), // مسافة بسيطة قبل الزرار
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
      ),
    );
  }

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
