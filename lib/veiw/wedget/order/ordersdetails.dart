import 'dart:math' as math;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:hos/controler/usercontroller/profile/order/orderdetailescontroller.dart';
import 'package:hos/data/model/ordersmodel.dart';
import 'package:hos/veiw/wedget/auth/checkbutton.dart';
import 'package:hos/veiw/wedget/pricecard.dart';

// ============================================================================
// RESPONSIVE HELPER  (تقدر تنقله لملف لوحده: core/responsive.dart)
// ============================================================================

class Rsp {
  Rsp._(this.width);

  final double width;

  factory Rsp.of(BuildContext context) =>
      Rsp._(MediaQuery.sizeOf(context).width);

  bool get isTablet => width >= 600;
  bool get isDesktop => width >= 1024;

  /// التصميم الأصلي مبني على عرض 390.
  /// الـ clamp بيمنع الحجم يصغر أوي على الشاشات الصغيرة
  /// أو يكبر زيادة على التابلت.
  double get _k => (width / 390).clamp(0.85, 1.25);

  /// حجم متجاوب: يستخدم للـ padding والـ icons والـ fonts والـ radius
  double s(double value) => value * _k;
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
  final r = Rsp.of(context);

  return Container(
    padding: EdgeInsets.all(r.s(16)),
    decoration: BoxDecoration(
      color: Theme.of(context).cardColor,
      borderRadius: BorderRadius.circular(r.s(20)),
      border: Border.all(color: Colors.grey.withAlpha(40)),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: r.s(21)),
            SizedBox(width: r.s(9)),
            Expanded(
              child: Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: r.s(16),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: r.s(15)),
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
    {"icon": Icons.receipt_long, "status": "pending", "color": Colors.orange},
    {
      "icon": Icons.inventory_2_outlined,
      "status": "processing",
      "color": Colors.blue,
    },
    {
      "icon": Icons.local_shipping_outlined,
      "status": "shipped",
      "color": const Color.fromARGB(255, 179, 123, 39),
    },
    {
      "icon": Icons.check_circle_outline,
      "status": "delivered",
      "color": const Color.fromARGB(255, 33, 201, 10),
    },
  ];

  final statuses = ["pending", "processing", "shipped", "delivered"];

  final current = statuses.indexOf(order.status.toLowerCase());

