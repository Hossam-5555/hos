import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:hos/controler/usercontroller/profile/order/ordercontroller.dart';
import 'package:hos/controler/usercontroller/profile/order/orderdetailescontroller.dart';
import 'package:hos/data/model/ordersmodel.dart';
import 'package:hos/veiw/wedget/appbarbackicon.dart';
import 'package:hos/veiw/wedget/auth/checkbutton.dart';
import 'package:hos/veiw/wedget/pricecard.dart';

class Orderdetailes extends StatelessWidget {
  const Orderdetailes({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.put(Orderdetailescontroller());
    Get.find<Ordercontroller>();

    final w = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,

      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: Appbarbackicon(herotag: '', title: c.order?.orderNumber ?? ''),
      ),

      body: GetBuilder<Orderdetailescontroller>(
        builder: (_) {
          final order = c.order;

          if (order == null) {
            return const Center(child: Text("No Data"));
          }

          c.Getcolorandstause(order.status);

          return ListView(
            padding: EdgeInsets.fromLTRB(w * 0.04, 10, w * 0.04, 30),
            children: [
              // ============================================================
              // ORDER STATUS
              // ============================================================
              orderStatusSection(
                order,
                c.statusColor ?? Colors.black,
                c.statusText ?? order.status,
              ),

              const SizedBox(height: 12),

              // ============================================================
              // PAYMENT
              // ============================================================
              paymentSection(
                context: context,
                order: order,
                controller: c,
                width: w,
              ),

              const SizedBox(height: 12),

              // ============================================================
              // ITEMS
              // ============================================================
              sectionCard(
                context,
                title: "Items",
                icon: Icons.shopping_bag_outlined,
                child: itemsSection(order),
              ),

              const SizedBox(height: 12),

              // ============================================================
              // DELIVERY DETAILS
              // ============================================================
              sectionCard(
                context,
                title: "Delivery Details",
                icon: Icons.location_on_outlined,
                child: deliveryDetails(order),
              ),

              const SizedBox(height: 12),

              // ============================================================
              // ORDER SUMMARY
              // ============================================================
              sectionCard(
                context,
                title: "Order Summary",
                icon: Icons.receipt_long_outlined,
                child: orderSummary(order),
              ),

              const SizedBox(height: 20),

              // ============================================================
              // CANCEL ORDER
              // ============================================================
              if (order.status.toLowerCase() == "pending")
                GetBuilder<Ordercontroller>(
                  builder: (controller) {
                    return Checkbutton(
                      statusrequest: controller.statusrequest,
                      buttonColor: Colors.black,
                      width: w,
                      onTap: () {
                        controller.deleteorders(order.orderId);
                      },
                      buttonName: "Cancel Order",
                    );
                  },
                ),
            ],
          );
        },
      ),
    );
  }
}

// ============================================================================
// SECTION CARD
// ============================================================================

Widget sectionCard(
  BuildContext context, {
  required String title,
  required IconData icon,
  required Widget child,
}) {
  return Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Theme.of(context).cardColor,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: Colors.grey.withAlpha(40)),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 21),

            const SizedBox(width: 9),

            Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),

        const SizedBox(height: 15),

        child,
      ],
    ),
  );
}

// ============================================================================
// ORDER STATUS
// ============================================================================

Widget orderStatusSection(
  OrderModel order,
  Color currentColor,
  String statusText,
) {
  final steps = [
    {
      "icon": Icons.receipt_long,
      "label": "Pending",
      "status": "pending",
      "color": Colors.orange,
    },
    {
      "icon": Icons.inventory_2_outlined,
      "label": "Processing",
      "status": "processing",
      "color": Colors.blue,
    },
    {
      "icon": Icons.local_shipping_outlined,
      "label": "Shipped",
      "status": "shipped",
      "color": const Color.fromARGB(255, 179, 123, 39),
    },
    {
      "icon": Icons.check_circle_outline,
      "label": "Delivered",
      "status": "delivered",
      "color": const Color.fromARGB(255, 33, 201, 10),
    },
  ];

  final statuses = ["pending", "processing", "shipped", "delivered"];

  final current = statuses.indexOf(order.status.toLowerCase());

  return Builder(
    builder: (context) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey.withAlpha(40)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.info_outline, size: 21),

                    const SizedBox(width: 9),

                    const Text(
                      "Order Status",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: currentColor.withAlpha(25),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    statusText,
                    style: TextStyle(
                      color: currentColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            Row(
              children: List.generate(steps.length, (i) {
                final active = current >= 0 && i <= current;
                final last = i == steps.length - 1;

                final color = steps[i]["color"] as Color;

                return Expanded(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: 2,
                              color: i == 0
                                  ? Colors.transparent
                                  : i <= current
                                  ? steps[i - 1]["color"] as Color
                                  : Colors.grey.shade300,
                            ),
                          ),

                          AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            width: 34,
                            height: 34,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: active ? color : Colors.grey.shade200,
                              boxShadow: active
                                  ? [
                                      BoxShadow(
                                        color: color.withAlpha(60),
                                        blurRadius: 8,
                                      ),
                                    ]
                                  : null,
                            ),
                            child: Icon(
                              active
                                  ? Icons.check
                                  : steps[i]["icon"] as IconData,
                              size: 16,
                              color: active ? Colors.white : Colors.grey,
                            ),
                          ),

                          Expanded(
                            child: Container(
                              height: 2,
                              color: last
                                  ? Colors.transparent
                                  : i < current
                                  ? color
                                  : Colors.grey.shade300,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 7),

                      Text(
                        steps[i]["label"].toString(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: active
                              ? FontWeight.bold
                              : FontWeight.normal,
                          color: active ? color : Colors.grey,
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ],
        ),
      );
    },
  );
}

