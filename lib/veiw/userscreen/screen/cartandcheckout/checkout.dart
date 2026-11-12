import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hos/controler/usercontroller/checkout&cart/checkoutcontroller.dart';
import 'package:hos/data/services/crud.dart';
import 'package:hos/core/class/handlingdataview.dart';
import 'package:hos/core/conistant/imageasset.dart';
import 'package:hos/veiw/userscreen/screen/profile/addres/add.dart';
import 'package:hos/veiw/wedget/animation.dart';
import 'package:hos/veiw/wedget/appbarbackicon.dart';
import 'package:hos/veiw/wedget/auth/checkbutton.dart';
import 'package:hos/veiw/wedget/order/ordersdetails.dart';
import 'package:hos/veiw/wedget/paymentmethods.dart';
import 'package:hos/veiw/wedget/pricecard.dart';
import 'package:hos/veiw/wedget/shoppage/coubone.dart';

class Checkout extends StatelessWidget {
  const Checkout({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.put(Checkoutcontroller());

    // 1. استخراج أبعاد الشاشة وتحديد حدود آمنة للخطوط والمسافات
    final size = MediaQuery.of(context).size;
    final w = size.width;
    final h = size.height;

    // دوال مساعدة سريعة للنسب المئوية مع حدود دنيا وقصوى (Clamp) عشان متبوظش في الشاشات الضخمة أو الصغيرة أوي
    double wp(double percent) => (w * percent);
    double hp(double percent) => (h * percent);
    double sp(double size) => (w * (size / 375)).clamp(
      size * 0.85,
      size * 1.25,
    ); // 375 هو عرض الشاشة القياسي

    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(
          left: wp(0.04),
          right: wp(0.04),
          bottom: hp(0.01).clamp(5.0, 15.0),
        ),
        child: SafeArea(
          child: Center(
            heightFactor: 1,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 600), // حماية للتابلت
              child: GetBuilder<Checkoutcontroller>(
                builder: (controller) => Checkbutton(
                  width: w > 600 ? 550 : wp(0.92),
                  buttonColor: Colors.black,
                  onTap: () => c.checkoutoder(),
                  buttonName: "Pay Now".tr,
                  statusrequest: c.statusrequest,
                ),
              ),
            ),
          ),
        ),
      ),
      appBar: Appbarbackicon(title: "confirm order".tr, herotag: "checkout"),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 600,
          ), // توسيط المحتوى لو الشاشة عريضة
          child: GetBuilder<Checkoutcontroller>(
            builder: (c) {
              final List<Widget> checkoutSections = [
                // ================= قسم طرق الدفع =================
                _buildCard(
                  context: context,
                  w: w,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Payment Methods".tr,
                        style: TextStyle(
                          fontSize: sp(16),
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      SizedBox(height: hp(0.015)),
                      buildPaymentMethod(context: context,
                        controller: c,
                        w: w,
                        h: h,
                        sp: sp,
                        title: 'card'.tr,
                        subtitle: '******** 8463',
                        icon: Icons.credit_card_rounded,
                        iconColor: const Color(0xFFEB5757),
                        method: "card",
                      ),
                      buildPaymentMethod(context: context,
                        controller: c,
                        w: w,
                        h: h,
                        sp: sp,
                        title: 'wallet'.tr,
                        subtitle: 'orb****@gmail.com',
                        icon: Icons.account_balance_wallet_rounded,
                        iconColor: const Color(0xFF2D9CDB),
                        method: "wallet",
                      ),
                      buildPaymentMethod(context: context,
                        controller: c,
                        w: w,
                        h: h,
                        sp: sp,
                        title: 'cash on delivery'.tr,
                        icon: Icons.attach_money_rounded,
                        iconColor: Colors.green,
                        method: "cash",
                      ),
                    ],
                  ),
                ),

                // ================= قسم عنوان التوصيل =================
                HandlingDataView(
                  mode: HandlingMode.skeleton,
                  statusrequest: Statusrequest.none,
                  widget: _buildCard(
                    context: context,
                    w: w,
                    child:
                        c.listaddresdata.isEmpty &&
                            c.statusrequest == Statusrequest.success
                        ? ListTile(
                            contentPadding: EdgeInsets.zero,
                            onTap: () => Get.to(() => AddNewAddres()),
                            leading: Icon(Icons.add_location_alt, size: sp(24)),
                            title: Text(
                              "Add new address".tr,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: sp(14),
                              ),
                            ),
                            trailing: Icon(Icons.add_circle, size: sp(22)),
                          )
                        : _buildAddressSelector(c, context, w, h, sp),
                  ),
                ),

                // ================= قسم الكوبون =================
                Coubone(c: c),

                // ================= قسم ملخص الطلب =================
                _buildCard(
                  context: context,
                  w: w,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Order Summary".tr,
                        style: TextStyle(
                          fontSize: sp(16),
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      SizedBox(height: hp(0.018)),
                      if (c.couponDiscount > 0) ...[
                        _buildPriceRow(
                          "Discount".tr,
                          "-${c.couponDiscount.toStringAsFixed(2)}",
                          sp,
                        ),
                        SizedBox(height: hp(0.015)),
                      ],
                      _buildPriceRow("Shipping".tr, "50", sp),
                      SizedBox(height: hp(0.018)),
                      const Divider(height: 1),
                      SizedBox(height: hp(0.018)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Total price".tr,
                            style: TextStyle(
                              fontSize: sp(15),
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          PriceText("${c.total}", fontSize: sp(20)),
                        ],
                      ),
                    ],
                  ),
                ),
              ];

              return ListView.separated(
                padding: EdgeInsets.fromLTRB(
                  wp(0.04),
                  hp(0.01),
                  wp(0.04),
                  hp(0.03),
                ),
                itemCount: checkoutSections.length,
                separatorBuilder: (context, index) =>
                    SizedBox(height: hp(0.02)),
                itemBuilder: (context, index) {
                  return FadeInUp(
                    delay: Duration(milliseconds: index * 40),
                    duration: const Duration(milliseconds: 500),
                    child: checkoutSections[index],
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }

  // ================= دوال التصميم الفرعية (تمرير الأبعاد) =================

  Widget _buildCard({
    required BuildContext context,
    required double w,
    required Widget child,
  }) {
    final padding = (w * 0.020).clamp(10.0, 20.0);
    final radius = (w * 0.05).clamp(16.0, 24.0);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.withAlpha(40)),
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(radius),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withAlpha(20),
            blurRadius: 5,
            offset: const Offset(0, 0.2),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _buildAddressSelector(
    Checkoutcontroller c,
    BuildContext con,
    double w,
    double h,
    double Function(double) sp,
  ) {
    final iconCircleSize = (w * 0.11).clamp(36.0, 48.0);

    return Obx(() {
      if (c.selectedAddress.value == null) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                "جاري تحميل العنوان الافتراضي...",
                style: TextStyle(fontSize: sp(13)),
              ),
            ),
            SizedBox(
              width: iconCircleSize,
              height: iconCircleSize,
              child: Animationforstatus(animationPath: Imageasset.loading),
            ),
          ],
        );
      }

      final addr = c.selectedAddress.value!;

      return Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  "shipping address".tr,
                  style: TextStyle(
                    fontSize: sp(16),
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              TextButton.icon(
                onPressed: () => _showAddressesSheet(c, con, w, h, sp),
                icon: Icon(
                  Icons.edit_outlined,
                  size: 16,
                  color: Colors.deepOrange,
                ),
                label: Text(
                  "Edit".tr,
                  style: TextStyle(
                    fontSize: sp(13),
                    color: Colors.red,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: h * 0.013),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              detailRow(
                icon: Icons.person_outline,
                title: "Name".tr,
                value: addr.name!,
              ),
              SizedBox(height: h * 0.01),

              detailRow(
                icon: Icons.phone_outlined,
                title: "Phone Number".tr,
                value: addr.phone ?? "-",
              ),
              SizedBox(height: h * 0.01),

              detailRow(
                icon: Icons.location_on_outlined,
                title: "shipping address".tr,
                value: "${addr.city ?? ""} - ${addr.street ?? ""}",
              ),
              SizedBox(height: h * 0.01),
            ],
          ),
        ],
      );
    });
  }

  void _showAddressesSheet(
    Checkoutcontroller c,
    BuildContext context,
    double w,
    double h,
    double Function(double) sp,
  ) {
    Get.bottomSheet(
      Center(
        heightFactor: 1,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Container(
            padding: EdgeInsets.all((w * 0.05).clamp(16.0, 24.0)),
            decoration: BoxDecoration(
              color: context.isDarkMode
                  ? const Color(0xFF121212)
                  : Colors.white,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(24),
              ),
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "shipping address".tr,
                    style: TextStyle(
                      fontSize: sp(18),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: h * 0.02),
                  ...c.listaddresdata.map(
                    (addr) => Obx(
                      () => RadioListTile<int>(
                        value: addr.id ?? 0,
                        groupValue: c.selectedAddress.value?.id,
                        activeColor: Colors.green,
                        title: Text(
                          addr.phone ?? "",
                          style: TextStyle(fontSize: sp(14)),
                        ),
                        subtitle: Text(
                          addr.street ?? "",
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: sp(12),
                          ),
                        ),

                        onChanged: (val) {
                          if (val != null) {
                            c.chooseAddres(addr);
                            Get.back();
                          }
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: h * 0.015),
                  Checkbutton(
                    width: w > 600 ? 550 : w,
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
        ),
      ),
    );
  }

  Widget _buildPriceRow(
    String label,
    String value,
    double Function(double) sp,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: sp(14),
            color: Colors.grey,
            fontWeight: FontWeight.w500,
          ),
        ),
        PriceText(value, fontSize: sp(14)),
      ],
    );
  }
}
