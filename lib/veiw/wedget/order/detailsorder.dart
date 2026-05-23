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
  Widget statusorder(String status, Color currentColor, String text) {
  // 1️⃣ أضفنا اللون المخصص لكل حالة داخل الـ Map
  final steps = [
    {"icon": Icons.receipt_long, "label": "Pending", "color": Colors.orange},
    {"icon": Icons.inventory_2, "label": "Processing", "color": Colors.blue},
    {"icon": Icons.local_shipping, "label": "Shipped", "color": const Color.fromARGB(255, 179, 123, 39)},
    {"icon": Icons.check_circle, "label": "Delivered", "color": const Color.fromARGB(255, 33, 201, 10)},
  ];

  int current = [
    "pending",
    "processing",
    "shipped",
    "delivered",
  ].indexOf(status.toLowerCase());

  const animationDuration = Duration(milliseconds: 400);

  return card(
    Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 🔹 العنوان + الحالة العامة
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
            AnimatedDefaultTextStyle(
              duration: animationDuration,
              style: TextStyle(color: currentColor, fontWeight: FontWeight.bold, fontSize: 14),
              child: Text(text),
            ),
          ],
        ),

        const SizedBox(height: 16),

        // 🔹 Timeline Animated بالاستقلال اللوني لكل مرحلة
        Row(
          children: List.generate(steps.length, (i) {
            bool active = i <= current;
            bool last = i == steps.length - 1;
            
            // 2️⃣ استخراج لون الخطوة الحالية
            Color stepColor = steps[i]["color"] as Color;

            return Expanded(
              child: Column(
                children: [
                  Row(
                    children: [
                      // ⬅️ الخط الشمال (يأخذ لون الخطوة السابقة لو كانت نشطة لربط الألوان بشكل منطقي)
                      Expanded(
                        child: AnimatedContainer(
                          duration: animationDuration,
                          height: 2,
                          color: i == 0
                              ? Colors.transparent
                              : (i <= current ? (steps[i - 1]["color"] as Color) : Colors.grey.shade300),
                        ),
                      ),

                      // 🟢 الدائرة (تأخذ لون الخطوة الخاص بها)
                      AnimatedContainer(
                        duration: animationDuration,
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: active ? stepColor : Colors.grey.shade200,
                          shape: BoxShape.circle,
                          boxShadow: active
                              ? [
                                  BoxShadow(
                                    color: stepColor.withOpacity(0.3),
                                    blurRadius: 8,
                                    spreadRadius: 1,
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

                      // ➡️ الخط اليمين (يأخذ لون الخطوة الحالية ليكمل المسار للخطوة التالية)
                      Expanded(
                        child: AnimatedContainer(
                          duration: animationDuration,
                          height: 2,
                          color: last
                              ? Colors.transparent
                              : (i < current ? stepColor : Colors.grey.shade300),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 6),

                  // 📝 النص الأسفل (يأخذ لون الخطوة الخاص بها)
                  AnimatedDefaultTextStyle(
                    duration: animationDuration,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 10,
                      fontFamily: 'Cairo', // أو خط تطبيقك
                      fontWeight: active ? FontWeight.bold : FontWeight.normal,
                      color: active ? stepColor : Colors.grey,
                    ),
                    child: Text(steps[i]["label"].toString()),
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