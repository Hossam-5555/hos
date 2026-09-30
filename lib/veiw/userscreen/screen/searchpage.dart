import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:hos/controler/usercontroller/home/homepage_controller.dart';
import 'package:hos/core/class/crud.dart';
import 'package:hos/core/class/searchclass.dart';
import 'package:hos/core/conistant/imageasset.dart';
import 'package:hos/data/model/categoriesmodel.dart';
import 'package:hos/data/model/itemsmodel.dart';
import 'package:hos/veiw/userscreen/screen/home/home_page.dart';
import 'package:hos/veiw/wedget/shared_product_card.dart';
import 'package:hos/veiw/wedget/animation.dart';
import 'package:hos/veiw/wedget/items/itemslist.dart';
import 'package:hos/veiw/wedget/searchbar.dart';
import 'package:skeletonizer/skeletonizer.dart';

class Searchpage extends StatelessWidget {
  Searchpage({super.key});

  final controller = Get.put(SearchMix());

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final Color accent = const Color(0xFF3E5FFF);
    final Color textPrimary = isDark ? Colors.white : const Color(0xFF16181D);
    final Color textSecondary = isDark
        ? Colors.grey.shade400
        : Colors.grey.shade600;
    final Color chipBg = isDark
        ? Colors.white.withOpacity(0.08)
        : const Color(0xFFF1F0ED);
    final Color cardBg = isDark
        ? Colors.white.withOpacity(0.06)
        : const Color.fromARGB(255, 255, 253, 253);

    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;
          final hPad = (width * 0.035).clamp(14.0, 20.0);

          return GetBuilder<SearchMix>(
            builder: (controller) {
              final bool isSearching = controller.search!.text.isNotEmpty;

              return SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: hPad),
                      child: Searchbar(
                        focusNode: controller.focusNode,
                        textInputAction: controller.textInputAction,
                        onPressedIcon: () {
                          controller.addToRecentSearches(
                            controller.search!.text,
                          );
                          controller.onsearch();
                        },
                        onChanged: controller.checksearch,
                        title: "Search products...".tr,
                        mycontroller: controller.search!,
                      ),
                    ),
                    const SizedBox(height: 15),

                    Expanded(
                      child: isSearching
                          ? _SearchResults(
                              width: width,
                              controller: controller,
                              hPad: hPad,
                              textSecondary: textSecondary,
                            )
                          : _IdleState(
                              controller: controller,
                              hPad: hPad,
                              width: width,
                              textPrimary: textPrimary,
                              textSecondary: textSecondary,
                              chipBg: chipBg,
                              cardBg: cardBg,
                              accent: accent,
                            ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class _IdleState extends StatelessWidget {
  const _IdleState({
    required this.controller,
    required this.hPad,
    required this.width,
    required this.textPrimary,
    required this.textSecondary,
    required this.chipBg,
    required this.cardBg,
    required this.accent,
  });

  final SearchMix controller;
  final double hPad;
  final double width;
  final Color textPrimary;
  final Color textSecondary;
  final Color chipBg;
  final Color cardBg;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final bool hasRecent = controller.recentSearches.isNotEmpty;

    // الحصول على قائمة الأقسام بأمان لتفادي الـ RangeError
    List<CategoriesModel> categories = [];
    bool isLoading = true;

    if (Get.isRegistered<HomepageController>()) {
      final homeController = Get.find<HomepageController>();
      if (homeController.categories.isNotEmpty) {
        categories = homeController.categories.length >= 6
            ? homeController.categories.sublist(0, 6)
            : homeController.categories;
        isLoading = false;
      }
    }

    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(hPad, 20, hPad, 24),
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (hasRecent) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Recent Searches".tr,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: textPrimary,
                  ),
                ),
                InkWell(
                  onTap: controller.clearRecentSearches,
                  child: Text(
                    "Clear All".tr,
                    style: TextStyle(color: textSecondary, fontSize: 13),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              children: List.generate(controller.recentSearches.length, (
                index,
              ) {
                final term = controller.recentSearches[index];
                return ActionChip(
                  label: Text(
                    term,
                    style: TextStyle(fontSize: 13, color: textPrimary),
                  ),
                  backgroundColor: chipBg,
                  side: BorderSide.none,
                  avatar: Icon(Icons.history, size: 16, color: textSecondary),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  onPressed: () {
                    controller.search!.text = term;
                    controller.addToRecentSearches(term);
                    controller.onsearch();
                  },
                );
              }),
            ),
            const SizedBox(height: 28),
          ],

          PopularCategoriesSection(
            c: controller,
            categories: categories,
            isLoading: isLoading,
            textPrimary: textPrimary,
            accent: accent,
            cardBg: cardBg,
            borderColor: context.isDarkMode
                ? Colors.white.withOpacity(0.08)
                : Colors.grey.withOpacity(0.15),
          ),
        ],
      ),
    );
  }
}

class _SearchResults extends StatelessWidget {
  const _SearchResults({
    required this.controller,
    required this.hPad,
    required this.textSecondary,
    required this.width,
  });

  final SearchMix controller;
  final double hPad;
  final Color textSecondary;
  final double width;

  @override
  Widget build(BuildContext context) {
    final status = controller.statusrequest;

    final bool isLoading = status == Statusrequest.loading;

    final bool isError =
        status == Statusrequest.serverfailure ||
        status == Statusrequest.failure;

    final bool isEmpty =
        !isLoading && !isError && controller.searchlist.isEmpty;

    // Responsive
    final bool isSmallPhone = width < 360;
    final bool isTablet = width >= 600;

    final int crossAxisCount = isTablet ? (width >= 900 ? 4 : 3) : 2;

    final double spacing = isSmallPhone ? 9 : 12;

    final double horizontalPadding = width >= 600 ? 24 : 14;

    final double cardWidth =
        (width - (horizontalPadding * 2) - (spacing * (crossAxisCount - 1))) /
        crossAxisCount;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),

