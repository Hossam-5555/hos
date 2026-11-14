import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:hos/controler/usercontroller/home/favorite/fav_controller.dart';
import 'package:hos/controler/usercontroller/home/items_controler.dart';
import 'package:hos/core/class/handlingdataview.dart';
import 'package:hos/core/conistant/app_colors.dart';
import 'package:hos/core/conistant/imageasset.dart';
import 'package:hos/veiw/userscreen/screen/home/home_page.dart';
import 'package:hos/veiw/wedget/shared_product_card.dart';
import 'package:hos/veiw/wedget/appbarbackicon.dart';
import 'package:hos/veiw/wedget/items/filteritems.dart';
import 'package:hos/veiw/wedget/items/itemslist.dart';

class Items extends StatelessWidget {
  const Items({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final height = size.height;
    final width = size.width;

    Get.put(ItemsController());
    Get.put(FavController());

    // ارتفاع متجاوب للـ AppBar بحد أدنى وأقصى آمن
    final double appBarHeight = (height * 0.075).clamp(54.0, 72.0);
    final double filterIconSize = (width * 0.055).clamp(20.0, 26.0);

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(appBarHeight),
        child: GetBuilder<ItemsController>(
          builder: (controller) => Appbarbackicon.nedicon(
            ontap: () {
              showFilterSheet(context, controller);
            },
            needicon: true,
            herotag: "items",
            title: "LUXE",
            iconButton: Transform.rotate(
              angle: math.pi / 2, // زاوية 90 درجة دقيقة بالراديان
              alignment: Alignment.center,
              child: SvgPicture.asset(
                Imageasset.filter,
                width: filterIconSize,
                height: filterIconSize,
              ),
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            GetBuilder<ItemsController>(
              builder: (c) => ChipsBar(
                labels: c.categories
                    .map((cat) => (c.isarabic ? cat.nameAr : cat.name) ?? "")
                    .toList(),
                selectedIndex: c.selecteditem ?? 0,
                onSelected: (i) => c.changcat(i, c.categories[i].id.toString()),
              ),
            ),
            SizedBox(height: (height * 0.012).clamp(6.0, 14.0)),
            Expanded(
              child: GetBuilder<ItemsController>(
                builder: (controller) => HandlingDataView(
                  emptyStyle: EmptyStateStyle.style2,
                  mode: HandlingMode.fullScreen,
                  mediaType: HandlingMediaType.animation,
                  showRetryButton: true,
                  statusrequest: controller.statusrequest,
                  widget: _ProductGrid(
                    controller: controller,
                    screenHeight: height,
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

class _ProductGrid extends StatelessWidget {
  const _ProductGrid({
    required this.controller,
    required this.screenHeight,
  });

  final ItemsController controller;
  final double screenHeight;

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (scrollInfo) {
        if (scrollInfo.metrics.pixels >=
            scrollInfo.metrics.maxScrollExtent - (screenHeight * 0.15)) {
          controller.getitems(controller.catid);
        }
        return false;
      },
      child: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;

          // نقاط التوقف: هاتف صغير / هاتف عادي / تابلت صغير / تابلت كبير
          final bool isTablet = width >= 600;
          final int gridCrossAxisCount = isTablet ? (width >= 900 ? 4 : 3) : 2;

          // مسافات متجاوبة كنسبة من العرض مع حدود آمنة
          final double horizontalPadding = (width * 0.04).clamp(12.0, 32.0);
          final double crossAxisSpacing = (width * 0.01).clamp(10.0, 22.0);
          final double bottomPadding = (screenHeight * 0.11).clamp(75.0, 120.0);

          // المعادلة الدقيقة لحساب العرض الفعلي للكارت الواحد بناءً على عدد الأعمدة
          final double totalHorizontalSpacing =
              (horizontalPadding * 2) +
              (crossAxisSpacing * (gridCrossAxisCount - 1));
          final double actualCardWidth =
              (width - totalHorizontalSpacing) / gridCrossAxisCount;

          // حساب الارتفاع المتناسب مع العرض الفعلي (أقل قليلاً في التابلت حتى لا يطول الكارت زيادة)
          final double heightAspectRatio = isTablet ? 1.42 : 1.52;
          final double baseHeight = actualCardWidth * heightAspectRatio;

          return MasonryGridView.count(
            crossAxisCount: gridCrossAxisCount,
            mainAxisSpacing: crossAxisSpacing,
            crossAxisSpacing: crossAxisSpacing,
            padding: EdgeInsets.fromLTRB(
              horizontalPadding,
              (screenHeight * 0.005).clamp(4.0, 10.0),
              horizontalPadding,
              bottomPadding,
            ),
            itemCount: controller.data.length + (controller.isLoadMore ? 1 : 0),
            itemBuilder: (context, i) {
              if (i == controller.data.length) {
                return Center(
                  child: Padding(
                    padding: EdgeInsets.all((width * 0.025).clamp(8.0, 16.0)),
                    child: CircularProgressIndicator(
                      color: AppColors.primaryColor,
                    ),
                  ),
                );
              }

              final item = controller.data[i];
              // التفاوت الطفيف في الطول لإعطاء شكل الـ Masonry الانسيابي
              final double cardHeight = i.isEven ? baseHeight : baseHeight * 1.15;

              return SharedProductCard(
                isen: !controller.isarabic,
                items: item,
                onTap: () => controller.gotoitemsdatails(item),
                actionButton: AddToCartButton(itemId: item.id!),
                height: cardHeight,
              );
            },
          );
        },
      ),
    );
  }
}