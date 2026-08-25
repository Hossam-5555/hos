// ignore_for_file: deprecated_member_use

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
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

    final controller = Get.put(ItemsController());
    Get.put(FavController());

    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: _FilterButton(
        bottomMargin: height * 0.02,
        onTap: () => showFilterSheet(context, controller),
      ),
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
            _CategoryBar(controller: controller, height: height, width: width),

            Expanded(
              child: GetBuilder<ItemsController>(
                builder: (controller) => HandlingDataView(
                  mode: HandlingMode.fullScreen,
                  mediaType: HandlingMediaType.svgImage,
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

class _CategoryBar extends StatelessWidget {
  const _CategoryBar({
    required this.controller,
    required this.height,
    required this.width,
  });

  final ItemsController controller;
  final double height;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: height * 0.01, bottom: height * 0.01),
      height: height * 0.07,
      width: width,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: width * 0.02),
        itemCount: controller.categories.length,
        itemBuilder: (_, i) {
          final catmodel = controller.categories[i];
          controller.indexofcategrry = i;
          return GetBuilder<ItemsController>(
            builder: (controller) {
              return BuildCategoryItems(
                catmodel: catmodel,

                isSelected: controller.selecteditem == i,

                onTap: () {
                  controller.changcat(i, catmodel.id.toString());
                },
              );
            },
          );
        },
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
                child: CircularProgressIndicator(color: Appcolor.primaryColor),
              ),
            );
          }

          final item = controller.data[i];
          final cardWidth = (width / 2) - (width * 0.04);
          final baseHeight = cardWidth * 1.55;
          final cardHeight = i.isEven ? baseHeight : baseHeight * 1.2;

          return SharedProductCard(
            image: "${item.itemsImage}",
            title: "${item.itemsName}",
            price: "${item.itemsPrice}",
            rating: 4.8,
            onTap: () => controller.gotoitemsdatails(item),
            actionButton: AddToCartButton(itemId: item.id!),
            height: cardHeight,
          );
        },
      ),
    );
  }
}

class _FilterButton extends StatelessWidget {
  const _FilterButton({required this.onTap, required this.bottomMargin});

  final VoidCallback onTap;
  final double bottomMargin;

  @override
  Widget build(BuildContext context) {
    final primary = Colors.grey;

    return Container(
      margin: EdgeInsets.only(bottom: bottomMargin, right: 16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: Material(
            color: const Color.fromARGB(255, 161, 156, 156).withOpacity(0.15),
            borderRadius: BorderRadius.circular(30),
            child: InkWell(
              borderRadius: BorderRadius.circular(30),
              onTap: onTap,
              child: Container(
                height: 52,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: Colors.grey.withOpacity(.22)),
                  boxShadow: [
                    BoxShadow(
                      color: primary.withOpacity(0.25),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SvgPicture.asset(Imageasset.filter, width: 18, height: 18),
                    const SizedBox(width: 8),
                    Text(
                      "Filter",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
