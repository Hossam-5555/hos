import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hos/controler/usercontroller/home/Homepage_controller.dart';
import 'package:hos/core/class/crud.dart';
import 'package:hos/core/class/searchclass.dart';
import 'package:hos/core/conistant/imageasset.dart';
import 'package:hos/data/model/categoriesmodel.dart';
import 'package:hos/veiw/wedget/animation.dart';
import 'package:hos/veiw/wedget/saerch/productcard.dart';
import 'package:hos/veiw/wedget/searchbar.dart';
import 'package:skeletonizer/skeletonizer.dart';

// ignore: must_be_immutable
class Searchpage extends StatelessWidget {
  Searchpage({super.key});

  final controller = Get.put(SearchMix());
  // final home = Get.find<HomepageController>();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // ألوان الصفحة — متسقة مع Dark/Light Mode
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
                    // ───────────── Search Bar (ثابت مش بيسكرول) ─────────────
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
                    SizedBox(height: 15),

                    Expanded(
                      child: isSearching
                          ? _SearchResults(
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
                              ontap: () {
                                // home.gotoitems(
                                //   home.categories,
                                //   0,
                                //   home.categories[0].id.toString(),
                                // );
                              },
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

// ==========================================================
// حالة عدم البحث: Recent Searches + Trending Now
// ==========================================================
// ignore: must_be_immutable
class _IdleState extends StatelessWidget {
  _IdleState({
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
  void Function() ontap;
  @override
  Widget build(BuildContext context) {
    final bool hasRecent = controller.recentSearches.isNotEmpty;

    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(hPad, 20, hPad, 24),
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ───────────── Recent Searches ─────────────
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

          const SizedBox(height: 28),
          PopularCategoriesSection(
            c: controller,
            categories: Get.find<HomepageController>().categories.sublist(0, 4),
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

// ==========================================================
// حالة البحث: عدد النتائج + الليست
// ==========================================================
class _SearchResults extends StatelessWidget {
  const _SearchResults({
    required this.controller,
    required this.hPad,
    required this.textSecondary,
  });

  final SearchMix controller;
  final double hPad;
  final Color textSecondary;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: hPad),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 10),
          controller.searchlist.isEmpty && controller.issearch == true
              ? Container(
                  alignment: Alignment.center,

                  child: Animationlottie(
                    animationPath: Imageasset.emptystate,
                    h: 200,
                    w: 200,
                  ),
                )
              : Expanded(
                  child: ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.only(top: 4, bottom: 20),
                    itemCount: controller.searchlist.length,
                    itemBuilder: (context, i) {
                      final item = controller.searchlist[i];
                      return SearchProductCard(
                        item: item,
                        onTap: () => controller.gotoitemsdatails(item),
                      );
                    },
                  ),
                ),
        ],
      ),
    );
  }
}

// ==========================================================
// بيانات ثابتة حالياً — نفس فكرة Trending Now بالظبط.
// لو جهزت API بعدين كفاية تستبدل الـ list دي بـ .map() من
// الـ response، والـ UI مش هيتغير.
// ==========================================================

// ignore: must_be_immutable
class PopularCategoriesSection extends StatelessWidget {
  PopularCategoriesSection({
    super.key,
    required this.categories,
    required this.textPrimary,
    required this.accent,
    required this.cardBg,
    required this.borderColor,
    required this.ontap,
    required this.c,
  });
  SearchMix c;
  final List<CategoriesModel> categories;
  final Color textPrimary;
  final Color accent;
  final Color cardBg;
  final Color borderColor;
  void Function() ontap;
  @override
  Widget build(BuildContext context) {
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
          enabled:
              c.statusrequest == Statusrequest.loading ||
              c.statusrequest == Statusrequest.serverfailure,
          child: Column(
            children: List.generate(categories.length, (index) {
              final item = categories[index];
              final bool isLast = index == categories.length - 1;
              return Column(
                children: [
                  _CategoryRow(
                    item: item,
                    textPrimary: textPrimary,
                    accent: accent,
                    ontap: ontap,
                  ),
                  if (!isLast) Divider(height: 1, color: borderColor),
                ],
              );
            }),
          ),
        ),
      ],
    );
  }
}

// ignore: must_be_immutable
class _CategoryRow extends StatelessWidget {
  _CategoryRow({
    required this.item,
    required this.textPrimary,
    required this.accent,
    required this.ontap,
  });

  final CategoriesModel item;
  final Color textPrimary;
  final Color accent;
  void Function() ontap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: ontap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          children: [
            Container(
              height: 42,
              child: Icon(Icons.trending_up_outlined, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                item.name!,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: textPrimary,
                ),
              ),
            ),
            Icon(Icons.chevron_right_rounded, size: 22),
          ],
        ),
      ),
    );
  }
}
