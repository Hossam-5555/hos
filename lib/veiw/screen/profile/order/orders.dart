import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hos/controler/profile/order/ordercontroller.dart';
import 'package:hos/core/class/handlingdataview.dart';
import 'package:hos/core/conistant/appcolor.dart';
import 'package:hos/veiw/screen/profile/order/orderdetailes.dart';
import 'package:hos/veiw/wedget/auth/Textfealdauth.dart';
import 'package:jiffy/jiffy.dart';

class Orders extends StatelessWidget {
  const Orders({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(Ordercontroller());

    return Scaffold(
      appBar: AppBar(
        title: const Text("My Orders"),
        leading: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Container(
            width: 48, // الخطوة 3: تحديد حجم قياسي (لمسة مريحة للمستخدم)
            height: 48,
            padding: EdgeInsets.only(left: 4),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                // إضافة ظل خفيف ليعطي عمقاً
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: IconButton(
              onPressed: () {
                Get.back();
              },
              icon: Icon(Icons.arrow_back_ios),
              iconSize: 24, // الخطوة 4: تحديد حجم قياسي للأيقونة
              splashRadius: 24, // لجعل تأثير الضغط لا يخرج عن الدائرة
            ),
          ),
        ),
      ),
      body: GetBuilder<Ordercontroller>(
        builder: (controller) => Handlingdataview(
          statusrequest: controller.statusrequest,
          widget: RefreshIndicator(
            onRefresh: () async => await controller.viewmyorders(),
            child: ListView.separated(
              padding: const EdgeInsets.all(12),
              itemCount: controller.orders.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final order = controller.orders[index];
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
                      () => Orderdetailes(),
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
                            order.ordersStatus == "0"
                                ? IconButton(
                                    icon: const Icon(
                                      Icons.delete_outline_outlined,
                                      color: Colors.grey,
                                      size: 25,
                                    ),
                                    onPressed: () {
                                      controller.deleteorders(order.ordersId!);
                                    },
                                  )
                                : order.ordersStatus == "3" &&
                                      order.rating == '0'
                                ? TextButton(
                                    child: Text("rating"),
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            actionsAlignment:
                                                MainAxisAlignment.center,
                                            title: Text("rating"),
                                            content: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                GetBuilder<Ordercontroller>(
                                                  builder: (controller) {
                                                    return Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        ...List.generate(5, (
                                                          index,
                                                        ) {
                                                          int starIndex =
                                                              index + 1;
                                                          return IconButton(
                                                            onPressed: () {
                                                              controller
                                                                  .changeRatingColor(
                                                                    index,
                                                                  );
                                                            },
                                                            icon: Icon(
                                                              Icons.star,
                                                              color:
                                                                  starIndex <=
                                                                      controller
                                                                          .selectedRating
                                                                  ? Colors.amber
                                                                  : Colors.grey,
                                                              size: 35,
                                                            ),
                                                          );
                                                        }),
                                                      ],
                                                    );
                                                  },
                                                ),
                                                Container(
                                                  margin: EdgeInsets.only(
                                                    top: 40,
                                                  ),
                                                  height: 100,
                                                  width: 250,
                                                  child: Textfealdauth(
                                                    label: 'comment',
                                                    suffixIcon: Icons.comment,
                                                    hint: "comment",
                                                    textEditingController:
                                                        controller.comment!,
                                                    valid: (p0) {
                                                      return null;
                                                    },
                                                  ),
                                                ),
                                              ],
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  controller.viewrating(
                                                    order.ordersId!,
                                                    controller.selectedRating
                                                        .toString(),
                                                    controller.comment
                                                        .toString(),
                                                  );
                                                },
                                                child: Text("submet"),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  Get.back();
                                                },
                                                child: Text("cancel"),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                  )
                                : Text("${order.rating}" + "⭐"),
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
