import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hos/controler/usercontroller/home/homepage_controller.dart';
import 'package:hos/core/class/handlingdataview.dart';
import 'package:hos/veiw/wedget/Admin/SheardCard.dart';

// تأكد من استيراد ملف CategoryCard و HandlingDataView

class CurvedCategoriesView extends StatelessWidget {
  final double categoryHeight;
  const CurvedCategoriesView({super.key, required this.categoryHeight});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomepageController>(
      builder: (controller) {
        // يفضل تعريف PageController خاص بالأقسام في الكنترولر لتجنب التداخل مع المنتجات
        // أو استخدام متحكم محلي كما يلي:
        final PageController catPageController = PageController(
          initialPage: 1, // يبدأ من العنصر الثاني ليكون في المنتصف
          viewportFraction: 0.35, // نسبة عرض الكارت (قللها لعرض أقسام أكثر)
        );

        return SizedBox(
          height: categoryHeight * 1.3, // مساحة إضافية للحركة الرأسية والدوران
          child: HandlingDataView(
            statusrequest: controller.statusrequest,
            mode: HandlingMode.skeleton,
            widget: PageView.builder(
              controller: catPageController,
              itemCount: controller.categories.length,
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                final cat = controller.categories[index];

                return AnimatedBuilder(
                  animation: catPageController,
                  builder: (context, child) {
                    double value = 1.0;
                    double rotation = 0.0;
                    double translateY = 0.0;

                    if (catPageController.hasClients &&
                        catPageController.position.haveDimensions) {
                      double currentPage =
                          catPageController.page ??
                          catPageController.initialPage.toDouble();
                      double diff = (index - currentPage);

                      // حساب التصغير، الميلان، والإزاحة للأسفل
                      value = (1 - (diff.abs() * 0.15)).clamp(0.75, 1.0);
                      rotation = diff * 0.12; // زاوية الميلان
                      translateY =
                          (categoryHeight * 0.25) *
                          (1 - value); // النزول لأسفل في الأطراف
                    } else {
                      if (index != catPageController.initialPage) {
                        value = 0.75;
                        rotation =
                            (index - catPageController.initialPage) * 0.12;
                        translateY = (categoryHeight * 0.25) * (1 - value);
                      }
                    }

                    return Transform.translate(
                      offset: Offset(0, translateY),
                      child: Transform.scale(
                        scale: value,
                        child: Transform.rotate(
                          angle: rotation,
                          child: Opacity(
                            opacity: value.clamp(0.6, 1.0),
                            child: CategoryCard.Homepage(
                              inHome: true,
                              onTap: () {
                                controller.gotoitems(
                                  controller.categories,
                                  index,
                                  cat.id.toString(),
                                );
                              },
                              name: controller.isarabic ? cat.nameAr : cat.name,
                              onEdit: () {},
                              onDelete: () {},
                              imageUrl: cat.image!,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }
}
