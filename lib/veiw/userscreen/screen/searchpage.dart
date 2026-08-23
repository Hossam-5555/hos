import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:hos/controler/usercontroller/home/Homepage_controller.dart';
import 'package:hos/core/class/crud.dart';
import 'package:hos/core/class/searchclass.dart';
import 'package:hos/core/conistant/imageasset.dart';
import 'package:hos/data/model/categoriesmodel.dart';
import 'package:hos/veiw/wedget/SharedProductCard.dart';
import 'package:hos/veiw/wedget/animation.dart';
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
          final hPad = (width * 0.045).clamp(14.0, 22.0);

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
                              ontap: () {},
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
    required this.ontap,
  });

  final SearchMix controller;
  final double hPad;
  final double width;
  final Color textPrimary;
  final Color textSecondary;
  final Color chipBg;
  final Color cardBg;
  final Color accent;
  final void Function() ontap;

  @override
  Widget build(BuildContext context) {
    final bool hasRecent = controller.recentSearches.isNotEmpty;

    // الحصول على قائمة الأقسام بأمان لتفادي الـ RangeError
    List<CategoriesModel> categories = [];
    bool isLoading = true;

    if (Get.isRegistered<HomepageController>()) {
      final homeController = Get.find<HomepageController>();
      if (homeController.categories.isNotEmpty) {
        categories = homeController.categories.length >= 4
            ? homeController.categories.sublist(0, 4)
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
            ontap: ontap,
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
    final bool isLoading = controller.statusrequest == Statusrequest.loading;
    // نقاط توقف بسيطة: هاتف صغير / هاتف عادي / تابلت
    final bool isSmallPhone = width < 360;
    final bool isTablet = width >= 600;

    // مسافات متجاوبة اعتماداً على العرض (أثبت من الطول بين الأجهزة)
    // مع حدود دنيا وقصوى عشان ماتبقاش صغيرة أوي أو كبيرة أوي
    final double horizontalPadding = (width * 0.045).clamp(12.0, 32.0);
    final double sectionSpacing = (width * 0.05).clamp(14.0, 26.0);

    // ارتفاع قائمة التصنيفات الأفقية: نسبة من العرض مش من الطول

    // عدد أعمدة الجريد: 2 للهاتف، 3 للتابلت الصغير، 4 للتابلت الكبير
    final int gridCrossAxisCount = isTablet ? (width >= 900 ? 4 : 3) : 2;
    final double gridSpacing = isSmallPhone ? 10.0 : 12.0;

    // عرض الكارت الفعلي بعد خصم الـ padding والمسافات بين الأعمدة
    final double cardWidth =
        (width -
            (horizontalPadding * 2) -
            (gridSpacing * (gridCrossAxisCount - 1))) /
        gridCrossAxisCount;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: hPad),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 10),
          Skeletonizer(
            enabled: isLoading,
            child: controller.searchlist.isEmpty && !isLoading
                ? Container(
                    alignment: Alignment.center,
                    child: Animationlottie(
                      animationPath: Imageasset.emptystate,
                      h: 200,
                      w: 200,
                    ),
                  )
                : Expanded(
                    child: MasonryGridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.symmetric(
                        vertical: sectionSpacing * 0.3,
                      ),
                      gridDelegate:
                          SliverSimpleGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: gridCrossAxisCount,
                          ),
                      mainAxisSpacing: gridSpacing + 4,
                      crossAxisSpacing: gridSpacing,
                      itemCount: controller.searchlist.length,
                      itemBuilder: (context, index) {
                        final item = controller.searchlist[index];

                        // ارتفاع الكارت نسبي لعرضه الفعلي، مش رقم ثابت،
                        // فبكده بيتصرف صح على أي مقاس شاشة
                        final double baseHeight = cardWidth * 1.55;
                        final double cardHeight = index.isEven
                            ? baseHeight
                            : baseHeight * 1.2;
                        if (isLoading) {
                          return const Card(
                            child: ListTile(
                              leading: CircleAvatar(),
                              title: Text("Loading Product Name..."),
                              subtitle: Text("Price / Details"),
                            ),
                          );
                        }
                        return SharedProductCard(
                          image: "${item.itemsImage}",
                          title: "${item.itemsName}",
                          price: "${item.itemsPrice}",
                          rating: 4.8,
                          onTap: () {
                            controller.gotoitemsdatails(item);
                          },

                          actionButton: Text(""),

                          /// 🔥 أهم سطر
                          height: cardHeight,
                        );
                      },
                    ),
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
    required this.ontap,
    required this.c,
  });

  final SearchMix c;
  final List<CategoriesModel> categories;
  final bool isLoading;
  final Color textPrimary;
  final Color accent;
  final Color cardBg;
  final Color borderColor;
  final void Function() ontap;

  @override
  Widget build(BuildContext context) {
    final bool showSkeleton =
        isLoading ||
        c.statusrequest == Statusrequest.loading ||
        c.statusrequest == Statusrequest.serverfailure;

    // إنشاء قائمة نموذجية وهمية للعرض أثناء الـ Skeleton
    final displayCategories = showSkeleton
        ? List.generate(
            4,
            (index) => CategoriesModel(id: index, name: "Loading Category"),
          )
        : categories;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Popular Categories".tr,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: textPrimary,
          ),
        ),
        const SizedBox(height: 14),
        Skeletonizer(
          enabled: showSkeleton,
          child: Column(
            children: List.generate(displayCategories.length, (index) {
              final item = displayCategories[index];
              return Column(
                children: [
                  _CategoryRow(
                    item: item,
                    textPrimary: textPrimary,
                    accent: accent,
                    ontap: ontap,
                  ),
                ],
              );
            }),
          ),
        ),
      ],
    );
  }
}

class _CategoryRow extends StatelessWidget {
  const _CategoryRow({
    required this.item,
    required this.textPrimary,
    required this.accent,
    required this.ontap,
  });

  final CategoriesModel item;
  final Color textPrimary;
  final Color accent;
  final void Function() ontap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: ontap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          children: [
            Expanded(
              child: Text(
                item.name ?? "",
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: textPrimary,
                ),
              ),
            ),
            const SizedBox(
              height: 42,
              child: Icon(Icons.trending_up_outlined, size: 22),
            ),
          ],
        ),
      ),
    );
  }
}
