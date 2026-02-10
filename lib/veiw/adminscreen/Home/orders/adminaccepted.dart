import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hos/controler/admincontroller/order/acceptedorder.dart';
import 'package:hos/core/class/handlingdataview.dart';
import 'package:hos/core/conistant/appcolor.dart';
import 'package:jiffy/jiffy.dart';

class Adminaccepted extends StatelessWidget {
  Adminaccepted({super.key});
  final Acceptedordercontroller controller = Get.put(Acceptedordercontroller());
  @override
  Widget build(BuildContext context) {
    return GetBuilder<Acceptedordercontroller>(
      builder: (controller) => Handlingdataview(
        statusrequest: controller.statusrequest,
        widget: RefreshIndicator(
          onRefresh: () async => await controller.viewordersaccepted(),
          child: ListView.separated(
            padding: const EdgeInsets.all(12),
            itemCount: controller.ordersaccepted.length,
            separatorBuilder: (_, _) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final order = controller.ordersaccepted[index];
              controller.Getcolorandstause(order.ordersStatus!);
              final status = controller.statusText;
              final color = controller.statusColor;
              final payment = controller.translatePayment(
                order.ordersPaymentmethod.toString(),
              );

              return InkWell(
                onTap: () {
                  controller.gotodetails(order);
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
                      backgroundColor: Appcolor.primaryColor.withAlpha(26),
                      radius: 28,
                      child: Icon(
                        Icons.shopping_bag,
                        color: Appcolor.primaryColor,
                        size: 28,
                      ),
                    ),
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                            fontSize: 12,
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
                              Text("total: ${order.ordersPrice} ج.م"),
                              Text("طريقة الدفع: $payment"),
                              Text(
                                "الحاله: $status",
                                style: TextStyle(
                                  color: color,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 5),
                            ],
                          ),
                          order.ordersStatus == '1'
                              ? MaterialButton(
                                  color: Colors.greenAccent,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  onPressed: () {
                                    controller.orderdone(
                                      order.ordersId!,
                                      order.ordersUsersid!,
                                    );
                                  },
                                  child: Text(
                                    'prepared',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                )
                              : SizedBox.shrink(),
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
    );
  }
}
