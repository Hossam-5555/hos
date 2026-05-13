import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hos/controler/usercontroller/home/Homepage_controller.dart';
import 'package:hos/core/class/crud.dart';
import 'package:hos/data/model/itemsmodel.dart';
import 'package:hos/veiw/userscreen/screen/home/Homepage.dart';
import 'package:hos/veiw/wedget/SharedProductCard.dart';
import 'package:skeletonizer/skeletonizer.dart';

class CurvedItemsView extends StatelessWidget {
  CurvedItemsView({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    // final width = size.width;
    final height = size.height;

    // تحديد ارتفاع متناسب مع طول الشاشة (مثلاً 35% من طول الشاشة)
    // هذا يضمن أن التصميم لا يظهر صغيراً جداً في الشاشات الطويلة
    final double viewHeight = height * 0.35;

    return GetBuilder<HomepageController>(
      builder: (controller) {
        if (controller.newArival.isEmpty) {
          return SizedBox(
            height: viewHeight,
            child: const Center(child: CircularProgressIndicator()),
          );
        }

        final PageController pageController =
            controller.pageController ??
            PageController(
              initialPage: 0,
              viewportFraction: 0.55,
            ); // زيادة النسبة قليلاً لعرض محتوى أفضل

        return SizedBox(
          height: viewHeight,
          child: PageView.builder(
            controller: pageController,
            itemCount: controller.newArival.length,
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              ItemsModel items = controller.newArival[index];

              return AnimatedBuilder(
                animation: pageController,
                builder: (context, child) {
                  double value = 1.0;
                  double rotation = 0.0;
                  double translateY = 0.0;

                  if (pageController.hasClients &&
                      pageController.position.haveDimensions) {
                    double currentPage =
                        pageController.page ??
                        pageController.initialPage.toDouble();
                    double diff = (index - currentPage);
                    value = (1 - (diff.abs() * 0.2)).clamp(0.8, 1.0);
                    rotation = diff * 0.1;
                    // جعل الإزاحة متناسبة مع طول العنصر
                    translateY = (viewHeight * 0.2) * (1 - value);
                  } else {
                    if (index != pageController.initialPage) {
                      value = 0.8;
                      translateY = (viewHeight * 0.2) * (1 - value);
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
                          child: Skeletonizer(
                            enabled:
                                controller.statusrequest ==
                                Statusrequest.loading,
                            child: SharedProductCard(
                              onTap: () {
                                controller.gotoitemsdetails(items);
                              },
                              image: items.itemsImage!,
                              title: items.itemsName!,
                              price: items.itemsPrice.toString(),
                              rating: 4.5,
                              actionButton: AddToCartButton(itemId: items.id!),
                              height: height,
                            ),
                          ),
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
