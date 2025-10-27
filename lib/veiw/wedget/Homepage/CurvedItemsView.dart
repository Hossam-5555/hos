import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hos/controler/home/Homepage_controller.dart';
import 'package:hos/veiw/wedget/Homepage/productcardHome.dart';

class CurvedItemsView extends StatelessWidget {
  const CurvedItemsView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomepageController>(
      // 1. استدعِ دالة الإنشاء عند تهيئة الـ GetBuilder لأول مرة
      initState: (state) {
        Get.find<HomepageController>().initPageController();
      },
      builder: (controller) {
        // 2. أضف شرطاً للتأكد من أن الـ Controller ليس فارغاً
        if (controller.pageController == null) {
          // يمكنك إظهار مؤشر تحميل هنا بينما يتم إنشاؤه
          return const Center(child: CircularProgressIndicator());
        }

        return SizedBox(
          height: 300,
          child: PageView.builder(
            controller: controller.pageController,
            itemCount: controller.items.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              return AnimatedBuilder(
                animation: controller.pageController!,
                builder: (context, child) {
                  double value = 1.0;
                  final pageController = controller.pageController!;

                  if (pageController.position.haveDimensions) {
                    final currentPage =
                        pageController.page ??
                        pageController.initialPage.toDouble();
                    value = (1 - ((currentPage - index).abs() * 0.4)).clamp(
                      0.0,
                      1.0,
                    );
                  }

                  return Transform.translate(
                    offset: Offset(0, 50 * (1 - value)),
                    child: Transform.scale(
                      scale: value,
                      child: Transform.rotate(
                        angle:
                            (index -
                                (pageController.page ??
                                        pageController.initialPage.toDouble())
                                    .round()) *
                            0.2,
                        child: Opacity(
                          opacity: value,
                          child: ItemsCardhome(index: index),
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        );
      },
    );
  }
}
