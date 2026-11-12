import 'package:animate_do/animate_do.dart'; // 1. استدعاء مكتبة الأنيميشن
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:hos/controler/admincontroller/order/pindingcontroller.dart';
import 'package:hos/core/class/handlingdataview.dart';
import 'package:hos/core/conistant/imageasset.dart';
import 'package:hos/veiw/wedget/items/itemslist.dart';
import 'package:hos/veiw/wedget/order/ordercard.dart';

class Adminpending extends StatelessWidget {
  const Adminpending({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(AdminPindingController());

    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = constraints.maxWidth;
        final screenHeight = constraints.maxHeight;

        // 2. نقاط توقف متوافقة مع الهواتف والتابلت الصغير والكبير
        final bool isTablet = screenWidth >= 600;
        final int crossAxisCount = isTablet ? (screenWidth >= 900 ? 4 : 3) : 2;

        // 3. مسافات متجاوبة بحدود دنيا وقصوى آمنة
        final double gridPadding = (screenWidth * 0.035).clamp(12.0, 28.0);
        final double gridSpacing = (screenWidth * 0.025).clamp(8.0, 18.0);
        final double topSpacing = (screenHeight * 0.008).clamp(4.0, 12.0);

        return GetBuilder<AdminPindingController>(
          builder: (controller) => RefreshIndicator(
            onRefresh: () async => await controller.viewOrders(
              controller.statusKeys[controller.selectedStatus],
            ),
            child: Column(
              children: [
                /// 🗂️ 1. أقسام حالات الطلبات (Status Tabs)
                ChipsBar(
                  labels: controller.orderstatus,
                  selectedIndex: controller.selectedStatus,
                  onSelected: controller.changeSelectedStatus,
                ),

                SizedBox(height: topSpacing),

                /// 📦 2. قائمة عرض الطلبات (Grid) متجاوبة + أنيميشن متسلسل
                Expanded(
                  child: HandlingDataView(
                    emptyStyle: EmptyStateStyle.style2,
                    mediaType: HandlingMediaType.animation,
                    message: "لا توجد طلبات حالياً",
                    imagePath: Imageasset.nodata,
                    statusrequest: controller.statusrequest,
                    widget: MasonryGridView.builder(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: EdgeInsets.fromLTRB(
                        gridPadding,
                        topSpacing,
                        gridPadding,
                        (screenHeight * 0.1).clamp(70.0, 110.0), // مساحة سفلية مريحة للسكرول
                      ),
                      gridDelegate:
                          SliverSimpleGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                      ),
                      mainAxisSpacing: gridSpacing,
                      crossAxisSpacing: gridSpacing,
                      itemCount: controller.orderspending.length,
                      itemBuilder: (context, index) {
                        final order = controller.orderspending[index];

                        controller.getcolorandstause(order.status);
                        final statuscolor =
                            controller.statusColor ?? Colors.grey;

                        // 4. تغليف الكارت بـ FadeInUp مع حماية التحديثات
                        return FadeInUp(
                          key: ValueKey(order.orderId ),
                          delay: Duration(milliseconds: (index % 10) * 50),
                          duration: const Duration(milliseconds: 450),
                          child: OrderCard(
                            orderimage: orderimage,
                            order: order,
                            status: order.status,
                            color: statuscolor,
                            w: screenWidth,
                            onTap: () => controller.gotodetails(order),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}