import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hos/controler/usercontroller/home/Homepage_controller.dart';

// 1. نموذج (Model) لبيانات العرض
class OfferModel {
  final String title;
  final String description;
  final String discount;
  final List<Color> colors;

  OfferModel({
    required this.title,
    required this.description,
    required this.discount,
    required this.colors,
  });
}

class AutoRotatingOffers extends StatelessWidget {
  const AutoRotatingOffers({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // استخدمنا GetBuilder للاستماع للـ update() القادمة من الكنترولر
    return GetBuilder<HomepageController>(
      init: HomepageController(), // تهيئة الكنترولر
      builder: (controller) {
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 600),
          transitionBuilder: (Widget child, Animation<double> animation) {
            return FadeTransition(opacity: animation, child: child);
          },
          child: OfferCard(
            // Key ضروري جداً هنا لكي يفهم AnimatedSwitcher أن الكارت تغير ويعمل أنيميشن
            key: ValueKey<int>(controller.currentIndex),
            title: controller.offers[controller.currentIndex].title,
            description: controller.offers[controller.currentIndex].description,
            discount: controller.offers[controller.currentIndex].discount,
            colors: controller.offers[controller.currentIndex].colors,
            onTap: () {
              print("تم الضغط على: ${controller.offers[controller.currentIndex].title}");
            },
          ),
        );
      },
    );
  }
}

// 3. كارت العرض (بعد التعديل ليقبل الألوان)
class OfferCard extends StatelessWidget {
  final String title;
  final String description;
  final String discount;
  final List<Color> colors; // <- إضافة متغير الألوان
  final VoidCallback onTap;

  const OfferCard({
    super.key,
    required this.title,
    required this.description,
    required this.discount,
    required this.colors, // <- استقبال الألوان
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: colors, // <- استخدام الألوان الممررة
          ),
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: colors.last.withOpacity(
                .3,
              ), // جعل لون الظل متناسق مع العرض
              blurRadius: 10,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            /// 🔥 النصوص
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    discount,
                    style: const TextStyle(
                      color: Colors.yellow,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ],
              ),
            ),

            /// 🎯 أيقونة
            const Icon(Icons.local_offer, color: Colors.white, size: 32),
          ],
        ),
      ),
    );
  }
}
