import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hos/controler/profile/order/orderdetailescontroller.dart';

class Orderdetailes extends StatelessWidget {
  const Orderdetailes({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(Orderdetailescontroller());

    return Scaffold(
      appBar: AppBar(
        title: const Text('تفاصيل الطلب'),
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
      body: GetBuilder<Orderdetailescontroller>(
        builder: (_) {
          final order = controller.order;
          if (order == null) {
            return const Center(child: Text("❌ لم يتم استلام بيانات الطلب"));
          }

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('رقم الطلب: ${order.ordersId ?? "غير معروف"}'),
                const SizedBox(height: 8),
                Text('السعر الكلي: ${order.ordersTotalprice ?? "غير متاح"}'),
                const SizedBox(height: 8),
                Text('الحالة: ${order.ordersStatus ?? "غير محددة"}'),
                const SizedBox(height: 8),
                Text('تاريخ الطلب: ${order.ordersDatetime ?? "غير متاح"}'),
              ],
            ),
          );
        },
      ),
    );
  }
}
