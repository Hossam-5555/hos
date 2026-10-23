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
    final size = MediaQuery.of(context).size;
    final height = size.height;
    final width = size.width;

    Get.put(ItemsController());
    Get.put(FavController());

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: GetBuilder<ItemsController>(
          builder: (controller) => Appbarbackicon.nedicon(ontap: () {
            showFilterSheet(context, controller);
          },
            needicon: true,
            herotag: "items",
            title: "LUXE",
            iconButton: Transform.rotate(
              angle: 90,
              alignment: Alignment.center,
              child: SvgPicture.asset(Imageasset.filter),
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
                selectedIndex: c.selecteditem!,
                onSelected: (i) => c.changcat(i, c.categories[i].id.toString()),
              ),
            ),
            SizedBox(height: height * 0.01),
            Expanded(
              child: GetBuilder<ItemsController>(
                builder: (controller) => HandlingDataView(
                  emptyStyle: EmptyStateStyle.style2,
                  mode: HandlingMode.fullScreen,
                  mediaType: HandlingMediaType.animation,
                  showRetryButton: true,
                  statusrequest: controller.statusrequest,
                  widget: _ProductGrid(controller: controller, width: width),
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
  const _ProductGrid({required this.controller, required this.width});

  final ItemsController controller;
  final double width;

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (scrollInfo) {
        if (scrollInfo.metrics.pixels >=
            scrollInfo.metrics.maxScrollExtent - 100) {
          controller.getitems(controller.catid);
        }
        return false;
      },
      child: MasonryGridView.count(
        crossAxisCount: 2,
        mainAxisSpacing: 15,
        crossAxisSpacing: width * 0.03,
        padding: EdgeInsets.fromLTRB(width * 0.04, 0, width * 0.04, 90),
        itemCount: controller.data.length + (controller.isLoadMore ? 1 : 0),
        itemBuilder: (context, i) {
          if (i == controller.data.length) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircularProgressIndicator(color: AppColors.primaryColor),
              ),
            );
          }

          final item = controller.data[i];
          final cardWidth = (width / 2) - (width * 0.04);
          final baseHeight = cardWidth * 1.55;
          final cardHeight = i.isEven ? baseHeight : baseHeight * 1.2;

          return SharedProductCard(
            isen: controller.isarabic ? false : true,
            items: item,

            onTap: () => controller.gotoitemsdatails(item),
            actionButton: AddToCartButton(itemId: item.id!),
            height: cardHeight,
          );
        },
      ),
    );
  }
}
