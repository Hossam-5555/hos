import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hos/controler/admincontroller/order/pindingcontroller.dart';
import 'package:hos/core/conistant/imageasset.dart';
import 'package:hos/veiw/wedget/animation.dart';
import 'package:hos/veiw/wedget/order/ordercard.dart';

class Adminpending extends StatelessWidget {
  const Adminpending({
    super.key,
  }); // أضفنا const وإزالة التعريف الخارجي للـ controller لضمان حقنه عبر GetBuilder

  @override
  Widget build(BuildContext context) {
    // يفضل استخدام Get.put داخل build أو في الـ Binding
    Get.put(AdminPindingController());
    final size = MediaQuery.of(context).size;

    return GetBuilder<AdminPindingController>(
      builder: (controller) => RefreshIndicator(
        onRefresh: () async => await controller.vieworderspending(),
        child: Column(
          children: [
            // --- قسم الأقسام (Status Tabs) ---
            Container(
              height: 40, // تحديد طول مناسب
              margin: const EdgeInsets.symmetric(vertical: 2),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: controller.orderstatus.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      // هنا نمرر رقم القسم المختار للكنترولر لفلترة البيانات
                      controller.changeSelectedStatus(index);
                    },
                    child: AnimatedContainer(
                      duration: const Duration(
                        milliseconds: 300,
                      ), // لإضافة تأثير انتقالي
                      curve: Curves.easeInOut,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      margin: const EdgeInsets.only(left: 10),
                      decoration: BoxDecoration(
                        gradient: controller.selectedStatus == index
                            ? const LinearGradient(
                                colors: [
                                  Colors.blueAccent,
                                  Colors.lightBlueAccent,
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              )
                            : null,

                        border: Border.all(
                          color: Colors.grey,
                        ), // إضافة حدود للتمييز
                        borderRadius: BorderRadius.circular(40),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        controller.orderstatus[index],
                        style: const TextStyle(
                          // color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            // --- قسم الطلبات ---
            Expanded(
              child: controller.filteredOrders.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Animationforstatus(animationPath: Imageasset.nodata),
                          Text("لا توجد طلبات حالياً"),
                        ],
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.all(12),
                      itemCount: controller.filteredOrders.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 10),
                      itemBuilder: (context, index) {
                        final order = controller.filteredOrders[index];

                        // جلب البيانات مباشرة دون تخزينها كمتغيرات عامة في الكنترولر لتجنب تداخل الألوان
                        controller.Getcolorandstause(order.status);
                        final statustext = controller.statusText;
                        final statuscolor = controller.statusColor;

                        return OrderCard(
                          order: order,
                          status: statustext!,
                          color: statuscolor!,
                          w: size.width,
                          h: size.height,
                          onTap: () => controller.gotodetails(order),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