  return Builder(
    builder: (context) {
      final r = Rsp.of(context);

      return Container(
        padding: EdgeInsets.all(r.s(16)),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(r.s(20)),
          border: Border.all(color: Colors.grey.withAlpha(40)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.info_outline, size: r.s(21)),
                SizedBox(width: r.s(9)),
                Expanded(
                  child: Text(
                    "Status".tr,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: r.s(16),
                    ),
                  ),
                ),
                SizedBox(width: r.s(8)),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: r.s(10),
                    vertical: r.s(6),
                  ),
                  decoration: BoxDecoration(
                    color: currentColor.withAlpha(25),
                    borderRadius: BorderRadius.circular(r.s(20)),
                  ),
                  child: Text(
                    statusText,
                    maxLines: 1,
                    style: TextStyle(
                      color: currentColor,
                      fontWeight: FontWeight.bold,
                      fontSize: r.s(12),
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: r.s(20)),

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
                            width: r.s(34),
                            height: r.s(34),
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
                              size: r.s(16),
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
  final r = Rsp.of(context);

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

  // أقصى عرض للزرار عشان ميتمططش على التابلت
  const maxButtonWidth = 480.0;

  return Container(
    padding: EdgeInsets.all(r.s(16)),
    decoration: BoxDecoration(
      color: Theme.of(context).cardColor,
      borderRadius: BorderRadius.circular(r.s(20)),
      border: Border.all(
        color: isFailed ? Colors.red.withAlpha(50) : Colors.grey.withAlpha(40),
      ),
    ),
    child: Column(
      children: [
        Row(
          children: [
            Container(
              width: r.s(42),
              height: r.s(42),
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
                size: r.s(24),
              ),
            ),

            SizedBox(width: r.s(12)),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Payment".tr,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: r.s(15),
                    ),
                  ),

                  SizedBox(height: r.s(3)),

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
                      fontSize: r.s(13),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(width: r.s(8)),

            ConstrainedBox(
              constraints: BoxConstraints(maxWidth: r.s(90)),
              child: Text(
                order.paymentMethod,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: r.s(12),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),

        // Retry Payment
        if (isFailed &&
            (order.paymentMethod == "card" ||
                order.paymentMethod == "wallet")) ...[
          SizedBox(height: r.s(15)),

          Align(
            alignment: Alignment.center,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: maxButtonWidth),
              child: SizedBox(
                width: double.infinity,
                child: Checkbutton(
                  statusrequest: controller.statusrequest,
                  buttonColor: color,
                  width: math.min(width, maxButtonWidth),
                  onTap: () {
                    controller.paymentController.retryPayment(order.orderId);
                  },
                  buttonName: "Retry Payment",
                ),
              ),
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
  return Builder(
    builder: (context) {
      final r = Rsp.of(context);

      return Column(
        children: [
          ...order.items.map<Widget>((item) {
            return Padding(
              padding: EdgeInsets.only(bottom: r.s(14)),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: r.s(70),
                    height: r.s(70),
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
                      borderRadius: BorderRadius.circular(r.s(16)),
                    ),
                    child: CachedNetworkImage(
                      imageUrl: item.image.toString(),
                      fit: BoxFit.contain,
                      placeholder: (_, __) {
                        return Center(
                          child: SizedBox(
                            width: r.s(18),
                            height: r.s(18),
                            child: const CircularProgressIndicator(
                              strokeWidth: 2,
                            ),
                          ),
                        );
                      },
                      errorWidget: (_, __, ___) {
                        return const Icon(Icons.image_not_supported_outlined);
                      },
                    ),
                  ),

                  SizedBox(width: r.s(12)),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.productName ?? "",
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: r.s(14),
                          ),
                        ),

                        SizedBox(height: r.s(7)),

                        Text(
                          "Quantity: ${item.quantity}",
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: r.s(12),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(width: r.s(8)),

                  PriceText(item.price),
                ],
              ),
            );
          }),

          const Divider(),

          SizedBox(height: r.s(5)),

          Align(
            alignment: AlignmentDirectional.centerStart,
            child: Text(
              "${order.items.length} Items",
              style: TextStyle(color: Colors.grey.shade600, fontSize: r.s(12)),
            ),
          ),
        ],
      );
    },
  );
}

// ============================================================================
// DELIVERY DETAILS
// ============================================================================

Widget deliveryDetails(OrderModel order) {
  final address = order.shippingAddress;

  return LayoutBuilder(
    builder: (context, constraints) {
      final r = Rsp.of(context);

      final rows = <Widget>[
        detailRow(
          icon: Icons.person_outline,
          title: "Name".tr,
          value: order.username,
        ),
        detailRow(
          icon: Icons.phone_outlined,
          title: "Phone Number".tr,
          value: address.phone ?? "-",
        ),
        detailRow(
          icon: Icons.location_on_outlined,
          title: "shipping address".tr,
          value: "${address.city ?? ""} - ${address.street ?? ""}",
        ),
      ];

      // مساحة عريضة (تابلت / ويب): الصفوف جنب بعض
      if (constraints.maxWidth >= 600) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (var i = 0; i < rows.length; i++) ...[
              if (i > 0) SizedBox(width: r.s(16)),
              Expanded(child: rows[i]),
            ],
          ],
        );
      }

      // موبايل: تحت بعض
      return Column(
        children: [
          for (var i = 0; i < rows.length; i++) ...[
            if (i > 0) SizedBox(height: r.s(12)),
            rows[i],
          ],
        ],
      );
    },
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
  return Builder(
    builder: (context) {
      final r = Rsp.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: r.s(38),
            height: r.s(38),
            decoration: BoxDecoration(
              color: isDark ? Theme.of(context).cardColor : const Color(0xFFE0E3E8),
              borderRadius: BorderRadius.circular(r.s(12)),
            ),
            child: Icon(icon, size: r.s(19)),
          ),

          SizedBox(width: r.s(12)),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: r.s(11),
                  ),
                ),

                SizedBox(height: r.s(3)),

                Text(
                  value,
                  style: TextStyle(
                    fontSize: r.s(13),
                    fontWeight: FontWeight.w600,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    },
  );
}

// ============================================================================
// ORDER SUMMARY
// ============================================================================

Widget orderSummary(OrderModel order) {
  return Builder(
    builder: (context) {
      final r = Rsp.of(context);

      return Column(
        children: [
          summaryRow("Subtotal".tr, order.subtotal),

          SizedBox(height: r.s(10)),

          summaryRow("Shipping".tr, order.shippingFee),

          SizedBox(height: r.s(10)),

          summaryRow("Tax", order.taxAmount),

          Padding(
            padding: EdgeInsets.symmetric(vertical: r.s(12)),
            child: const Divider(),
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  "Total price".tr,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: r.s(17),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              SizedBox(width: r.s(8)),

              PriceText(order.totalAmount),
            ],
          ),
        ],
      );
    },
  );
}

// ============================================================================
// SUMMARY ROW
// ============================================================================

Widget summaryRow(String title, dynamic value) {
  return Builder(
    builder: (context) {
      final r = Rsp.of(context);

      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: Colors.grey.shade600, fontSize: r.s(13)),
            ),
          ),

          SizedBox(width: r.s(8)),

          PriceText(value),
        ],
      );
    },
  );
}
