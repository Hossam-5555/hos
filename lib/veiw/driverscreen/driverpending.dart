import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hos/controler/drivercontroller/drivercontroller.dart';
import 'package:hos/core/class/handlingdataview.dart';
import 'package:hos/core/conistant/appcolor.dart';
import 'package:hos/veiw/driverscreen/driver_orderdetails.dart';
import 'package:jiffy/jiffy.dart';

class Driverpending extends StatelessWidget {
  Driverpending({super.key});
  final driverviewordercontroller controller = Get.put(
    driverviewordercontroller(),
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<driverviewordercontroller>(
        builder: (controller) => Handlingdataview(
          statusrequest: controller.statusrequest,
          widget: RefreshIndicator(
            onRefresh: () async => await controller.vieworderspending(),
            child: ListView.separated(
              padding: const EdgeInsets.all(12),
              itemCount: controller.orderspending.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final order = controller.orderspending[index];
                final color = controller.getStatusColor(
                  order.ordersStatus.toString(),
                );
                final payment = controller.translatePayment(
                  order.ordersPaymentmethod.toString(),
                );
                final status = controller.translateStatus(
                  order.ordersStatus.toString(),
                );

                return InkWell(
                  onTap: () {
                    Get.to(
                      () => DriverOrderdetails(),
                      arguments: {"order": order},
                      transition: Transition.rightToLeft,
                    );
                  },
                  child: Container(
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
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "طلب رقم #${order.ordersId}",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                          Text(
                            "${Jiffy.parse(order.ordersDatetime.toString()).fromNow() // 25 years ago
                            }: التاريخ ",
                            style: const TextStyle(
                              color: Color.fromARGB(255, 54, 203, 17),
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
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
                              ],
                            ),

                            MaterialButton(
                              onPressed: () {
                                controller.approvependingorder(
                                  order.ordersUsersid!,
                                  order.ordersId!,
                                );
                              },
                              child: Icon(Icons.add_alarm),
                            ),
                          ],
                        ),
                      ),
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