// ============================================================================
// PAYMENT
// ============================================================================

Widget paymentSection({
  required BuildContext context,
  required OrderModel order,
  required Orderdetailescontroller controller,
  required double width,
}) {
  final paymentStatus = order.paymentStatus.toLowerCase();

  final isFailed = paymentStatus == "failed" || paymentStatus == "unpaid";

  final isPaid = paymentStatus == "paid";

  final isPending = paymentStatus == "pending";

  Color color;

  if (isPaid) {
    color = Colors.green;
  } else if (isFailed) {
    color = Colors.red;
  } else {
    color = Colors.orange;
  }

  return Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Theme.of(context).cardColor,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(
        color: isFailed ? Colors.red.withAlpha(50) : Colors.grey.withAlpha(40),
      ),
    ),
    child: Column(
      children: [
        Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: color.withAlpha(25),
                shape: BoxShape.circle,
              ),
              child: Icon(
                isPaid
                    ? Icons.check
                    : isFailed
                    ? Icons.error_outline
                    : Icons.payment,
                color: color,
              ),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Payment",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),

                  const SizedBox(height: 3),

                  Text(
                    isPaid
                        ? "Payment successful"
                        : isFailed
                        ? "Payment failed"
                        : isPending
                        ? "Payment is pending"
                        : "Payment not completed",
                    style: TextStyle(
                      color: color,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),

            Text(
              order.paymentMethod,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
            ),
          ],
        ),

        // Retry Payment
        if (isFailed &&
            (order.paymentMethod == "card" ||
                order.paymentMethod == "wallet")) ...[
          const SizedBox(height: 15),

          SizedBox(
            width: double.infinity,
            child: Checkbutton(
              statusrequest: controller.statusrequest,
              buttonColor: color,
              width: width,
              onTap: () {
                controller.paymentController.retryPayment(order.orderId);
              },
              buttonName: "Retry Payment",
            ),
          ),
        ],
      ],
    ),
  );
}

// ============================================================================
// ITEMS
// ============================================================================

Widget itemsSection(OrderModel order) {
  return Column(
    children: [
      ...order.items.map<Widget>((item) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xFFFFFFFF),
                      Color(0xFFF2F4F7),
                      Color(0xFFD0D5DD),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: CachedNetworkImage(
                  imageUrl: item.image.toString(),
                  fit: BoxFit.contain,
                  placeholder: (_, __) {
                    return const Center(
                      child: SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    );
                  },
                  errorWidget: (_, __, ___) {
                    return const Icon(Icons.image_not_supported_outlined);
                  },
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.productName ?? "",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),

                    const SizedBox(height: 7),

                    Text(
                      "Quantity: ${item.quantity}",
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 8),

             PriceText(item.price),
            ],
          ),
        );
      }),

      const Divider(),

      const SizedBox(height: 5),

      Align(
        alignment: Alignment.centerLeft,
        child: Text(
          "${order.items.length} Items",
          style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
        ),
      ),
    ],
  );
}

// ============================================================================
// DELIVERY DETAILS
// ============================================================================

Widget deliveryDetails(OrderModel order) {
  final address = order.shippingAddress;

  return Column(
    children: [
      detailRow(
        icon: Icons.person_outline,
        title: "Name",
        value: order.username,
      ),

      const SizedBox(height: 12),

      detailRow(
        icon: Icons.phone_outlined,
        title: "Phone",
        value: address.phone ?? "-",
      ),

      const SizedBox(height: 12),

      detailRow(
        icon: Icons.location_on_outlined,
        title: "Address",
        value: "${address.city ?? ""} - ${address.street ?? ""}",
      ),
    ],
  );
}

// ============================================================================
// DETAIL ROW
// ============================================================================

Widget detailRow({
  required IconData icon,
  required String title,
  required String value,
}) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: Colors.grey.withAlpha(20),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, size: 19),
      ),

      const SizedBox(width: 12),

      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(color: Colors.grey.shade600, fontSize: 11),
            ),

            const SizedBox(height: 3),

            Text(
              value,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                height: 1.3,
              ),
            ),
          ],
        ),
      ),
    ],
  );
}

// ============================================================================
// ORDER SUMMARY
// ============================================================================

Widget orderSummary(OrderModel order) {
  return Column(
    children: [
      summaryRow("Subtotal", order.subtotal),

      const SizedBox(height: 10),

      summaryRow("Shipping", order.shippingFee),

      const SizedBox(height: 10),

      summaryRow("Tax", order.taxAmount),

      const Padding(
        padding: EdgeInsets.symmetric(vertical: 12),
        child: Divider(),
      ),

      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            "Total",
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
          ),

          PriceText(order.totalAmount),
        ],
      ),
    ],
  );
}

// ============================================================================
// SUMMARY ROW
// ============================================================================

Widget summaryRow(String title, dynamic value) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(title, style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),

      PriceText(value),
    ],
  );
}
