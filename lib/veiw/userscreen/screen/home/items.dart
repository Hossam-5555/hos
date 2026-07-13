// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart'; // 📌 تمت إضافته لعمل شكل الشلال الموجود بالصورة
import 'package:hos/controler/usercontroller/home/favorite/fav_controller.dart';
import 'package:hos/controler/usercontroller/home/items_controler.dart';
import 'package:hos/core/class/handlingdataview.dart';
import 'package:hos/core/conistant/appcolor.dart';
import 'package:hos/core/conistant/imageasset.dart';
import 'package:hos/veiw/userscreen/screen/home/Homepage.dart';
import 'package:hos/veiw/wedget/SharedProductCard.dart';
import 'package:hos/veiw/wedget/appbarbackicon.dart';
import 'package:hos/veiw/wedget/items/filteritems.dart';
import 'package:hos/veiw/wedget/items/itemslist.dart';

class Items extends StatelessWidget {
  const Items({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final height = size.height;
    final width = size.width;

    ItemsController controller = Get.put(ItemsController());
    Get.put(FavController());

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: GetBuilder<ItemsController>(
          builder: (controller) =>
              Appbarbackicon(herotag: "items", title: "LUXE"),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(width: 5),
                GestureDetector(
                  onTap: () => showFilterDialog(context, controller),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(
                        context,
                      ).colorScheme.primary.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Theme.of(
                          context,
                        ).colorScheme.primary.withOpacity(0.15),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SvgPicture.asset(
                          Imageasset.category,
                          height: 18,
                          width: 18,
                          colorFilter: ColorFilter.mode(
                            Theme.of(context).colorScheme.primary,
                            BlendMode.srcIn,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          "Filter",
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

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
                  controller.indexofcategrry = i;
                  return BuildCategoryItems(
                    catmodel: catmodel,
                    urlIcon: icon,
                    i: i,
                  );
                },
              ),
            ),

            const SizedBox(height: 12),

            /// 🛍 شبكة العناصر (المنتجات) بالشكل المتدرج (Masonry)
            Expanded(
              child: GetBuilder<ItemsController>(
                builder: (controller) => HandlingDataView(
                  mode: HandlingMode.fullScreen,
                  mediaType: HandlingMediaType.svgImage,
                  showRetryButton: true,
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
}
