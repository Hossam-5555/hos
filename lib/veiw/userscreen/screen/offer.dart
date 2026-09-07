import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hos/controler/usercontroller/home/favorite/fav_controller.dart';
import 'package:hos/controler/usercontroller/offercontroller.dart';
import 'package:hos/core/class/handlingdataview.dart';
import 'package:hos/data/model/itemsmodel.dart';
import 'package:hos/veiw/wedget/SharedProductCard.dart';
import 'package:hos/veiw/wedget/appbarbackicon.dart';

import 'home/Homepage.dart';

class Offer extends StatelessWidget {
  const Offer({super.key});

  @override
  Widget build(BuildContext context) {
    // تهيئة الكنترولرز
    Get.put(Offercontroller());
    Get.put(FavController());

    return Scaffold(
      appBar: Appbarbackicon(title: "offer", herotag: "offer"),
      body: GetBuilder<Offercontroller>(
        builder: (controller) {
          return RefreshIndicator(
            color: const Color.fromARGB(255, 8, 110, 150),
            onRefresh: () async => controller.getoffer(),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final width = constraints.maxWidth;

                final bool isSmallPhone = width < 360;
                final bool isTablet = width >= 600;

                final double horizontalPadding = (width * 0.045).clamp(
                  12.0,
                  32.0,
                );

                final int gridCrossAxisCount = isTablet
                    ? (width >= 900 ? 4 : 3)
                    : 2;
                final double gridSpacing = isSmallPhone ? 10.0 : 12.0;

                final double cardWidth =
                    (width -
                        (horizontalPadding * 2) -
                        (gridSpacing * (gridCrossAxisCount - 1))) /
                    gridCrossAxisCount;

                final bestOffers = controller.bestOffers;
                final endingSoon = controller.endingSoonOffers;
                final groupedByCategory = controller.offersGroupedByCategory;

                return HandlingDataView(
                  statusrequest: controller.statusrequest,
                  widget: CustomScrollView(
                    physics: const BouncingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics(),
                    ),
                    slivers: [
                      // 🏷️ فلتر الكاتيجوري (الكل + كاتيجوريز حقيقية من الداتا)
                      if (controller.availableCategories.isNotEmpty)
                        SliverToBoxAdapter(
                          child: _CategoryChips(controller: controller),
                        ),

                      // ⏰ تنتهي قريبًا - يظهر فقط لو فيه منتجات فعلاً عندها offerEndsAt
                      if (endingSoon.isNotEmpty) ...[
                        SliverToBoxAdapter(
                          child: _SectionTitle(
                            title: "⏰ تنتهي قريبًا",
                            horizontalPadding: horizontalPadding,
                          ),
                        ),
                        SliverToBoxAdapter(
                          child: SizedBox(
                            height: cardWidth * 1.55 + 40,
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              padding: EdgeInsets.symmetric(
                                horizontal: horizontalPadding,
                              ),
                              itemCount: endingSoon.length,
                              separatorBuilder: (_, __) =>
                                  SizedBox(width: gridSpacing),
                              itemBuilder: (context, index) {
                                final item = endingSoon[index];
                                return SizedBox(
                                  width: cardWidth * 1.35,
                                  child: Stack(
                                    children: [
                                      SharedProductCard(
                                        image: "${item.itemsImage}",
                                        title: "${item.itemsName}",
                                        price: "${item.itemsPrice}",
                                        rating: 4.8,
                                        onTap: () {},
                                        actionButton: AddToCartButton(
                                          itemId: item.id!,
                                        ),
                                        height: cardWidth * 1.55,
                                      ),
                                      // Positioned(
                                      //   top: 8,
                                      //   left: 8,
                                      //   child: _CountdownBadge(
                                      //     endsAt: item.offerEndsAt!,
                                      //   ),
                                      // ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ],

                      // 🔥 أفضل العروض - الجريد الأساسي (بيحترم فلتر الكاتيجوري)
                      SliverToBoxAdapter(
                        child: _SectionTitle(
                          title: "🔥 أفضل العروض",
                          horizontalPadding: horizontalPadding,
                        ),
                      ),
                      SliverPadding(
                        padding: EdgeInsets.symmetric(
                          horizontal: horizontalPadding,
                          vertical: 10,
                        ),
                        sliver: SliverGrid(
                          delegate: SliverChildBuilderDelegate((
                            context,
                            index,
                          ) {
                            ItemsModel item = bestOffers[index];
                            final double baseHeight = cardWidth * 1.55;
                            final double cardHeight = index.isEven
                                ? baseHeight
                                : baseHeight * 1.2;
                            return SharedProductCard(
                              image: "${item.itemsImage}",
                              title: "${item.itemsName}",
                              price: "${item.itemsPrice}",
                              rating: 4.8,
                              onTap: () {},
                              actionButton: AddToCartButton(itemId: item.id!),
                              height: cardHeight,
                            );
                          }, childCount: bestOffers.length),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: gridCrossAxisCount,
                                mainAxisSpacing: 16,
                                crossAxisSpacing: gridSpacing,
                                childAspectRatio: 0.65,
                              ),
                        ),
                      ),

                      // 🛍️ عروض حسب الأقسام - قسم لكل كاتيجوري حقيقية عندها منتجات
                      // بيظهر بس لو مفيش فلتر مطبق وفيه أكتر من كاتيجوري واحدة
                      if (controller.selectedCategoryId == null &&
                          groupedByCategory.length > 1)
                        ...groupedByCategory.entries.map((entry) {
                          final items = entry.value;
                          final categoryLabel =
                              items.first.categoryNameAr ??
                              items.first.categoryName ??
                              '';
                          return SliverMainAxisGroup(
                            slivers: [
                              SliverToBoxAdapter(
                                child: _SectionTitle(
                                  title: "🛍️ عروض $categoryLabel",
                                  horizontalPadding: horizontalPadding,
                                  onSeeMore: () =>
                                      controller.selectCategory(entry.key),
                                ),
                              ),
                              SliverToBoxAdapter(
                                child: SizedBox(
                                  height: cardWidth * 1.55 + 20,
                                  child: ListView.separated(
                                    scrollDirection: Axis.horizontal,
                                    padding: EdgeInsets.symmetric(
                                      horizontal: horizontalPadding,
                                    ),
                                    itemCount: items.length,
                                    separatorBuilder: (_, __) =>
                                        SizedBox(width: gridSpacing),
                                    itemBuilder: (context, index) {
                                      final item = items[index];
                                      return SizedBox(
                                        width: cardWidth * 1.35,
                                        child: SharedProductCard(
                                          image: "${item.itemsImage}",
                                          title: "${item.itemsName}",
                                          price: "${item.itemsPrice}",
                                          rating: 4.8,
                                          onTap: () {},
                                          actionButton: AddToCartButton(
                                            itemId: item.id!,
                                          ),
                                          height: cardWidth * 1.55,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ],
                          );
                        }),

                      const SliverToBoxAdapter(child: SizedBox(height: 20)),
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

/// عنوان قسم مع زر "عرض المزيد" اختياري
class _SectionTitle extends StatelessWidget {
  final String title;
  final double horizontalPadding;
  final VoidCallback? onSeeMore;

  const _SectionTitle({
    required this.title,
    required this.horizontalPadding,
    this.onSeeMore,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(horizontalPadding, 18, horizontalPadding, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
          ),
          if (onSeeMore != null)
            GestureDetector(
              onTap: onSeeMore,
              child: const Text(
                "عرض المزيد →",
                style: TextStyle(
                  fontSize: 13,
                  color: Color.fromARGB(255, 8, 110, 150),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// شرائط الكاتيجوري (الكل + الكاتيجوريز الحقيقية اللي رجعت من الباك اند)
class _CategoryChips extends StatelessWidget {
  final Offercontroller controller;

  const _CategoryChips({required this.controller});

  @override
  Widget build(BuildContext context) {
    final categories = controller.availableCategories;

    return SizedBox(
      height: 44,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          _chip(
            label: "الكل",
            selected: controller.selectedCategoryId == null,
            onTap: () => controller.selectCategory(null),
          ),
          const SizedBox(width: 8),
          ...categories.expand(
            (c) => [
              _chip(
                label: c.name ?? '',
                selected: controller.selectedCategoryId == c.id,
                onTap: () => controller.selectCategory(c.id),
              ),
              const SizedBox(width: 8),
            ],
          ),
        ],
      ),
    );
  }

  Widget _chip({
    required String label,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => onTap(),
      selectedColor: const Color.fromARGB(255, 8, 110, 150),
      labelStyle: TextStyle(
        color: selected ? Colors.white : null,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

/// عداد تنازلي صغير لعرضه فوق كارت "تنتهي قريبًا"
class _CountdownBadge extends StatefulWidget {
  final DateTime endsAt;

  const _CountdownBadge({required this.endsAt});

  @override
  State<_CountdownBadge> createState() => _CountdownBadgeState();
}

class _CountdownBadgeState extends State<_CountdownBadge> {
  late Timer _timer;
  Duration _remaining = Duration.zero;

  @override
  void initState() {
    super.initState();
    _updateRemaining();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      _updateRemaining();
    });
  }

  void _updateRemaining() {
    final diff = widget.endsAt.difference(DateTime.now());
    setState(() {
      _remaining = diff.isNegative ? Duration.zero : diff;
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  String _format(Duration d) {
    if (d == Duration.zero) return "انتهى";
    final days = d.inDays;
    final hours = d.inHours % 24;
    final minutes = d.inMinutes % 60;
    final seconds = d.inSeconds % 60;
    if (days > 0) {
      return "${days}ي ${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}";
    }
    return "${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.75),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.timer, color: Colors.white, size: 12),
          const SizedBox(width: 4),
          Text(
            _format(_remaining),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
