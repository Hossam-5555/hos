import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hos/core/conistant/app_colors.dart';
import 'package:hos/core/conistant/app_dimensions.dart';
import 'package:hos/data/model/itemsmodel.dart';
import 'package:hos/veiw/wedget/pricecard.dart';

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

  String _fmt(double v) =>
      v == v.roundToDouble() ? v.toStringAsFixed(0) : v.toStringAsFixed(2);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isdark = theme.brightness == Brightness.dark;
    // ألوان الكارت الأساسية بتتغير حسب الوضع (ليلي / نهاري)
    final Color cardShadow = AppColors.black.withAlpha(60);

    final Color chipBackground = AppColors.black.withAlpha(100);
    final Color chipBorder = AppColors.white.withAlpha(150);
    final Color chipTextColor = AppColors.white;

    // ───── الخصم: السعر الأصلي + النسبة → السعر بعد الخصم ─────
    final double price = (items.itemsPrice ?? 0).toDouble();
    final int discount = (items.itemsDiscount ?? 0).toInt();
    final bool hasDiscount = discount > 0;
    final double finalPrice = hasDiscount
        ? price - (price * discount / 100)
        : price;

    return GestureDetector(
      onTap: onTap,
      child: LayoutBuilder(
        builder: (context, constraints) {
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
          final double titleFontSize = (cardWidth * 0.062).clamp(
            AppDimensions.fontBodySmall,
            AppDimensions.fontBodyMedium,
          );

          final double ratingBadgeWidth = (cardWidth * 0.27).clamp(42.0, 56.0);
          final double ratingBadgeHeight = (ratingBadgeWidth * 0.6).clamp(
            24.0,
            30.0,
          );
          final double ratingFontSize = (cardWidth * 0.045).clamp(
            AppDimensions.fontBodySmall,
            13.0,
          );
          final double ratingIconSize = (cardWidth * 0.05).clamp(12.0, 16.0);

          final double bottomBarWidth = (cardWidth * 0.9).clamp(140.0, 230.0);
          final double bottomBarHeight = (height * 0.16).clamp(40.0, 54.0);

          // حجم نص الشارة والسعر القديم نسبي لعرض الكارت
          final double oldPriceFontSize = (cardWidth * 0.05).clamp(10.0, 12.0);

          return Container(
            padding: const EdgeInsets.all(5),
            height: height,
            decoration: BoxDecoration(
              boxShadow: [BoxShadow(color: cardShadow, blurRadius: 2)],
              color: isdark ? AppColors.buttoncolor : AppColors.editBackground,
              borderRadius: const BorderRadius.all(Radius.circular(25)),
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
                          top: AppDimensions.sm,
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
                                          color: AppColors.white.withAlpha(46),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.star_purple500_outlined,
                                              size: ratingIconSize,
                                              color: AppColors.warning,
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

                        /// شارة الخصم + شريط السعر وزرار الإجراء أسفل الصورة
                        Positioned(
                          bottom: 10,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (hasDiscount) ...[
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 3,
                                  ),
                                  decoration: BoxDecoration(
                                    color: theme.colorScheme.error,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    '-$discount%',
                                    style: TextStyle(
                                      color: theme.colorScheme.onError,
                                      fontSize: ratingFontSize,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 6),
                              ],
                              ClipRRect(
                                borderRadius: BorderRadius.circular(40),
                                child: BackdropFilter(
                                  filter: ImageFilter.blur(
                                    sigmaX: 10,
                                    sigmaY: 10,
                                  ),
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
                                        // السعر بعد الخصم + السعر القديم مشطوب
                                        // FittedBox: لو المساحة ضيقة يصغّر بدل ما يعمل overflow
                                        Flexible(
                                          child: FittedBox(
                                            fit: BoxFit.scaleDown,
                                            alignment: AlignmentDirectional
                                                .centerStart,
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                PriceText(
                                                  hasDiscount
                                                      ? finalPrice
                                                      : (items.itemsPrice ?? 0),
                                                ),
                                                if (hasDiscount) ...[
                                                  const SizedBox(width: 6),
                                                  Text(
                                                    _fmt(price),
                                                    style: TextStyle(
                                                      fontSize:
                                                          oldPriceFontSize,
                                                      color: chipTextColor
                                                          .withAlpha(170),
                                                      decoration: TextDecoration
                                                          .lineThrough,
                                                      decorationColor:
                                                          chipTextColor
                                                              .withAlpha(170),
                                                    ),
                                                  ),
                                                ],
                                              ],
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: AppDimensions.sm),
                                        actionButton, // 👈 هنا هيتعرض الزرار اللي هتبعتهوله
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
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
