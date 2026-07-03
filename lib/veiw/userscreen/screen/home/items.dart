// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart'; // 📌 تمت إضافته لعمل شكل الشلال الموجود بالصورة
import 'package:hos/controler/usercontroller/home/favorite/fav_controller.dart';
import 'package:hos/controler/usercontroller/home/items_controler.dart';
import 'package:hos/core/class/handlingdataview.dart';
import 'package:hos/core/conistant/appcolor.dart';
import 'package:hos/veiw/userscreen/screen/home/Homepage.dart';
import 'package:hos/veiw/wedget/SharedProductCard.dart';
import 'package:hos/veiw/wedget/appbarbackicon.dart';
import 'package:hos/veiw/wedget/items/itemsappbar.dart';
import 'package:hos/veiw/wedget/items/itemslist.dart';

class Items extends StatelessWidget {
  const Items({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final height = size.height;
    final width = size.width;

    ItemsControler controller = Get.put(ItemsControler());
    Get.put(FavController());

    return Scaffold(
      backgroundColor: const Color(
        0xFFF9F9F9,
      ), // لون خلفية أفتح قليلاً بناءً على الصورة
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: Appbarbackicon(
          herotag: "items",
          title: "Items",
          selected: false,
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            /// 📂 القائمة الأفقية للأقسام (كما طلبت تركناها كما هي)
            Container(
              margin: EdgeInsets.only(
                top: height * 0.01,
                bottom: height * 0.01,
              ),
              height: height * 0.07,
              width: width,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: controller.categories.length,
                itemBuilder: (_, i) {
                  final catmodel = controller.categories[i];
                  final icon = "${catmodel.image}";
                  return BuildCategoryItems(
                    catmodel: catmodel,
                    urlIcon: icon,
                    i: i,
                  );
                },
              ),
            ),

            /// 🎛️ شريط الفلاتر الأول (Sort, Price, Brand, Rating) - بناءً على الصورة
            Padding(
              padding: EdgeInsets.symmetric(horizontal: width * 0.04),
              child: Row(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _buildFilterButton("Sort"),
                          const SizedBox(width: 8),
                          _buildFilterButton("Price"),
                          const SizedBox(width: 8),
                          _buildFilterButton("Brand"),
                          const SizedBox(width: 8),
                          _buildFilterButton("Rating"),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  // أيقونة تغيير العرض (Grid/List) الموجودة في الصورة
                  FilterButton(controller: controller),
                ],
              ),
            ),

            const SizedBox(height: 12),

            /// ✅ شريط الفلاتر المحددة (Active Filters & Clear All) - بناءً على الصورة
            Padding(
              padding: EdgeInsets.symmetric(horizontal: width * 0.04),
              child: Row(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _buildActiveFilterChip("Samsung"),
                          const SizedBox(width: 8),
                          _buildActiveFilterChip("Under \$500"),
                          const SizedBox(width: 8),
                          _buildActiveFilterChip("4★ & Up"),
                        ],
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      // مسح جميع الفلاتر
                    },
                    child: const Text(
                      "Clear All",
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            /// 🛍 شبكة العناصر (المنتجات) بالشكل المتدرج (Masonry)
            Expanded(
              child: GetBuilder<ItemsControler>(
                builder: (controller) => Handlingdataview(
                  statusrequest: controller.statusrequest,
                  widget: NotificationListener<ScrollNotification>(
                    onNotification: (ScrollNotification scrollInfo) {
                      if (scrollInfo.metrics.pixels >=
                          scrollInfo.metrics.maxScrollExtent - 100) {
                        controller.getitems(controller.catid);
                      }
                      return false;
                    },
                    // 📌 استخدام MasonryGridView لتطبيق الشكل المتدرج الموجود بالصورة
                    child: MasonryGridView.count(
                      crossAxisCount: 2,
                      mainAxisSpacing: 15,
                      crossAxisSpacing: width * 0.03,
                      padding: EdgeInsets.symmetric(
                        horizontal: width * 0.04,
                        vertical: 10,
                      ),
                      itemCount:
                          controller.data.length +
                          (controller.isLoadMore ? 1 : 0),
                      itemBuilder: (context, i) {
                        if (i == controller.data.length) {
                          return Center(
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: CircularProgressIndicator(
                                color: Appcolor.primaryColor,
                              ),
                            ),
                          );
                        }

                        final item = controller.data[i];

                        // 📌 تم إصلاح المتغيرات التي كانت تعطي أخطاء في الكود القديم
                        final double cardWidth = (width / 2) - (width * 0.04);
                        final double baseHeight = cardWidth * 1.55;
                        // نجعل الكروت الزوجية والفردية بأطوال مختلفة لعمل شكل الشلال
                        final double cardHeight = i.isEven
                            ? baseHeight
                            : baseHeight * 1.2;

                        return SharedProductCard(
                          image: "${item.itemsImage}",
                          title: "${item.itemsName}",
                          price: "${item.itemsPrice}",
                          rating: 4.8,
                          onTap: () {
                            controller.gotoitemsdatails(item);
                          },
                          actionButton: AddToCartButton(itemId: item.id!),
                          height: cardHeight,
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 🔹 دالة مساعدة لبناء أزرار الفلاتر (Sort, Price...)
  Widget _buildFilterButton(String title) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.withAlpha(60)),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.black87,
          fontWeight: FontWeight.w500,
          fontSize: 14,
        ),
      ),
    );
  }

  /// 🔹 دالة مساعدة لبناء الفلاتر المحددة (Samsung, Under $500...)
  Widget _buildActiveFilterChip(String title) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFE8EAF6), // لون أزرق فاتح جداً
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Color(0xFF3F51B5), // لون النص أزرق
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
          const SizedBox(width: 4),
          const Icon(Icons.close, size: 16, color: Color(0xFF3F51B5)),
        ],
      ),
    );
  }
}
