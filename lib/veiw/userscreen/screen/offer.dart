import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hos/controler/usercontroller/home/favorite/fav_controller.dart';
import 'package:hos/controler/usercontroller/offercontroller.dart';
import 'package:hos/core/class/handlingdataview.dart';
import 'package:hos/veiw/wedget/items/productcard.dart';

class Offer extends StatelessWidget {
  const Offer({super.key});

  @override
  Widget build(BuildContext context) {
    // تهيئة الكنترولرز
    Get.put(Offercontroller());
    Get.put(FavController());

    return Scaffold(
      body: GetBuilder<Offercontroller>(
        builder: (controller) {
          return RefreshIndicator(
            color: const Color.fromARGB(255, 8, 110, 150),
            onRefresh: () async => controller.getoffer(),
            child: Handlingdataview(
              statusrequest: controller.statusrequest,
              widget: CustomScrollView(
                physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics(),
                ),
                slivers: [
                  // 🔥 الجزء العلوي: البانر الإعلاني المتحرك أو الثابت
                  SliverToBoxAdapter(child: _buildResponsiveBanner(context)),

                  // 🧱 شبكة العروض (Grid) مع الـ Skeletonizer
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    sliver: SliverGrid(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        return productcard(controller.offerList[index], () {});
                      }, childCount: controller.offerList.length),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 16,
                            crossAxisSpacing: 12,
                            childAspectRatio: 0.65, // متناسب مع أغلب الشاشات
                          ),
                    ),
                  ),
                ],
              ),
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
