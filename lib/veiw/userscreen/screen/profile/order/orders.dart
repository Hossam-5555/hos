import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hos/controler/usercontroller/profile/order/ordercontroller.dart';
import 'package:hos/core/class/handlingdataview.dart';
import 'package:hos/core/conistant/imageasset.dart';
import 'package:hos/veiw/userscreen/screen/profile/order/orderdetailes.dart';
import 'package:hos/veiw/wedget/appbarbackicon.dart';
import 'package:hos/veiw/wedget/order/ordercard.dart';

class Orders extends StatelessWidget {
  Orders({super.key});

  final Ordercontroller controller = Get.put(Ordercontroller());
  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(h * 0.08),
        child: Appbarbackicon(herotag: '', title: "My Orders"),
      ),

      body: GetBuilder<Ordercontroller>(
        builder: (controller) => Handlingdataview(
          statusrequest: controller.statusrequest,

          widget: RefreshIndicator(
            onRefresh: () async => await controller.viewmyorders(),

            child: ListView.separated(
              padding: EdgeInsets.all(w * 0.04),
              itemCount: controller.orders.length,
              separatorBuilder: (_, _) => SizedBox(height: h * 0.015),

              itemBuilder: (context, index) {
                final order = controller.orders[index];
                controller.Getcolorandstause(order.status);
                final color = controller.statusColor;
                final status = order.status;

                return OrderCard(
                  h: h,
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
      ),
    );
  }
}
