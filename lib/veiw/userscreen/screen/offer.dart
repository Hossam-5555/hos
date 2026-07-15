import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hos/controler/usercontroller/home/favorite/fav_controller.dart';
import 'package:hos/controler/usercontroller/offercontroller.dart';
import 'package:hos/core/class/handlingdataview.dart';
import 'package:hos/data/model/itemsmodel.dart';
import 'package:hos/veiw/wedget/SharedProductCard.dart';
import 'package:hos/veiw/wedget/appbarbackicon.dart';

import 'home/Homepage.dart';

class Offer extends StatelessWidget {
  const Offer({super.key});

  @override
  Widget build(BuildContext context) {
    // تهيئة الكنترولرز
    Get.put(Offercontroller());
    Get.put(FavController());

    return Scaffold(
      appBar: Appbarbackicon(title: "offer", herotag: "offer"),
      body: GetBuilder<Offercontroller>(
        builder: (controller) {
          return RefreshIndicator(
            color: const Color.fromARGB(255, 8, 110, 150),
            onRefresh: () async => controller.getoffer(),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final width = constraints.maxWidth;

                // نقاط توقف بسيطة: هاتف صغير / هاتف عادي / تابلت
                final bool isSmallPhone = width < 360;
                final bool isTablet = width >= 600;

                // مسافات متجاوبة اعتماداً على العرض (أثبت من الطول بين الأجهزة)
                // مع حدود دنيا وقصوى عشان ماتبقاش صغيرة أوي أو كبيرة أوي
                final double horizontalPadding = (width * 0.045).clamp(
                  12.0,
                  32.0,
                );
                // final double sectionSpacing = (width * 0.05).clamp(14.0, 26.0);

                // // ارتفاع قائمة التصنيفات الأفقية: نسبة من العرض مش من الطول
                // final double categoryHeight = (width * 0.32).clamp(92.0, 132.0);

                // عدد أعمدة الجريد: 2 للهاتف، 3 للتابلت الصغير، 4 للتابلت الكبير
                final int gridCrossAxisCount = isTablet
                    ? (width >= 900 ? 4 : 3)
                    : 2;
                final double gridSpacing = isSmallPhone ? 10.0 : 12.0;

                // عرض الكارت الفعلي بعد خصم الـ padding والمسافات بين الأعمدة
                final double cardWidth =
                    (width -
                        (horizontalPadding * 2) -
                        (gridSpacing * (gridCrossAxisCount - 1))) /
                    gridCrossAxisCount;
                return HandlingDataView(
                  statusrequest: controller.statusrequest,
                  widget: CustomScrollView(
                    physics: const BouncingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics(),
                    ),
                    slivers: [
                      // 🔥 الجزء العلوي: البانر الإعلاني المتحرك أو الثابت
                      SliverToBoxAdapter(
                        child: _buildResponsiveBanner(context),
                      ),

                      // 🧱 شبكة العروض (Grid) مع الـ Skeletonizer
                      SliverPadding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                        sliver: SliverGrid(
                          delegate: SliverChildBuilderDelegate((
                            context,
                            index,
                          ) {
                            ItemsModel item = controller.offerList[index];
                            final double baseHeight = cardWidth * 1.55;
                            final double cardHeight = index.isEven
                                ? baseHeight
                                : baseHeight * 1.2;
                            return SharedProductCard(
                              image: "${item.itemsImage}",
                              title: "${item.itemsName}",
                              price: "${item.itemsPrice}",
                              rating: 4.8,
                              onTap: () {},

                              actionButton: AddToCartButton(itemId: item.id!),

                              /// 🔥 أهم سطر
                              height: cardHeight,
                            );
                          }, childCount: controller.offerList.length),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                mainAxisSpacing: 16,
                                crossAxisSpacing: 12,
                                childAspectRatio:
                                    0.65, // متناسب مع أغلب الشاشات
                              ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  // تصميم البانر ليكون متجاوباً (Responsive)
  Widget _buildResponsiveBanner(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Container(
      width: screenWidth,
      margin: const EdgeInsets.fromLTRB(16, 40, 16, 10),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0F2027), Color(0xFF203A43)], // ألوان تقنية غامقة
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(
          screenWidth * 0.1,
        ), // زوايا دائرية نسبية
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(Icons.bolt, color: Colors.yellow, size: 30),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: const [
                Text(
                  "أقوى عروض الإلكترونيات",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "تخفيضات تصل إلى 50% على السماعات",
                  style: TextStyle(color: Colors.white70, fontSize: 13),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
