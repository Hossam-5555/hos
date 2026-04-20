import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hos/controler/usercontroller/checkout&cart/CartController.dart';
import 'package:hos/data/model/cartmodel.dart';

Widget buildCartItemCard(
  BuildContext context,
  CartModel cart,
  CartController controller,
  int i,
) {
  return GetBuilder<CartController>(
    builder: (controller) => Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(255, 46, 45, 45).withAlpha(140),
            offset: Offset(0, 00.4),
          ),
        ],
        // استخدام حد خفيف جداً بدل الظل (Shadow) لشكل أنظف
        border: Border.all(color: Colors.grey.shade500.withAlpha(70)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          /// 1. مربع صورة المنتج (نفس ستايل المينيمال)
          Container(
            width: 85,
            height: 85,
            decoration: BoxDecoration(
              color: const Color(0xFFF4F5F7), // الرمادي الفاتح
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.all(
              8,
            ), // مسافة داخلية عشان الصورة متلمسش الحواف
            child: Image.network(
              "",
              fit: BoxFit.contain, // يضمن إن الصورة تظهر كاملة بدون قص
              errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.broken_image_rounded, color: Colors.grey),
            ),
          ),

          const SizedBox(width: 16), // مسافة بين الصورة والتفاصيل
          /// 2. تفاصيل المنتج (الاسم، السعر، التحكم في الكمية)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // اسم المنتج
                Text(
                  cart.itemsname ?? "بدون اسم",
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),

                const SizedBox(height: 12),

                // صف يجمع بين السعر والكمية
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // السعر
                    Text(
                      '${double.parse(controller.data[i].subtotal.toString()).toStringAsFixed(2)} \$',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors
                            .black, // الأسود بيدي فخامة أكتر من اللون الأساسي هنا
                        fontWeight: FontWeight.w800,
                      ),
                    ),

                    // أزرار التحكم في الكمية (شكل كبسولة)
                    Container(
                      height: 36,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(
                          20,
                        ), // شكل بيضاوي أنيق
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // زرار الناقص (-)
                          IconButton(
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(
                              minWidth: 36,
                              minHeight: 36,
                            ),
                            icon: const Icon(
                              Icons.remove_rounded,
                              size: 18,
                              color: Colors.black,
                            ),
                            onPressed: () {
                              controller.decrement(cart.itemid!);
                            },
                          ),

                          // الكمية
                          Text(
                            '${controller.data[i].cartCount}',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),

                          // زرار الزائد (+)
                          IconButton(
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(
                              minWidth: 36,
                              minHeight: 36,
                            ),
                            icon: const Icon(
                              Icons.add_rounded,
                              size: 18,
                              color: Colors.black,
                            ),
                            onPressed: () {
                              controller.increment(cart.itemid!);
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
