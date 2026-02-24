import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hos/controler/drivercontroller/driveracceptedcontroller.dart';
import 'package:hos/core/class/handlingdataview.dart';
import 'package:hos/core/conistant/appcolor.dart';
import 'package:hos/veiw/driverscreen/driver_orderdetails.dart';
import 'package:jiffy/jiffy.dart';

class Driveraccepted extends StatelessWidget {
  Driveraccepted({super.key});
  final Driveracceptedcontroller controller = Get.put(
    Driveracceptedcontroller(),
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<Driveracceptedcontroller>(
        builder: (controller) => Handlingdataview(
          statusrequest: controller.statusrequestaccepted,
          widget: RefreshIndicator(
            onRefresh: () async => await controller.viewordersaccepted(),
            child: ListView.separated(
              padding: const EdgeInsets.all(12),
              itemCount: controller.ordersaccepted.length,
              separatorBuilder: (_, _) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final order = controller.ordersaccepted[index];
                controller.Getcolorandstause(order.ordersStatus!);
                final color = controller.statusColor;

                final payment = controller.translatePayment(
                  order.ordersPaymentmethod.toString(),
                );
                final status = controller.statusText;
                return InkWell(
                  onTap: () {
                    Get.to(
                      DriverOrderdetails(),
                      arguments: {"order": order},
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha(13),
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
                        backgroundColor: Appcolor.primaryColor.withAlpha(30),
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
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            "${Jiffy.parse(order.ordersDatetime.toString()).fromNow() // 25 years ago
                            }: التاريخ ",
                            style: const TextStyle(
                              color: Color.fromARGB(255, 54, 203, 17),
                              fontSize: 14,
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
                                controller.orderdone(
                                  order.ordersId!,
                                  order.ordersUsersid!,
                                );
                              },
                              child: Icon(Icons.ac_unit),
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
