import 'package:animate_do/animate_do.dart'; // 1. استدعاء مكتبة الأنيميشن
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hos/controler/usercontroller/profile/order/ordercontroller.dart';
import 'package:hos/controler/usercontroller/profile/order/orderdetailescontroller.dart';
import 'package:hos/veiw/wedget/appbarbackicon.dart';
import 'package:hos/veiw/wedget/auth/checkbutton.dart';
import 'package:hos/veiw/wedget/order/ordersdetails.dart';

class Orderdetailes extends StatelessWidget {
  const Orderdetailes({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.put(Orderdetailescontroller());
    Get.find<Ordercontroller>();

    final w = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: Appbarbackicon(herotag: '', title: c.order?.orderNumber ?? ''),
      ),
      bottomNavigationBar: c.order!.status.toLowerCase() == "pending"
          ? GetBuilder<Ordercontroller>(
              builder: (controller) {
                return SafeArea(
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: w * 0.04,
                      right: w * 0.04,
                      bottom: 5,
                    ),
                    child: FadeInUp(
                      // زر الإلغاء يظهر في الآخر بعد اكتمال ظهور الكروت
                      delay: const Duration(milliseconds: 500),
                      duration: const Duration(milliseconds: 400),
                      child: Checkbutton(
                        statusrequest: controller.statusrequest,
                        buttonColor: Colors.black,
                        width: w,
                        onTap: () {
                          controller.deleteorders(c.order!.orderId);
                        },
                        buttonName: "Cancel Order",
                      ),
                    ),
                  ),
                );
              },
            )
          : const SizedBox.shrink(),
      body: GetBuilder<Orderdetailescontroller>(
        builder: (_) {
          final order = c.order;

          if (order == null) {
            return const Center(child: Text("No Data"));
          }

          c.Getcolorandstause(order.status);

          // 2. تجميع أقسام الصفحة في قائمة Widgets
          final List<Widget> orderSections = [
            // ORDER STATUS
            orderStatusSection(
              order,
              c.statusColor ?? Colors.black,
              c.statusText ?? order.status,
            ),

            // PAYMENT
            paymentSection(
              context: context,
              order: order,
              controller: c,
              width: w,
            ),

            // ITEMS
            sectionCard(
              context,
              title: "product".tr,
              icon: Icons.shopping_bag_outlined,
              child: itemsSection(order),
            ),

            // DELIVERY DETAILS
            sectionCard(
              context,
              title: "Delivery Details",
              icon: Icons.location_on_outlined,
              child: deliveryDetails(order),
            ),

            // ORDER SUMMARY
            sectionCard(
              context,
              title: "Order Summary".tr,
              icon: Icons.receipt_long_outlined,
              child: orderSummary(order),
            ),
          ];

          // 3. عرض الأقسام بالترتيب مع حساب وقت التأخير تلقائياً
          return ListView.separated(
            padding: EdgeInsets.fromLTRB(w * 0.04, 10, w * 0.04, 30),
            itemCount: orderSections.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              return FadeInUp(
                // فرق 100 ملي ثانية بين كل قسم والتاني
                delay: Duration(milliseconds: index * 100),
                duration: const Duration(milliseconds: 450),
                child: orderSections[index],
              );
            },
          );
        },
      ),
    );
  }
}