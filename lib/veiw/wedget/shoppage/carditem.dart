import 'package:cached_network_image/cached_network_image.dart';
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
        color: Colors.white, // أضفنا لون خلفية أبيض
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200), // لون أخف للحدود
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(10),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Row(
        children: [
          // 1. صورة المنتج
          Container(
            width: 90,
            height: 90,
            decoration: BoxDecoration(
              color: const Color(0xFFF4F5F7),
              borderRadius: BorderRadius.circular(14),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: CachedNetworkImage(
                imageUrl: cart.itemimage!,
                fit: BoxFit.cover,
                placeholder: (context, url) => const Center(child: CircularProgressIndicator(strokeWidth: 2)),
                errorWidget: (context, url, error) => const Icon(Icons.error_outline),
              ),
            ),
          ),

          const SizedBox(width: 16),

          // 2. تفاصيل المنتج
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  cart.itemsname ?? "بدون اسم",
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${double.parse(controller.data[i].subtotal.toString()).toStringAsFixed(2)} \$',
                      style: const TextStyle(fontSize: 16, color: Colors.blueAccent, fontWeight: FontWeight.w800),
                    ),
                    
                    // كبسولة التحكم في الكمية
                    Container(
                      height: 40, // جعلنا الارتفاع مناسب للزرار (بدل 80)
                      decoration: BoxDecoration(
                        color: const Color(0xFFF4F5F7), // لون رمادي فاتح للخلفية
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Row(
                        children: [
                          IconButton(
                            iconSize: 18,
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(minWidth: 40),
                            icon: const Icon(Icons.remove_rounded,color: Colors.redAccent),
                            onPressed: () => controller.decrement(cart.itemid!),
                          ),
                          Text(
                            '${controller.data[i].cartCount}',
                            style: const TextStyle(fontWeight: FontWeight.bold,color: Colors.black87),
                          ),
                          IconButton(
                            iconSize: 18,
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(minWidth: 40),
                            icon: const Icon(Icons.add_rounded,color: Colors.blueAccent),
                            onPressed: () => controller.increment(cart.itemid!),
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