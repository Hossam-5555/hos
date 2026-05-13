  import 'package:flutter/material.dart';
import 'package:hos/data/model/ordersmodel.dart';

Widget card(Widget child) => Container(
    margin: const EdgeInsets.only(bottom: 12),
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      border: Border.all(color: Colors.grey.withAlpha(50)),
      borderRadius: BorderRadius.circular(12),
      // boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5)],
    ),
    child: child,
  );

  // status
  Widget statusorder(String status, Color color, String text) {
    final steps = [
      {"icon": Icons.receipt_long, "label": "Pending"},
      {"icon": Icons.inventory_2, "label": "Processing"},
      {"icon": Icons.local_shipping, "label": "Shipped"},
      {"icon": Icons.check_circle, "label": "Delivered"},
    ];

    int current = [
      "pending",
      "processing",
      "shipped",
      "delivered",
    ].indexOf(status);

    return card(
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🔹 العنوان + الحالة
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: const [
                  Icon(Icons.info_outline, size: 18),
                  SizedBox(width: 6),
                  Text("Status", style: TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
              Text(
                text,
                style: TextStyle(color: color, fontWeight: FontWeight.bold),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // 🔹 Timeline
          Row(
            children: List.generate(steps.length, (i) {
              bool active = i <= current;
              bool last = i == steps.length - 1;

              return Expanded(
                child: Column(
                  children: [
                    Row(
                      children: [
                        // الخط الشمال
                        Expanded(
                          child: Container(
                            height: 2,
                            color: i == 0
                                ? Colors.transparent
                                : (i <= current ? color : Colors.grey.shade300),
                          ),
                        ),

                        // الدائرة
                        AnimatedContainer(
                          duration: Duration(milliseconds: 300),
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: active ? color : Colors.grey.shade200,
                            shape: BoxShape.circle,
                            boxShadow: active
                                ? [
                                    BoxShadow(
                                      color: color.withOpacity(0.4),
                                      blurRadius: 6,
                                    ),
                                  ]
                                : [],
                          ),
                          child: Icon(
                            steps[i]["icon"] as IconData,
                            size: 14,
                            color: active ? Colors.white : Colors.grey,
                          ),
                        ),

                        // الخط اليمين
                        Expanded(
                          child: Container(
                            height: 2,
                            color: last
                                ? Colors.transparent
                                : (i < current ? color : Colors.grey.shade300),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 6),

                    // النص
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
  }

  // info
  Widget info(order) => Column(
    children: [
      row(Icons.person, "Name", order.username),
      row(Icons.phone, "Phone", order.shippingAddress.phone),
      row(
        Icons.location_on,
        "Address",
        "${order.shippingAddress.city} - ${order.shippingAddress.street}",
      ),
    ],
  );

  // items
  Widget items(OrderModel order) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text("Products", style: TextStyle(fontWeight: FontWeight.bold)),
      ...order.items.map<Widget>(
        (e) => ListTile(
          leading: Container(
            alignment: Alignment.center,
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text("${order.orderId}"),
          ),
          contentPadding: EdgeInsets.zero,
          title: Text(e.productName!),
          subtitle: Text("x${e.quantity}"),
          trailing: Text("${e.price}\$", style: TextStyle(color: Colors.green)),
        ),
      ),
    ],
  );

  // price
  Widget price(order) => Column(
    children: [
      priceRow("Subtotal", order.subtotal),
      priceRow("Shipping", order.shippingFee),
      priceRow("Tax", order.taxAmount),
      Divider(),
      priceRow("Total", order.totalAmount, big: true),
    ],
  );

  // helpers
  Widget row(IconData i, String t, String? v) => ListTile(
    contentPadding: EdgeInsets.zero,
    leading: Icon(i),
    title: Text(t),
    subtitle: Text(v ?? "-"),
  );

  Widget priceRow(String t, dynamic v, {bool big = false}) => Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(t),
      Text(
        "$v\$",
        style: TextStyle(
          fontSize: big ? 18 : 14,
          fontWeight: FontWeight.bold,
          color: Colors.green,
        ),
      ),
    ],
  );