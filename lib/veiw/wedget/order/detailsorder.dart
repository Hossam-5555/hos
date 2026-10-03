import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:hos/data/model/ordersmodel.dart';
import 'package:hos/veiw/wedget/pricecard.dart';

// ignore: must_be_immutable
class CardWidget extends StatelessWidget {
  CardWidget({super.key, required this.child});
  Widget child;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        border: Border.all(color: Colors.grey.withAlpha(50)),
        borderRadius: BorderRadius.circular(20),
      ),
      child: child,
    );
  }
}

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

  return CardWidget(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 🔹 العنوان + الحالة العامة
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: const [
                Icon(Icons.info_outline),
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
                                    color: stepColor.withAlpha(76),
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
        subtitle: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text("x${e.quantity}"),
            Text("${e.price}\$", style: TextStyle(color: Colors.green)),
          ],
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

// الويدجت الرئيسية لعرض بيانات العميل
Widget info(order) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      // --- عنوان القسم ---
      Row(
        children: [
          Icon(Icons.contact_page_rounded),
          const SizedBox(width: 10),
          const Text(
            "Customer Details",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              // color: Colors.black87,
            ),
          ),
        ],
      ),

      // --- البيانات ---
      row(
        icon: Icons.person_outline_rounded,
        title: "Name",
        value: order.username ?? "Unknown",
        iconColor: Colors.purple,
      ),

      row(
        icon: Icons.phone_android_rounded,
        title: "Phone Number",
        value: order.shippingAddress.phone ?? "-",
        iconColor: Colors.green,
      ),

      row(
        icon: Icons.location_on_outlined,
        title: "Shipping Address",
        value:
            "${order.shippingAddress.city ?? ""} -\n ${order.shippingAddress.street ?? ""}",
        iconColor: Colors.orange,
      ),
    ],
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
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
        child: Icon(icon, color: iconColor, size: 18),
      ),
      const SizedBox(width: 5),
      Text(
        value,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          // color: Colors.black87,
          height: 1.3,
        ),
      ),

      // النصوص
    ],
  );
}

Widget priceRow(String t, dynamic v, {bool big = false}) => Row(
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  children: [Text(t), PriceText(v)],
);