          // =========================
          // Result Header
          // =========================
          if (!isLoading && !isError) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  isEmpty
                      ? "No Products Found".tr
                      : "${controller.searchlist.length} Products Found".tr,
                  style: TextStyle(
                    fontSize: isTablet ? 18 : 16,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white
                        : const Color(0xFF16181D),
                  ),
                ),

                if (!isEmpty)
                  Text(
                    "Search Results".tr,
                    style: TextStyle(fontSize: 12, color: textSecondary),
                  ),
              ],
            ),

            const SizedBox(height: 14),
          ],

          // =========================
          // Loading
          // =========================
          if (isLoading)
            Expanded(
              child: Skeletonizer(
                enabled: true,
                child: MasonryGridView.builder(
                  padding: const EdgeInsets.only(top: 8, bottom: 24),
                  gridDelegate: SliverSimpleGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                  ),
                  mainAxisSpacing: spacing,
                  crossAxisSpacing: spacing,
                  itemCount: 6,
                  itemBuilder: (context, index) {
                    final double baseHeight = cardWidth * 1.55;

                    return SharedProductCard(
                      isen: false,
                      items: ItemsModel(
                        id: 0,
                        itemsImage: "",
                        itemsName: '',
                        itemsNameAr: '',
                        itemsPrice: 200
                      ),

                      onTap: () {},
                      actionButton: const SizedBox(),
                      height: index.isEven ? baseHeight : baseHeight * 1.15,
                    );
                  },
                ),
              ),
            )
          // =========================
          // Error
          // =========================
          else if (isError)
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.cloud_off_rounded,
                        size: 64,
                        color: textSecondary,
                      ),

                      const SizedBox(height: 16),

                      Text(
                        "Something went wrong".tr,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.white
                              : const Color(0xFF16181D),
                        ),
                      ),

                      const SizedBox(height: 8),

                      Text(
                        "We couldn't load the search results. Please try again."
                            .tr,
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 14, color: textSecondary),
                      ),

                      const SizedBox(height: 20),

                      ElevatedButton.icon(
                        onPressed: controller.onsearch,
                        icon: const Icon(Icons.refresh_rounded),
                        label: Text("Try Again".tr),
                      ),
                    ],
                  ),
                ),
              ),
            )
          // =========================
          // Empty
          // =========================
          else if (isEmpty)
            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Animationlottie(
                        animationPath: Imageasset.emptystate,
                        h: isTablet ? 240 : 190,
                        w: isTablet ? 240 : 190,
                      ),

                      const SizedBox(height: 10),

                      Text(
                        "No products found".tr,
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.white
                              : const Color(0xFF16181D),
                        ),
                      ),

                      const SizedBox(height: 6),

                      Text(
                        "Try searching with another name or category.".tr,
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 13, color: textSecondary),
                      ),
                    ],
                  ),
                ),
              ),
            )
          // =========================
          // Results
          // =========================
          else
            Expanded(
              child: MasonryGridView.builder(
                padding: const EdgeInsets.only(top: 4, bottom: 24),
                physics: const BouncingScrollPhysics(),
                gridDelegate: SliverSimpleGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                ),
                mainAxisSpacing: spacing,
                crossAxisSpacing: spacing,
                itemCount: controller.searchlist.length,
                itemBuilder: (context, index) {
                  final item = controller.searchlist[index];

                  final double baseHeight = cardWidth * 1.55;

                  final double cardHeight = index.isEven
                      ? baseHeight
                      : baseHeight * 1.15;

                  return SharedProductCard(
                    isen: controller.lang == "en" ? true : false,
                    items: item,

                    onTap: () {
                      controller.gotoitemsdatails(item);
                    },
                    actionButton: AddToCartButton(itemId: item.id!),
                    height: cardHeight,
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}

class PopularCategoriesSection extends StatelessWidget {
  const PopularCategoriesSection({
    super.key,
    required this.categories,
    required this.isLoading,
    required this.textPrimary,
    required this.accent,
    required this.cardBg,
    required this.borderColor,
    required this.c,
  });

  final SearchMix c;
  final List<CategoriesModel> categories;
  final bool isLoading;
  final Color textPrimary;
  final Color accent;
  final Color cardBg;
  final Color borderColor;
  // final void Function() ontap;

  @override
  Widget build(BuildContext context) {
    final bool showSkeleton =
        isLoading ||
        c.statusrequest == Statusrequest.loading ||
        c.statusrequest == Statusrequest.serverfailure;

    // إنشاء قائمة نموذجية وهمية للعرض أثناء الـ Skeleton
    final displayCategories = showSkeleton
        ? List.generate(
            6,
            (index) => CategoriesModel(id: index, name: "Loading Cat"),
          )
        : categories;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Skeletonizer(
          enabled: showSkeleton,
          child: Text(
            "Popular Categories".tr,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: textPrimary,
            ),
          ),
        ),

        const SizedBox(height: 14),
        Skeletonizer(
          enabled: showSkeleton,
          child: Wrap(
            children: List.generate(displayCategories.length, (index) {
              final item = displayCategories[index];
              return BuildCategoryItems(
                isen: c.lang == "en" ? true : false,
                catmodel: item,
                isSelected: true,
                onTap: () {
                  c.search!.text = item.name!;
                  c.onsearch();
                },
              );
            }),
          ),
        ),
      ],
    );
  }
}
