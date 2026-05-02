import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:hos/controler/usercontroller/home/Homepage_controller.dart';
import 'package:hos/core/class/crud.dart';
import 'package:hos/core/conistant/imageasset.dart';
import 'package:hos/data/model/itemsmodel.dart';
import 'package:skeletonizer/skeletonizer.dart';

class CurvedItemsView extends StatelessWidget {
  CurvedItemsView({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
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
                            child: InkWell(
                              onTap: () => controller.gotoitemsdetails(items),
                              child: Container(
                                margin: EdgeInsets.symmetric(
                                  horizontal: width * 0.02,
                                ), // هامش جانبي مرن
                                decoration: BoxDecoration(
                                  // color: Colors.white,
                                  borderRadius: BorderRadius.circular(
                                    width * 0.06,
                                  ), // زوايا مرنة

                                  border: Border.all(
                                    color: Colors.grey.withAlpha(30),
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    // 🖼 قسم الصورة المحسن
                                    Expanded(
                                      flex: 2, // تأخذ 60% من مساحة الكارد
                                      child: Container(
                                        width: double.infinity,
                                        margin: EdgeInsets.all(width * 0.03),
                                        decoration: BoxDecoration(
                                          color: Colors.grey[50],
                                          borderRadius: BorderRadius.circular(
                                            width * 0.04,
                                          ),
                                        ),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            width * 0.04,
                                          ),
                                          child: CachedNetworkImage(
                                            imageUrl: items.itemsImage!,
                                            fit: BoxFit
                                                .contain, // أفضل لعرض المنتجات بدون قص
                                            placeholder: (context, url) =>
                                                const Center(
                                                  child:
                                                      CircularProgressIndicator(
                                                        strokeWidth: 2,
                                                      ),
                                                ),
                                            errorWidget:
                                                (context, url, error) =>
                                                    const Icon(
                                                      Icons.broken_image,
                                                    ),
                                          ),
                                        ),
                                      ),
                                    ),

                                    // 🔹 قسم البيانات المحسن
                                    Expanded(
                                      flex: 1, // تأخذ 40% من مساحة الكارد
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: width * 0.03,
                                          vertical: 4,
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              items.itemsName ?? "",
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                fontSize:
                                                    width * 0.035, // خط متجاوب
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Row(
                                              children: [
                                                Icon(
                                                  Icons.star_rounded,
                                                  size: width * 0.035,
                                                  color: Colors.amber,
                                                ),
                                                const SizedBox(width: 2),
                                                Text(
                                                  "4.5",
                                                  style: TextStyle(
                                                    fontSize: width * 0.03,
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Flexible(
                                                  child: Text(
                                                    "${items.itemsPrice} ${"EGP".tr}",
                                                    style: TextStyle(
                                                      fontSize: width * 0.038,
                                                      fontWeight:
                                                          FontWeight.w900,
                                                      color: const Color(
                                                        0xFF2D5BFF,
                                                      ), // اللون الأزرق من الصورة السابقة
                                                    ),
                                                  ),
                                                ),
                                                // زر السلة المتجاوب
                                                Container(
                                                  padding: const EdgeInsets.all(
                                                    6,
                                                  ),
                                                  decoration:
                                                      const BoxDecoration(
                                                        color: Colors.black,
                                                        shape: BoxShape.circle,
                                                      ),
                                                  child: SvgPicture.asset(
                                                    Imageasset.cart,
                                                    height: width * 0.04,
                                                    width: width * 0.04,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
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
