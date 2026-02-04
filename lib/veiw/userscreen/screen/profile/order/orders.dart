import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hos/controler/usercontroller/profile/order/ordercontroller.dart';
import 'package:hos/core/class/handlingdataview.dart';
import 'package:hos/core/conistant/appcolor.dart';
import 'package:hos/veiw/userscreen/screen/profile/order/orderdetailes.dart';
import 'package:hos/veiw/wedget/appbarbackicon.dart';
import 'package:hos/veiw/wedget/auth/Textfealdauth.dart';
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
                controller.Getcolorandstause(order.ordersStatus!);
                final color = controller.statusColor;
                final payment = controller.translatePayment(
                  order.ordersPaymentmethod.toString(),
                );
                final status = controller.statusText;

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
                      ],
                    ),

                    child: ListTile(
                      contentPadding: EdgeInsets.symmetric(
                        vertical: h * 0.008,
                        horizontal: w * 0.04,
                      ),

                      leading: CircleAvatar(
                        radius: w * 0.09,
                        backgroundColor: Appcolor.primaryColor.withAlpha(35),
                        child: Icon(
                          Icons.shopping_bag,
                          size: w * 0.08,
                          color: Appcolor.primaryColor,
                        ),
                      ),

                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Text(
                              "طلب رقم #${order.ordersId}",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: w * 0.04,
                              ),
                            ),
                          ),

                          Text(
                            Jiffy.parse(
                              order.ordersDatetime.toString(),
                            ).fromNow(),
                            style: TextStyle(
                              color: Colors.green,
                              fontSize: w * 0.035,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),

                      subtitle: Padding(
                        padding: EdgeInsets.only(top: h * 0.01),

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
                                SizedBox(height: h * 0.006),
                              ],
                            ),

                            // زر الحذف
                            order.ordersStatus == "0"
                                ? IconButton(
                                    icon: Icon(
                                      Icons.delete_outline_outlined,
                                      size: w * 0.07,
                                      color: Colors.grey,
                                    ),
                                    onPressed: () => controller.deleteorders(
                                      order.ordersId!,
                                    ),
                                  )
                                // زر التقييم
                                : order.ordersStatus == "4" &&
                                      order.rating == '0'
                                ? TextButton(
                                    child: Text(
                                      "rating",
                                      style: TextStyle(fontSize: w * 0.030),
                                    ),
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            title: Text("Rating"),
                                            content: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                GetBuilder<Ordercontroller>(
                                                  builder: (controller) {
                                                    return Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: List.generate(5, (
                                                        i,
                                                      ) {
                                                        int s = i + 1;
                                                        return IconButton(
                                                          onPressed: () =>
                                                              controller
                                                                  .changeRatingColor(
                                                                    i,
                                                                  ),
                                                          icon: Icon(
                                                            Icons.star,
                                                            size: w * 0.08,
                                                            color:
                                                                s <=
                                                                    controller
                                                                        .selectedRating
                                                                ? Colors.amber
                                                                : Colors.grey,
                                                          ),
                                                        );
                                                      }),
                                                    );
                                                  },
                                                ),

                                                SizedBox(height: 20),

                                                SizedBox(
                                                  height: h * 0.12,
                                                  width: w * 0.6,
                                                  child: Textfealdauth(
                                                    suffixIcon: Icons.comment,
                                                    hint: "comment",
                                                    textEditingController:
                                                        controller.comment!,
                                                    valid: (x) => null,
                                                  ),
                                                ),
                                              ],
                                            ),

                                            actions: [
                                              TextButton(
                                                onPressed: () =>
                                                    controller.viewrating(
                                                      order.ordersId!,
                                                      controller.selectedRating
                                                          .toString(),
                                                    ),
                                                child: Text("Submit"),
                                              ),

                                              TextButton(
                                                onPressed: () => Get.back(),
                                                child: Text("Cancel"),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                  )
                                // عرض التقييم
                                : Text(
                                    order.ordersStatus == "4"
                                        ? "${order.rating} ⭐"
                                        : "",
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
