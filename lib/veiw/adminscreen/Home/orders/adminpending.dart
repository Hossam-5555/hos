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
    // حقن الكنترولر للتأكد من توفره في الذاكرة
    Get.put(AdminPindingController());
    
    // استخدام LayoutBuilder و MediaQuery لتكييف التصميم بسلاسة مع كافة الشاشات
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = constraints.maxWidth;
        final screenHeight = constraints.maxHeight;
        // حساب عدد الأعمدة الديناميكي بناءً على عرض الشاشة (مثلاً تابلت أو موبايل)
        final crossAxisCount = screenWidth > 600 ? 3 : 2;
        
        return GetBuilder<AdminPindingController>(
          builder: (controller) => RefreshIndicator(
            onRefresh: () async => await controller.viewOrders(
              controller.statusKeys[controller.selectedStatus],
            ),
            child: Column(
              children: [
                /// 🗂️ 1. أقسام حالات الطلبات (Status Tabs)
                Container(
                  height: screenHeight*0.07,
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    controller: controller.scrollController,
                    itemCount: controller.orderstatus.length,
                    itemBuilder: (context, index) {
                      final isSelected = controller.selectedStatus == index;
                      return InkWell(
                        onTap: () {
                          controller.changeSelectedStatus(index);
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                          padding: EdgeInsets.symmetric(
                            horizontal: screenWidth * 0.05,
                          ),
                          margin: const EdgeInsets.only(left: 10),
                          decoration: BoxDecoration(
                            gradient: isSelected
                                ? const LinearGradient(
                                    colors: [
                                      Colors.blueAccent,
                                      Colors.lightBlueAccent,
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  )
                                : null,
                            color: isSelected
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
                              color: isSelected
                                  ? Colors.white
                                  : (Get.isDarkMode
                                      ? Colors.white70
                                      : Colors.black54),
                              fontWeight: FontWeight.bold,
                              fontSize: screenWidth > 600 ? 16 : 14,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                /// 📦 2. قائمة عرض الطلبات (Grid) متجاوبة
                Expanded(
                  child: HandlingDataView(
                    emptyStyle: EmptyStateStyle.style2,
                    mediaType: HandlingMediaType.animation,
                    message: "لا توجد طلبات حالياً",
                    imagePath: Imageasset.nodata,
                    statusrequest: controller.statusrequest,
                    widget: MasonryGridView.builder(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: EdgeInsets.all(screenWidth * 0.03),
                      gridDelegate:
                          SliverSimpleGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                      ),
                      mainAxisSpacing: screenWidth * 0.025,
                      crossAxisSpacing: screenWidth * 0.025,
                      itemCount: controller.orderspending.length,
                      itemBuilder: (context, index) {
                        final order = controller.orderspending[index];

                        controller.getcolorandstause(order.status);
                        final statuscolor = controller.statusColor ?? Colors.grey;

                        return OrderCard(
                          orderimage: orderimage,
                          order: order,
                          status: order.status,
                          color: statuscolor,
                          w: screenWidth,
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
      },
    );
  }
}