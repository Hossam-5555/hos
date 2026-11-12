import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hos/controler/usercontroller/checkout&cart/cart_controller.dart';
import 'package:hos/core/conistant/app_colors.dart';
import 'package:hos/data/model/cartmodel.dart';
import 'package:hos/veiw/wedget/pricecard.dart';
import 'package:jiffy/jiffy.dart';

Widget buildCartItemCard(
  BuildContext context,
  CartModel cart,
  CartController controller,
  int i,
  bool isdark,
) {
  return LayoutBuilder(
    builder: (context, constraints) {
      final width = constraints.maxWidth;
      final isCompact = width < 340;
      final isTablet = width >= 600;

      final imageSize = isCompact ? 110.0 : (isTablet ? 120.0 : 96.0);
      final imageHeight = isCompact ? 100.0 : (isTablet ? 112.0 : 96.0);
      final padding = isCompact ? 5.0 : 10.0;
      final gap = isCompact ? 15.0 : 14.0;
      final titleSize = isCompact ? 8.0 : (isTablet ? 15.0 : 13.0);
      final priceSize = isCompact ? 12.0 : (isTablet ? 16.0 : 14.0);

      return GetBuilder<CartController>(
        builder: (cartController) {
          if (i >= cartController.data.length) {
            return const SizedBox.shrink();
          }

          final currentCart = cartController.data[i];

          return Container(
            padding: EdgeInsets.all(padding),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isdark ? AppColors.darkBorder : AppColors.lightBorder,
              ),
              boxShadow: [
                BoxShadow(
                  color: isdark ? AppColors.darkShadow.withAlpha(100) : AppColors.lightShadow.withAlpha(100),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Product image
                Container(
                  width: imageSize,
                  height: imageHeight,
                  decoration: BoxDecoration(
                    color: isdark
                        ? AppColors.darkImageSurface
                        : AppColors.editBackground,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: CachedNetworkImage(
                      imageUrl: currentCart.itemimage ?? '',
                      fit: BoxFit.contain,
                      placeholder: (context, url) => const Center(
                        child: SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      ),
                      errorWidget: (context, url, error) => Icon(
                        Icons.image_not_supported_outlined,
                        color: AppColors.mutedText,
                        size: 28,
                      ),
                    ),
                  ),
                ),

                SizedBox(width: gap),

                // Product details
                Expanded(
                  child: Column(
                    // mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              currentCart.itemsname ?? 'بدون اسم',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: titleSize,
                                fontWeight: FontWeight.bold,
                                height: 1.2,
                              ),
                            ),
                          ),
                          const SizedBox(width: 4),
                          if (!isCompact)
                            Flexible(
                              child: Text(
                                currentCart.createdAt == null
                                    ? 'منذ مدة'
                                    : Jiffy.parse(
                                        currentCart.createdAt!,
                                      ).fromNow(),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.end,
                                style: TextStyle(
                                  fontSize: isTablet ? 12 : 10,
                                  color: AppColors.mutedText,
                                ),
                              ),
                            ),
                        ],
                      ),

                      SizedBox(height: isCompact ? 15 : 20),

                      // Price and quantity controls
                      Row(
                        children: [
                          Expanded(
                            child: PriceText(
                              currentCart.subtotal ?? 0,
                              fontSize: priceSize,
                            ),
                          ),
                          _QuantityControl(
                            count: currentCart.cartCount ?? 0,
                            compact: isCompact,
                            isDark: isdark,
                            onDecrease: () {
                              if (currentCart.itemid != null) {
                                cartController.decrement(currentCart.itemid!);
                              }
                            },
                            onIncrease: () {
                              if (currentCart.itemid != null) {
                                cartController.increment(currentCart.itemid!);
                              }
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      );
    },
  );
}

class _QuantityControl extends StatelessWidget {
  final int count;
  final bool compact;
  final bool isDark;
  final VoidCallback onDecrease;
  final VoidCallback onIncrease;

  const _QuantityControl({
    required this.count,
    required this.compact,
    required this.isDark,
    required this.onDecrease,
    required this.onIncrease,
  });

  @override
  Widget build(BuildContext context) {
    final buttonSize = compact ? 27.0 : 30.0;
    final iconSize = compact ? 16.0 : 19.0;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: compact ? 3 : 4, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.editBackground,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _QuantityButton(
            icon: Icons.remove_rounded,
            size: buttonSize,
            iconSize: iconSize,
            background: AppColors.lightSurface,
            foreground: AppColors.darkSurface,
            onPressed: onDecrease,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: compact ? 6 : 9),
            child: Text(
              '$count',
              style: const TextStyle(
                color: AppColors.darkSurface,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ),
          _QuantityButton(
            icon: Icons.add_rounded,
            size: buttonSize,
            iconSize: iconSize,
            background: AppColors.darkSurface,
            foreground: AppColors.lightSurface,
            onPressed: onIncrease,
          ),
        ],
      ),
    );
  }
}

class _QuantityButton extends StatelessWidget {
  final IconData icon;
  final double size;
  final double iconSize;
  final Color background;
  final Color foreground;
  final VoidCallback onPressed;

  const _QuantityButton({
    required this.icon,
    required this.size,
    required this.iconSize,
    required this.background,
    required this.foreground,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: IconButton(
        onPressed: onPressed,
        padding: EdgeInsets.zero,
        constraints: BoxConstraints.tightFor(width: size, height: size),
        style: IconButton.styleFrom(
          backgroundColor: background,
          foregroundColor: foreground,
          shape: const CircleBorder(),
        ),
        icon: Icon(icon, size: iconSize),
      ),
    );
  }
}

Widget infoChip(IconData icon, String label, bool isDark, Key key) {
  return Column(
    key: key,
    mainAxisSize: MainAxisSize.min,
    children: [
      Icon(
        icon,
        size: 15,
        color: isDark ? AppColors.arabic : AppColors.mutedText,
      ),
      const SizedBox(height: 3),
      Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: isDark ? Colors.white60 : AppColors.mutedText,
        ),
      ),
    ],
  );
}

Widget verticalDivider() {
  return Container(height: 35, width: 1, color: AppColors.border);
}
