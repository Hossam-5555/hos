import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:hos/controler/usercontroller/profile/order/ordercontroller.dart';
import 'package:hos/core/class/handlingdataview.dart';
import 'package:hos/core/conistant/imageasset.dart';
import 'package:hos/veiw/userscreen/screen/profile/order/orderdetailes.dart';
import 'package:hos/veiw/wedget/appbarbackicon.dart';
import 'package:hos/veiw/wedget/items/itemslist.dart';
import 'package:hos/veiw/wedget/order/ordercard.dart';

class Orders extends StatelessWidget {
  Orders({super.key});

  final Ordercontroller controller = Get.put(Ordercontroller());

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;

    // نقاط توقف بسيطة: هاتف صغير / هاتف عادي / تابلت
    final bool isTablet = w >= 600;

    // مسافات متجاوبة اعتماداً على العرض (أثبت من الطول بين الأجهزة)
    // مع حدود دنيا وقصوى عشان ماتبقاش صغيرة أوي أو كبيرة أوي
    final double horizontalPadding = (w * 0.045).clamp(12.0, 32.0);

    // عدد أعمدة الجريد: 2 للهاتف، 3 للتابلت الصغير، 4 للتابلت الكبير
    final int gridCrossAxisCount = isTablet ? (w >= 900 ? 4 : 3) : 2;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(h * 0.08),
        child: Appbarbackicon(herotag: '', title: "Orders".tr),
      ),
      body: GetBuilder<Ordercontroller>(
        builder: (controller) => RefreshIndicator(
          onRefresh: () async => await controller.viewmyorders(),
          child: Column(
            children: [
              GetBuilder<Ordercontroller>(
                builder: (c) => ChipsBar(
                  labels: c.orderstatus,
                  selectedIndex: c.selectedStatus,
                  onSelected: c.changeSelectedStatus,
                ),
              ),
              Expanded(
                child: HandlingDataView(
                  emptyStyle: EmptyStateStyle.style2,
                  statusrequest: controller.statusrequest,
                  mediaType: HandlingMediaType.svgImage,
                  mode: HandlingMode.fullScreen,
                  showRetryButton: true,
                  onRetry: controller.viewmyorders,
                  widget: MasonryGridView.builder(
                    controller: controller.scrollController,
                    padding: EdgeInsets.all(horizontalPadding),
                    gridDelegate:
                        SliverSimpleGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: gridCrossAxisCount,
                        ),
                    mainAxisSpacing: w * 0.025,
                    crossAxisSpacing: w * 0.025,
                    itemCount: controller.orders.length,
                    itemBuilder: (context, index) {
                      final order = controller.orders[index];
                      controller.getcolorandstause(order.status);
                      final color = controller.statusColor;
                      final status = order.status;

                      return OrderCard(
                        w: w,
                        order: order,
                        status: status,
                        color: color!,
                        orderimage: orderimage,
                        onTap: () {
                          Get.to(Orderdetailes(), arguments: {"order": order});
                        },
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
