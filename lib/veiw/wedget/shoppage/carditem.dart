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
  bool isdark,
) {
  return GetBuilder<CartController>(
    builder: (controller) => Container(
      margin: const EdgeInsets.all(5),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          // 1. صورة المنتج
          Container(
            width: 110,
            height: 90,
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
              borderRadius: BorderRadius.circular(14),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: CachedNetworkImage(
                imageUrl: cart.itemimage!,
                fit: BoxFit.contain,
                placeholder: (context, url) => const Center(
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
                errorWidget: (context, url, error) =>
                    const Icon(Icons.error_outline),
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
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    infoChip(
                      Icons.local_shipping_outlined,
                      "Free Delivery",
                      isdark,
                    ),
                    verticalDivider(),
                    infoChip(Icons.access_time_rounded, "20-25 min", isdark),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${double.parse(controller.data[i].subtotal.toString()).toStringAsFixed(2)} \$',
                      style: const TextStyle(
                        fontSize: 15,
                        color: Color(0xFFB65030),
                        fontWeight: FontWeight.w800,
                      ),
                    ),

                    // كبسولة التحكم في الكمية
                    Container(
                      height: 35, // جعلنا الارتفاع مناسب للزرار (بدل 80)
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
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Row(
                        children: [
                          IconButton(
                            iconSize: 15,
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(
                              minWidth: 25,
                              minHeight: 25,
                            ),
                            style: IconButton.styleFrom(
                              backgroundColor:
                                  Colors.white, // اللون اللي أنت عايزه
                              shape: const CircleBorder(),
                            ),
                            icon: const Icon(
                              Icons.remove_rounded,
                              color: Colors.black,
                            ),
                            onPressed: () => controller.decrement(cart.itemid!),
                          ),
                          Text(
                            '${controller.data[i].cartCount}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          IconButton(
                            onPressed: () => controller.increment(cart.itemid!),
                            iconSize: 15,
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(
                              minWidth: 25,
                              minHeight: 25,
                            ),
                            style: IconButton.styleFrom(
                              backgroundColor:
                                  Colors.black, // اللون اللي أنت عايزه
                              shape: const CircleBorder(),
                            ),
                            icon: const Icon(
                              Icons.add_rounded,
                              color: Colors.white,
                            ),
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

Widget infoChip(IconData icon, String label, bool isDark) {
  return Column(
    children: [
      Icon(
        icon,
        size: 15,
        color: isDark ? Colors.white70 : const Color(0xFF555555),
      ),
      const SizedBox(height: 4),
      Text(
        label,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: isDark ? Colors.white60 : const Color(0xFF555555),
        ),
      ),
    ],
  );
}

Widget verticalDivider() {
  return Container(height: 35, width: 1, color: Colors.grey.withOpacity(0.2));
}
