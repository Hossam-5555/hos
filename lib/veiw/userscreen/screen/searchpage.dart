import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:hos/controler/usercontroller/home/homepage_controller.dart';
import 'package:hos/core/class/crud.dart';
import 'package:hos/core/class/handlingdataview.dart';
import 'package:hos/core/class/searchclass.dart';
import 'package:hos/core/conistant/imageasset.dart';
import 'package:hos/data/model/categoriesmodel.dart';
import 'package:hos/veiw/userscreen/screen/home/home_page.dart';
import 'package:hos/veiw/wedget/shared_product_card.dart';
import 'package:hos/veiw/wedget/items/itemslist.dart';
import 'package:hos/veiw/wedget/searchbar.dart';
import 'package:skeletonizer/skeletonizer.dart';

/// Max width of the page content (keeps layout sane on tablets / web).
const double _kMaxContentWidth = 1200;

class Searchpage extends StatelessWidget {
  Searchpage({super.key});

  final controller = Get.put(SearchMix());

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    const Color accent = Color(0xFF3E5FFF);
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
      body: SafeArea(
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: _kMaxContentWidth),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final width = constraints.maxWidth;

                // One horizontal padding for the whole page
                final double hPad = width >= 900
                    ? 32
                    : width >= 600
                    ? 24
                    : (width * 0.035).clamp(14.0, 20.0);

                return GetBuilder<SearchMix>(
                  builder: (controller) {
                    final bool isSearching = controller.search!.text.isNotEmpty;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 8),
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
                              // HandlingDataView handles loading / error /
                              // empty. _SearchResults only draws the data.
                              ? HandlingDataView(
                                  emptyStyle: EmptyStateStyle.style2,
                                  imagePath: Imageasset.emptystate,
                                  mediaType: HandlingMediaType.animation,
                                  statusrequest: controller.statusrequest,
                                  widget: _SearchResults(
                                    controller: controller,
                                    hPad: hPad,
                                    textPrimary: textPrimary,
                                    textSecondary: textSecondary,
                                  ),
                                )
                              : _IdleState(
                                  controller: controller,
                                  hPad: hPad,
                                  textPrimary: textPrimary,
                                  textSecondary: textSecondary,
                                  chipBg: chipBg,
                                  cardBg: cardBg,
                                  accent: accent,
                                ),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

// =============================================================
// Idle state (recent searches + popular categories)
// =============================================================
class _IdleState extends StatelessWidget {
  const _IdleState({
    required this.controller,
    required this.hPad,
    required this.textPrimary,
    required this.textSecondary,
    required this.chipBg,
    required this.cardBg,
    required this.accent,
  });

  final SearchMix controller;
  final double hPad;
  final Color textPrimary;
  final Color textSecondary;
  final Color chipBg;
  final Color cardBg;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final bool hasRecent = controller.recentSearches.isNotEmpty;

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
      padding: EdgeInsets.fromLTRB(hPad, 12, hPad, 24),
      physics: const BouncingScrollPhysics(),
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (hasRecent) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    "Recent Searches".tr,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: textPrimary,
                    ),
                  ),
                ),
                InkWell(
                  onTap: controller.clearRecentSearches,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 4,
                      vertical: 6,
                    ),
                    child: Text(
                      "Clear All".tr,
                      style: TextStyle(color: textSecondary, fontSize: 13),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: controller.recentSearches.map((term) {
                return ConstrainedBox(
                  // long terms never overflow the screen
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.8,
                  ),
                  child: ActionChip(
                    label: Text(
                      term,
                      overflow: TextOverflow.ellipsis,
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
                  ),
                );
              }).toList(),
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

// =============================================================
// Results (only rendered when HandlingDataView says data is ready)
// =============================================================
class _SearchResults extends StatelessWidget {
  const _SearchResults({
    required this.controller,
    required this.hPad,
    required this.textPrimary,
    required this.textSecondary,
  });

  final SearchMix controller;
  final double hPad;
  final Color textPrimary;
  final Color textSecondary;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Real width available for the grid (after page padding)
        final double width = constraints.maxWidth - (hPad * 2);

        final bool isTablet = constraints.maxWidth >= 600;
        final bool isSmallPhone = constraints.maxWidth < 360;

        // ~190px per card, between 2 and 6 columns
        final int crossAxisCount = (width / 190).floor().clamp(2, 6);
        final double spacing = isSmallPhone ? 9 : 12;

        final double cardWidth =
            (width - (spacing * (crossAxisCount - 1))) / crossAxisCount;
        final double baseHeight = cardWidth * 1.55;

        return Padding(
          padding: EdgeInsets.symmetric(horizontal: hPad),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Text(
                      "${controller.searchlist.length} Products Found".tr,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: isTablet ? 18 : 16,
                        fontWeight: FontWeight.bold,
                        color: textPrimary,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "Search Results".tr,
                    style: TextStyle(fontSize: 12, color: textSecondary),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Expanded(
                child: NotificationListener<ScrollNotification>(
                  onNotification: (scrollInfo) {
                    // Load next page before the user reaches the end
                    if (scrollInfo.metrics.pixels >=
                        scrollInfo.metrics.maxScrollExtent - 200) {
                      controller.getsearchdata();
                    }
                    return false;
                  },
                  child: MasonryGridView.builder(
                    padding: const EdgeInsets.only(top: 4, bottom: 24),
                    physics: const BouncingScrollPhysics(),
                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.onDrag,
                    gridDelegate:
                        SliverSimpleGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxisCount,
                        ),
                    mainAxisSpacing: spacing,
                    crossAxisSpacing: spacing,
                    itemCount:
                        controller.searchlist.length +
                        (controller.isSearchLoadingMore ? 1 : 0),
                    itemBuilder: (context, index) {
                      // Bottom loader while the next page is fetched
                      if (index == controller.searchlist.length) {
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.all(12),
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }

                      final item = controller.searchlist[index];
                      final double cardHeight = index.isEven
                          ? baseHeight
                          : baseHeight * 1.15;

                      return SharedProductCard(
                        isen: controller.isarabic ? false : true,
                        items: item,
                        onTap: () => controller.gotoitemsdatails(item),
                        actionButton: AddToCartButton(itemId: item.id!),
                        height: cardHeight,
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// =============================================================
// Popular categories
// =============================================================
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

  @override
  Widget build(BuildContext context) {
    final bool showSkeleton =
        isLoading ||
        c.statusrequest == Statusrequest.loading ||
        c.statusrequest == Statusrequest.serverfailure;

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
            children: displayCategories.map((item) {
              return AppChip(
                label: (c.isarabic ? item.nameAr : item.name) ?? "",
                isSelected: false,
                onTap: () {
                  c.search!.text = item.name!;
                  c.onsearch();
                },
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
