import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hos/core/class/searchclass.dart';
import 'package:hos/core/conistant/imageasset.dart';
import 'package:hos/veiw/wedget/animation.dart';
import 'package:hos/veiw/wedget/saerch/productcard.dart';
import 'package:hos/veiw/wedget/searchbar.dart';

// ==========================================================
// Trending Now — بيانات ثابتة حالياً.
// لما يبقى فيه API، كفاية تستبدل الـ list دي بـ mapping من الـ
// response بنفس الشكل (title / subtitle / imageUrl) والـ UI
// مش هيتغير خالص.
// ==========================================================
class _TrendingItem {
  final String title;
  final String subtitle;
  final String imageUrl;
  const _TrendingItem({
    required this.title,
    required this.subtitle,
    required this.imageUrl,
  });
}

const _trendingHero = _TrendingItem(
  title: "Smartwatches",
  subtitle: "Top tier wearables",
  imageUrl:
      "https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=800&q=80",
);

const List<_TrendingItem> _trendingGrid = [
  _TrendingItem(
    title: "Gaming Laptops",
    subtitle: "Ultimate performance",
    imageUrl:
        "https://images.unsplash.com/photo-1603302576837-37561b2e2302?w=600&q=80",
  ),
  _TrendingItem(
    title: "Pro Cameras",
    subtitle: "Capture every detail",
    imageUrl:
        "https://images.unsplash.com/photo-1516035069371-29a1b244cc32?w=600&q=80",
  ),
];

// ignore: must_be_immutable
class Searchpage extends StatelessWidget {
  Searchpage({super.key});

  final controller = Get.put(SearchMix());

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
        : const Color(0xFFF1F0ED);

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

    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(hPad, 20, hPad, 24),
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
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

          // ───────────── Trending Now ─────────────
          Row(
            children: [
              Icon(Icons.trending_up_rounded, color: textPrimary, size: 20),
              const SizedBox(width: 8),
              Text(
                "Trending Now".tr,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Hero card
          _TrendingHeroCard(item: _trendingHero, width: width, accent: accent),
          const SizedBox(height: 14),

          // Grid cards
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _trendingGrid.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 14,
              mainAxisSpacing: 14,
              childAspectRatio: 0.95,
            ),
            itemBuilder: (context, index) {
              return _TrendingTile(
                item: _trendingGrid[index],
                cardBg: cardBg,
                textPrimary: textPrimary,
              );
            },
          ),
          const SizedBox(height: 28),
          PopularCategoriesSection(
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

class _TrendingHeroCard extends StatelessWidget {
  const _TrendingHeroCard({
    required this.item,
    required this.width,
    required this.accent,
  });

  final _TrendingItem item;
  final double width;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final double height = (width * 0.42).clamp(150.0, 220.0);

    return ClipRRect(
      borderRadius: BorderRadius.circular(22),
      child: SizedBox(
        height: height,
        width: double.infinity,
        child: Stack(
          fit: StackFit.expand,
          children: [
            CachedNetworkImage(
              imageUrl: item.imageUrl,
              fit: BoxFit.cover,
              placeholder: (_, __) => Container(color: Colors.grey.shade300),
              errorWidget: (_, __, ___) =>
                  Container(color: Colors.grey.shade400),
            ),
            // تظليل تدريجي أسفل الصورة عشان النص يبان بوضوح
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(0.0),
                      Colors.black.withOpacity(0.55),
                    ],
                    stops: const [0.4, 1.0],
                  ),
                ),
              ),
            ),
            Positioned(
              left: 18,
              bottom: 18,
              right: 70,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    item.subtitle,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.85),
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              right: 16,
              bottom: 16,
              child: Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: accent,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.arrow_forward_rounded,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TrendingTile extends StatelessWidget {
  const _TrendingTile({
    required this.item,
    required this.cardBg,
    required this.textPrimary,
  });

  final _TrendingItem item;
  final Color cardBg;
  final Color textPrimary;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: Container(
        color: cardBg,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            image: DecorationImage(
              image: CachedNetworkImageProvider(item.imageUrl),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                Colors.white.withOpacity(0.15),
                BlendMode.darken,
              ),
            ),
          ),
          child: Container(
            margin: const EdgeInsets.only(left: 12, right: 12, bottom: 12),

            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Color.fromARGB(255, 255, 255, 255),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  item.subtitle,
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade200),
                ),
              ],
            ),
          ),
        ),
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
class PopularCategoryItem {
  final String title;
  final VoidCallback? onTap;

  const PopularCategoryItem({required this.title, this.onTap});
}

const List<PopularCategoryItem> popularCategories = [
  PopularCategoryItem(title: "Smartphones"),
  PopularCategoryItem(title: "Laptops & Computers"),
  PopularCategoryItem(title: "TV & Home Theater"),
  PopularCategoryItem(title: "Gaming Consoles"),
];

class PopularCategoriesSection extends StatelessWidget {
  const PopularCategoriesSection({
    super.key,
    this.categories = popularCategories,
    required this.textPrimary,
    required this.accent,
    required this.cardBg,
    required this.borderColor,
  });

  final List<PopularCategoryItem> categories;
  final Color textPrimary;
  final Color accent;
  final Color cardBg;
  final Color borderColor;

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
        Container(
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: borderColor),
          ),
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

class _CategoryRow extends StatelessWidget {
  const _CategoryRow({
    required this.item,
    required this.textPrimary,
    required this.accent,
  });

  final PopularCategoryItem item;
  final Color textPrimary;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: item.onTap,
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
                item.title.tr,
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
