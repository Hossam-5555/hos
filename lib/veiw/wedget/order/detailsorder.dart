import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:hos/data/model/ordersmodel.dart';

Widget card(Widget child) => Container(
  margin: const EdgeInsets.only(bottom: 12),
  padding: const EdgeInsets.all(12),
  decoration: BoxDecoration(
    border: Border.all(color: Colors.grey.withAlpha(50)),
    borderRadius: BorderRadius.circular(20),
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
    {
      "icon": Icons.local_shipping,
      "label": "Shipped",
      "color": const Color.fromARGB(255, 179, 123, 39),
    },
    {
      "icon": Icons.check_circle,
      "label": "Delivered",
      "color": const Color.fromARGB(255, 33, 201, 10),
    },
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
                SizedBox(width: 10),
                Text("Status", style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
            AnimatedDefaultTextStyle(
              duration: animationDuration,
              style: TextStyle(
                color: currentColor,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
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
                              : (i <= current
                                    ? (steps[i - 1]["color"] as Color)
                                    : Colors.grey.shade300),
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
                              : (i < current
                                    ? stepColor
                                    : Colors.grey.shade300),
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

// items
Widget items(OrderModel order) => Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    Row(
      children: [
        Icon(Icons.shopping_cart, size: 14),
        const SizedBox(width: 10),
        const Text(
          "Products",
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
            // color: Colors.black87,
          ),
        ),
      ],
    ),
    ...order.items.map<Widget>(
      (e) => ListTile(
        leading: Container(
          alignment: Alignment.center,
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFFFFFFFF), // مركز الإضاءة الأبيض المشع
                Color(0xFFF2F4F7), // البلاتينيوم الناعم
                Color(0xFFD0D5DD), // الأطراف الفضية الراقية
              ],
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: CachedNetworkImage(
            imageUrl: e.image.toString(),
            imageBuilder: (context, imageProvider) => Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: imageProvider,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            placeholder: (context, url) => CircularProgressIndicator(),
            errorWidget: (context, url, error) => Icon(Icons.error),
          ),
        ),
        contentPadding: EdgeInsets.zero,
        title: Text(e.productName!),
        subtitle: Text("x${e.quantity}"),
        trailing: Text(
          "${e.price}\$",
          style: TextStyle(color: Colors.green, fontSize: 14),
        ),
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
// Widget row(IconData i, String t, String? v) => ListTile(
//   contentPadding: EdgeInsets.zero,
//   leading: Icon(i),
//   title: Text(t),
//   subtitle: Text(v ?? "-"),
// );
// info
// Widget info(order) => Column(
//   children: [
//     row(Icons.person, "Name", order.username),
//     row(Icons.phone, "Phone", order.shippingAddress.phone),
//     row(
//       Icons.location_on,
//       "Address",
//       "${order.shippingAddress.city} - ${order.shippingAddress.street}",
//     ),
//   ],
// );

// الويدجت الرئيسية لعرض بيانات العميل
Widget info(order) {
  return Container(
    padding: const EdgeInsets.all(10),

    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // --- عنوان القسم ---
        Row(
          children: [
            Icon(
              Icons.contact_page_rounded,
              color: Colors.blue.shade700,
              size: 24,
            ),
            const SizedBox(width: 10),
            const Text(
              "Customer Details",
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                // color: Colors.black87,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),

        // --- البيانات ---
        row(
          icon: Icons.person_outline_rounded,
          title: "Name",
          value: order.username ?? "Unknown",
          iconColor: Colors.purple,
        ),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 12.0),
          child: Divider(height: 1, thickness: 1, color: Color(0xFFF5F5F5)),
        ),
        row(
          icon: Icons.phone_android_rounded,
          title: "Phone Number",
          value: order.shippingAddress.phone ?? "-",
          iconColor: Colors.green,
        ),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 12.0),
          child: Divider(height: 1, thickness: 1, color: Color(0xFFF5F5F5)),
        ),
        row(
          icon: Icons.location_on_outlined,
          title: "Shipping Address",
          value:
              "${order.shippingAddress.city ?? ""} - ${order.shippingAddress.street ?? ""}",
          iconColor: Colors.orange,
        ),
      ],
    ),
  );
}

// الويدجت المساعدة (بديل للـ ListTile) بتصميم عصري
Widget row({
  required IconData icon,
  required String title,
  required String value,
  required Color iconColor,
}) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      // خلفية الأيقونة (مربع بحواف دائرية ولون شفاف)
      Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: iconColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: iconColor, size: 22),
      ),
      const SizedBox(width: 16),

      // النصوص
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade500,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                // color: Colors.black87,
                height: 1.3,
              ),
            ),
          ],
        ),
      ),
    ],
  );
}

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
