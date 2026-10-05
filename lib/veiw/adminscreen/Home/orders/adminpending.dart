import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:hos/controler/admincontroller/order/pindingcontroller.dart';
import 'package:hos/core/class/handlingdataview.dart';
import 'package:hos/core/conistant/imageasset.dart';
import 'package:hos/veiw/wedget/order/ordercard.dart';

class Adminpending extends StatelessWidget {
  const Adminpending({super.key});

  @override
  Widget build(BuildContext context) {
    // حقن الكنترولر للتأكد من توفره في الذاكرة ومطابقة الاسم الصحيح للكلاس
    Get.put(AdminPindingController());
    final size = MediaQuery.of(context).size;

    return GetBuilder<AdminPindingController>(
      builder: (controller) => RefreshIndicator(
        // جلب وتحديث بيانات القسم الحالي المفتوح بدقة عند سحب الشاشة للأسفل
        onRefresh: () async => await controller.viewOrders(
          controller.statusKeys[controller.selectedStatus],
        ),
        child: Column(
          children: [
            /// 🗂️ 1. أقسام حالات الطلبات (Status Tabs)
            Container(
              height: 40,
              margin: const EdgeInsets.symmetric(vertical: 2),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                 controller: controller.scrollController,
                itemCount: controller.orderstatus.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      // تغيير الحالة وجلب بياناتها فوراً من الباك إند
                      controller.changeSelectedStatus(index);
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
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
                        color: controller.selectedStatus == index
                            ? null
                            : (Get.isDarkMode
                                  ? Colors.grey[800]
                                  : Colors.grey[200]),
                        borderRadius: BorderRadius.circular(40),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        controller.orderstatus[index],
                        style: TextStyle(
                          color: controller.selectedStatus == index
                              ? Colors.white
                              : (Get.isDarkMode
                                    ? Colors.white70
                                    : Colors.black54),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            /// 📦 2. قائمة عرض الطلبات المستلمة (Grid)
            Expanded(
              child: HandlingDataView(
                emptyStyle: EmptyStateStyle.style2,
                mediaType: HandlingMediaType.animation,
                message:
                    "لا توجد طلبات حالياً", // رسالة توضيحية عند عدم وجود بيانات
                imagePath:
                    Imageasset.nodata, // صورة توضيحية عند عدم وجود بيانات
                statusrequest: controller
                    .statusrequest, // يتكفل تلقائياً بالـ Loading، والـ No Data بناءً على استجابة السيرفر
                widget: MasonryGridView.builder(
                  physics:
                      const AlwaysScrollableScrollPhysics(), // لضمان بقاء الـ RefreshIndicator يعمل بكفاءة
                  padding: EdgeInsets.all(size.width * 0.03),
                  gridDelegate:
                      const SliverSimpleGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                      ),
                  mainAxisSpacing: size.width * 0.025,
                  crossAxisSpacing: size.width * 0.025,
                  itemCount: controller.orderspending.length,
                  itemBuilder: (context, index) {
                    final order = controller.orderspending[index];

                    // استخراج حالة التصميم والترجمة الخاصة بهذا الكارت بأسلوب آمن
                    controller.getcolorandstause(order.status);
                    final statuscolor = controller.statusColor ?? Colors.grey;

                    return OrderCard(
                      orderimage: orderimage,
                      order: order,
                      status: order.status,
                      color: statuscolor,
                      w: size.width,
                      onTap: () => controller.gotodetails(order),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}