import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hos/controler/usercontroller/profile/order/ordercontroller.dart';
import 'package:hos/core/class/handlingdataview.dart';
import 'package:hos/core/conistant/appcolor.dart';
import 'package:hos/veiw/userscreen/screen/profile/order/orderdetailes.dart';
import 'package:hos/veiw/wedget/appbarbackicon.dart';
import 'package:jiffy/jiffy.dart';

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

                return GestureDetector(
                  onTap: () {
                    Get.to(Orderdetailes(), arguments: {"order": order});
                  },

                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: h * 0.01),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(w * 0.04),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha(13), // 0.05 * 255 = 13
                          blurRadius: 6,
                          offset: Offset(0, 3),
                        ),
                        BoxShadow(
                          color: Colors.black.withAlpha(13), // 0.05 * 255 = 13
                          blurRadius: 6,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),

                    child: ListTile(
                      contentPadding: EdgeInsets.symmetric(
                        vertical: h * 0.008,
                        horizontal: w * 0.04,
                      ),

                      title: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CircleAvatar(
                                radius: w * 0.05,
                                backgroundColor: Appcolor.primaryColor
                                    .withAlpha(35),
                                child: Icon(
                                  Icons.shopping_bag,
                                  size: w * 0.05,
                                  color: Appcolor.primaryColor,
                                ),
                              ),
                              Text(
                                Jiffy.parse(
                                  order.createdAt,
                                  pattern: 'yyyy-MM-dd hh:mm a',
                                ).fromNow(),
                                style: TextStyle(
                                  color: Colors.green,
                                  fontSize: w * 0.035,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),

                      subtitle: Padding(
                        padding: EdgeInsets.only(top: h * 0.01),

                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,

                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${'Order numper'.tr}#${order.orderNumber}",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: w * 0.04,
                                  ),
                                ),
                                Text.rich(
                                  TextSpan(
                                    children: [
                                      TextSpan(text: 'Total price'.tr),
                                      TextSpan(
                                        text: ":${order.totalAmount}\$",
                                        style: TextStyle(color: Colors.green),
                                      ),
                                    ],
                                  ),
                                ),
                                Text.rich(
                                  TextSpan(
                                    children: [
                                      TextSpan(text: 'Payment'.tr),
                                      TextSpan(
                                        text: ":${order.paymentMethod}",
                                        style: TextStyle(
                                          color: const Color.fromARGB(
                                            255,
                                            74,
                                            158,
                                            25,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Text.rich(
                                  TextSpan(
                                    children: [
                                      TextSpan(text: 'Payment'.tr),
                                      TextSpan(
                                        text: ":${order.paymentStatus}",
                                        style: TextStyle(
                                          color: const Color.fromARGB(
                                            255,
                                            74,
                                            158,
                                            25,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "${'Status'.tr}: $status",
                                      style: TextStyle(
                                        color: color,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    SizedBox(width: w / 4),
                                  ],
                                ),
                              ],
                            ),

                            // زر الحذف

                            // زر التقييم
                            // : order.status == "4" &&
                            //       order == '0'
                            // ? TextButton(
                            //     child: Text(
                            //       "rating",
                            //       style: TextStyle(fontSize: w * 0.030),
                            //     ),
                            //     onPressed: () {
                            //       showDialog(
                            //         context: context,
                            //         builder: (context) {
                            //           return AlertDialog(
                            //             title: Text("Rating"),
                            //             content: Column(
                            //               mainAxisSize: MainAxisSize.min,
                            //               children: [
                            //                 GetBuilder<Ordercontroller>(
                            //                   builder: (controller) {
                            //                     return Row(
                            //                       mainAxisAlignment:
                            //                           MainAxisAlignment
                            //                               .center,
                            //                       children: List.generate(5, (
                            //                         i,
                            //                       ) {
                            //                         int s = i + 1;
                            //                         return IconButton(
                            //                           onPressed: () =>
                            //                               controller
                            //                                   .changeRatingColor(
                            //                                     i,
                            //                                   ),
                            //                           icon: Icon(
                            //                             Icons.star,
                            //                             size: w * 0.08,
                            //                             color:
                            //                                 s <=
                            //                                     controller
                            //                                         .selectedRating
                            //                                 ? Colors.amber
                            //                                 : Colors.grey,
                            //                           ),
                            //                         );
                            //                       }),
                            //                     );
                            //                   },
                            //                 ),
                            //                 SizedBox(height: 20),
                            //                 SizedBox(
                            //                   height: h * 0.12,
                            //                   width: w * 0.6,
                            //                   child: Textfealdauth(
                            //                     suffixIcon: Icons.comment,
                            //                     hint: "comment",
                            //                     textEditingController:
                            //                         controller.comment!,
                            //                     valid: (x) => null,
                            //                   ),
                            //                 ),
                            //               ],
                            //             ),
                            //             actions: [
                            //               TextButton(
                            //                 onPressed: () =>
                            //                     controller.viewrating(
                            //                       order.ordersId!,
                            //                       controller.selectedRating
                            //                           .toString(),
                            //                     ),
                            //                 child: Text("Submit"),
                            //               ),
                            //               TextButton(
                            //                 onPressed: () => Get.back(),
                            //                 child: Text("Cancel"),
                            //               ),
                            //             ],
                            //           );
                            //         },
                            //       );
                            //     },
                            //   )
                            // // عرض التقييم
                            // :
                            Text(
                              order.status == "4" ? "4 ⭐" : "",
                              style: TextStyle(fontSize: w * 0.04),
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
