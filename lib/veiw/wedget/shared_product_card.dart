import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hos/data/model/itemsmodel.dart';

// ignore: must_be_immutable
class SharedProductCard extends StatelessWidget {
  final ItemsModel items;
  bool isen;
  final VoidCallback? onTap;
  final Widget actionButton; // 👈 ضفنا دي عشان نحط فيها (مسح، مفضلة، أو سلة)
  final double height; // ارتفاع ثابت للكارد
  SharedProductCard({
    super.key,
    required this.isen,
    required this.items,
    required this.actionButton, // 👈 مطلوبة هنا
    this.onTap,
    required this.height, // ممكن تعدلها لو حبيت
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // ألوان الكارت الأساسية بتتغير حسب الوضع (ليلي / نهاري)
    final Color cardBorderColor = Colors.grey.withAlpha(50);
    final Color cardShadow = Colors.black.withAlpha(20);

    // الشارات (title chip / rating badge / price bar) عايمة فوق الصورة
    // فبنخليها "زجاج غامق" ثابت في الوضعين، عشان تفضل واضحة أياً كانت ألوان
    // صورة المنتج نفسها (فاتحة أو غامقة)
    final Color chipBackground = Colors.black.withAlpha(81);
    final Color chipBorder = Colors.white.withAlpha(46);
    const Color chipTextColor = Colors.white;

    return GestureDetector(
      onTap: onTap,
      child: LayoutBuilder(
        builder: (context, constraints) {
          // final isDarkMode = Theme.of(context).brightness == Brightness.dark;

          // نستخدم عرض الكارت الفعلي (مش عرض الشاشة كله) عشان الأبعاد
          // تتظبط صح مهما كان عدد أعمدة الجريد (2 هاتف / 3-4 تابلت)
          final double cardWidth = constraints.maxWidth.isFinite
              ? constraints.maxWidth
              : 180.0;

          final double imagePadding = (cardWidth * 0.07).clamp(8.0, 16.0);

          final double titleChipMaxWidth = (cardWidth * 0.9).clamp(
            110.0,
            240.0,
          );
          final double titleFontSize = (cardWidth * 0.062).clamp(11.0, 14.0);

          final double ratingBadgeWidth = (cardWidth * 0.27).clamp(42.0, 56.0);
          final double ratingBadgeHeight = (ratingBadgeWidth * 0.6).clamp(
            24.0,
            30.0,
          );
          final double ratingFontSize = (cardWidth * 0.045).clamp(10.0, 13.0);
          final double ratingIconSize = (cardWidth * 0.05).clamp(12.0, 16.0);

          final double bottomBarWidth = (cardWidth * 0.9).clamp(140.0, 230.0);
          final double bottomBarHeight = (height * 0.16).clamp(40.0, 54.0);
          final double priceFontSize = (cardWidth * 0.06).clamp(12.0, 15.0);

          return Container(
            padding: const EdgeInsets.all(5),
            height: height,
            decoration: BoxDecoration(
              boxShadow: [BoxShadow(color: cardShadow, blurRadius: 2)],
              color: Color(0xFFE0E3E8),
              borderRadius: const BorderRadius.all(Radius.circular(25)),
              border: Border.all(
                color: cardBorderColor,
                strokeAlign: BorderSide.strokeAlignCenter,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                /// 1. الصورة
                Expanded(
                  child: SizedBox(
                    width: double.infinity,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.all(imagePadding),
                          child: CachedNetworkImage(
                            imageUrl: items.itemsImage!,
                            imageBuilder: (context, imageProvider) => Container(
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: imageProvider,
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                            placeholder: (context, url) => Center(
                              child: SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: theme.colorScheme.primary,
                                ),
                              ),
                            ),
                            errorWidget: (context, url, error) => Icon(
                              Icons.broken_image_outlined,
                              color: theme.colorScheme.onSurface.withAlpha(102),
                            ),
                          ),
                        ),

                        /// شارة الاسم + التقييم أعلى الصورة
                        Positioned(
                          top: 8,
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              maxWidth: titleChipMaxWidth,
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: BackdropFilter(
                                filter: ImageFilter.blur(
                                  sigmaX: 10,
                                  sigmaY: 10,
                                ),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 5,
                                    vertical: 5,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: chipBackground,
                                    border: Border.all(color: chipBorder),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Flexible(
                                        child: Text(
                                          isen
                                              ? (items.itemsName ?? '')
                                              : (items.itemsNameAr ?? ''),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: titleFontSize,
                                            color: chipTextColor,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 6),
                                      Container(
                                        width: ratingBadgeWidth,
                                        height: ratingBadgeHeight,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            20,
                                          ),
                                          color: Colors.white.withAlpha(46),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.star_purple500_outlined,
                                              size: ratingIconSize,
                                              color: Colors.amber,
                                            ),
                                            const SizedBox(width: 3),
                                            Text(
                                              "5.5",
                                              style: TextStyle(
                                                fontSize: ratingFontSize,
                                                fontWeight: FontWeight.w500,
                                                color: chipTextColor,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),

                        /// شريط السعر + زرار السلة أسفل الصورة
                        Positioned(
                          bottom: 10,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(40),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                              child: Container(
                                width: bottomBarWidth,
                                height: bottomBarHeight,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 5,
                                  horizontal: 12,
                                ),
                                decoration: BoxDecoration(
                                  color: chipBackground,
                                  borderRadius: BorderRadius.circular(40),
                                  border: Border.all(color: chipBorder),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Flexible(
                                      child: Text(
                                        "${items.itemsPrice}",
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: priceFontSize,
                                          color: Colors.greenAccent.shade400,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    actionButton, // 👈 هنا هيتعرض الزرار اللي هتبعتهوله
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
