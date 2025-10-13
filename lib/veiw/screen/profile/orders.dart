import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hos/controler/profile/ordercontroller.dart';
import 'package:hos/core/class/handlingdataview.dart';
import 'package:hos/core/conistant/appcolor.dart';

class Orders extends StatelessWidget {
  const Orders({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(Ordercontroller());

    return Scaffold(
      appBar: AppBar(title: const Text("My Orders")),
      body: GetBuilder<Ordercontroller>(
        builder: (controller) => Handlingdataview(
          statusrequest: controller.statusrequest,
          widget: RefreshIndicator(
            onRefresh: () async => await controller.viewmyorders(),
            child: ListView.separated(
              padding: const EdgeInsets.all(12),
              itemCount: controller.orders.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final order = controller.orders[index];
                final color = controller.getStatusColor(
                  order.ordersStatus.toString(),
                );
                final payment = controller.translatePayment(
                  order.ordersPaymentMethod.toString(),
                );
                final status = controller.translateStatus(
                  order.ordersStatus.toString(),
                );

                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 16,
                    ),
                    leading: CircleAvatar(
                      backgroundColor: Appcolor.primaryColor.withOpacity(0.1),
                      radius: 28,
                      child: Icon(
                        Icons.shopping_bag,
                        color: Appcolor.primaryColor,
                        size: 28,
                      ),
                    ),
                    title: Text(
                      "طلب رقم #${order.ordersId}",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("المجموع: ${order.ordersPrice} ج.م"),
                          Text("طريقة الدفع: $payment"),
                          Text(
                            "الحالة: $status",
                            style: TextStyle(
                              color: color,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            "التاريخ: ${order.ordersDatetime}",
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    trailing: IconButton(
                      icon: const Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.grey,
                        size: 18,
                      ),
                      onPressed: () {
                        // لاحقًا نضيف صفحة تفاصيل الطلب
                        Get.snackbar(
                          "قريبًا",
                          "سيتم عرض تفاصيل الطلب",
                          backgroundColor: Colors.black.withOpacity(0.7),
                          colorText: Colors.white,
                          snackPosition: SnackPosition.BOTTOM,
                        );
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
