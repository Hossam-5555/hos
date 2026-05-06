import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hos/controler/usercontroller/home/Homepage_controller.dart';

// 1. نموذج (Model) لبيانات العرض
class OfferModel {
  final String title;
  final String description;
  final String discount;
  final List<Color> colors;
  final String image;

  OfferModel({
    required this.title,
    required this.description,
    required this.discount,
    required this.colors,
    required this.image,
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
          // داخل AnimatedSwitcher في AutoRotatingOffers
          child: OfferCard(
            key: ValueKey<int>(controller.currentIndex),
            title: controller.offers[controller.currentIndex].title,
            description: controller.offers[controller.currentIndex].description,
            discount: controller.offers[controller.currentIndex].discount,
            colors: controller.offers[controller.currentIndex].colors,
            image: controller
                .offers[controller.currentIndex]
                .image, // تمرير الرابط
            onTap: () => print("Clicked"),
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
  final List<Color> colors;
  final VoidCallback onTap;
  final String image; // غيرناه لـ String لسهولة التعامل مع URL

  const OfferCard({
    super.key,
    required this.title,
    required this.description,
    required this.discount,
    required this.colors,
    required this.onTap,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(
        40,
      ), // زوايا دائرية كبيرة جداً كالصورة
      child: Container(
        height: 140, // زيادة الارتفاع قليلاً لراحة التصميم
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: colors.isNotEmpty
                ? colors
                : [Colors.black, Colors.grey[900]!],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(40),
          boxShadow: [
            BoxShadow(
              color: (colors.isNotEmpty ? colors.last : Colors.black)
                  .withOpacity(0.2),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: ClipRRect(
          // لقص الصورة لتناسب زوايا الكونتينر
          borderRadius: BorderRadius.circular(40),
          child: Stack(
            children: [
              // الصورة في جهة اليسار بتصميم متداخل
              Positioned(
                left: -20,
                top: -10,
                bottom: -10,
                width: MediaQuery.of(context).size.width * 0.45,
                child: Image.network(image, fit: BoxFit.cover),
              ),
              // غطاء شفاف (Gradient overlay) لجعل النص مقروءاً فوق الصورة
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.black.withOpacity(0.6), Colors.transparent],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                ),
              ),
              // محتوى النصوص في جهة اليمين
              Align(
                alignment: Alignment.centerRight,
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.5,
                  padding: const EdgeInsets.only(right: 30),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        discount,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 22, // نص الخصم كبير
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        title,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 8),
                      // زر "Learn more" كما في الصورة
                      Text(
                        "Learn more...",
                        style: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 12,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
