import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hos/controler/usercontroller/checkout&cart/cart_controller.dart';
import 'package:hos/data/model/cartmodel.dart';
import 'package:jiffy/jiffy.dart';

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
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(77),
            blurRadius: 2,
            offset: const Offset(0, 0.2),
          ),
        ],
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          // 1. صورة المنتج
          Container(
            width: 110,
            height: 100,
            margin: EdgeInsetsDirectional.all(1),
            decoration: BoxDecoration(
              color: Color(0xFFE0E3E8),

              borderRadius: BorderRadius.circular(20),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: CachedNetworkImage(
                alignment: Alignment.center,
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
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ToggleInfoChips(isDark: isdark),

                    Text(
                      style: TextStyle(fontSize: 10),
                      Jiffy.parse(
                        isUtc: true,
                        cart.createdAt!,
                        pattern: 'yyyy-MM-dd hh:mm a',
                      ).fromNow(),
                    ),
                  ],
                ),

                const SizedBox(height: 6),
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
                      height: 40, // جعلنا الارتفاع مناسب للزرار (بدل 80)
                      decoration: BoxDecoration(
                        color: Color(0xFFE0E3E8),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            iconSize: 20,
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(
                              minWidth: 30,
                              minHeight: 30,
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
                              color: Colors.black,
                            ),
                          ),
                          IconButton(
                            onPressed: () => controller.increment(cart.itemid!),
                            iconSize: 20,
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(
                              minWidth: 30,
                              minHeight: 30,
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

Widget infoChip(IconData icon, String label, bool isDark, Key key) {
  return Column(
    key: key, // استخدام المفتاح القادم مباشرة
    mainAxisSize: MainAxisSize.min,
    children: [
      Icon(
        icon,
        size: 15,
        color: isDark ? Colors.green : const Color(0xFF555555),
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
  return Container(height: 35, width: 1, color: Colors.grey.withAlpha(51));
}

class ToggleInfoChips extends StatefulWidget {
  final bool isDark;

  const ToggleInfoChips({super.key, required this.isDark});

  @override
  State<ToggleInfoChips> createState() => _ToggleInfoChipsState();
}

class _ToggleInfoChipsState extends State<ToggleInfoChips> {
  Timer? _timer;
  bool _showFirst = true;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      setState(() {
        _showFirst = !_showFirst;
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 80,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 600), // مدة الحركة
        transitionBuilder: (Widget child, Animation<double> animation) {
          // تحديد اتجاه الحركة (من اليمين/اليسار)
          final offsetAnimation = Tween<Offset>(
            begin: const Offset(1.0, 0.0), // يبدأ من جهة اليمين خارج الشاشة
            end: Offset.zero, // ينتهي في المنتصف
          ).animate(animation);

          return SlideTransition(
            position: offsetAnimation,
            child: FadeTransition(
              opacity: animation, // إضافة شفافيه خفيفة أثناء السحب
              child: child,
            ),
          );
        },
        child: _showFirst
            ? infoChip(
                Icons.local_shipping_outlined,
                "Free Delivery",
                widget.isDark,
                const ValueKey('delivery'),
              )
            : infoChip(
                Icons.access_time_rounded,
                "20-25 min",
                widget.isDark,
                const ValueKey('time'),
              ),
      ),
    );
  }
}
