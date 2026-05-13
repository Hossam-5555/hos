import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:hos/core/conistant/appcolor.dart';
import 'package:jiffy/jiffy.dart';

// ignore: must_be_immutable
class OrderCard extends StatelessWidget {
  OrderCard({
    super.key,
    this.onTap,
    required this.h,
    required this.w,
    required this.order,
    required this.status,
    required this.color,
  });
  void Function()? onTap;
  double w;
  double h;
  final order;
  final String status;
  final Color color;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: h * 0.01),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: AlignmentGeometry.topCenter,
            end: AlignmentGeometry.topCenter,
            transform: GradientRotation(-0.5),
            colors: [color.withAlpha(20), Colors.white.withAlpha(200)],
          ),
          borderRadius: BorderRadius.all(Radius.circular(25)),
          border: Border.all(
            color: Colors.grey.withAlpha(50),
            strokeAlign: BorderSide.strokeAlignCenter,
          ),
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
                    backgroundColor: Appcolor.primaryColor.withAlpha(35),
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
                      color: Colors.black,
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(text: 'paymentMethod'),
                              TextSpan(
                                text: ":${order.paymentMethod}",
                                style: TextStyle(
                                  color: const Color.fromARGB(255, 74, 158, 25),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: w / 6),
                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(text: 'Payment'.tr),
                              TextSpan(
                                text: ":${order.paymentStatus}",
                                style: TextStyle(
                                  color: const Color.fromARGB(255, 74, 158, 25),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "${'Status'.tr}: $status",
                          style: TextStyle(
                            color: color,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(width: w / 4),
                        Text(
                          order.status == "delivered"
                              ? "4 ⭐(1k) reviews"
                              : "",
                        ),
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
