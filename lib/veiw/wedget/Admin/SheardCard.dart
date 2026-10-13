import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hos/veiw/wedget/pricecard.dart';

// ignore: must_be_immutable
class CategoryCard extends StatefulWidget {
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onTap;
  final String imageUrl;
  final String? name;
  final String? price;
  final String? stock;
  bool? inHome;
  CategoryCard({
    super.key,
    required this.name,
    required this.imageUrl,
    required this.onEdit,
    required this.onDelete,
    required this.onTap,
    this.stock,
    this.price,
  });

  CategoryCard.items({
    super.key,
    required this.name,
    required this.imageUrl,
    this.price,
    this.stock,
    required this.onEdit,
    required this.onDelete,
    required this.onTap,
  });
  CategoryCard.Homepage({
    super.key,
    required this.name,
    required this.imageUrl,
    this.price,
    this.stock,
    this.inHome,
    required this.onEdit,
    required this.onDelete,
    required this.onTap,
  });
  @override
  State<CategoryCard> createState() => _CategoryCardState();
}

class _CategoryCardState extends State<CategoryCard> {
  bool _showActions = false;

  void _hideActions() {
    if (_showActions) {
      setState(() => _showActions = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final categoryName = widget.name ?? '';
    final ishome = widget.inHome == true;

    return LayoutBuilder(
      builder: (context, constraints) {
        // كل المقاسات بتتحسب من عرض الكارت الفعلي
        final w = constraints.maxWidth.isFinite ? constraints.maxWidth : 180.0;
        final compact = w < 150;

        final radius = (w * 0.11).clamp(12.0, 20.0);
        final edge = (w * 0.055).clamp(6.0, 10.0);
        final nameSize = ishome
            ? (w * 0.07).clamp(9.0, 11.0)
            : (w * 0.08).clamp(11.0, 15.0);
        final subSize = (w * 0.075).clamp(10.0, 14.0);
        final btnH = compact ? 34.0 : 42.0;
        final btnIcon = compact ? 15.0 : 18.0;
        final btnFont = compact ? 11.0 : 13.0;
        final closeSize = compact ? 26.0 : 30.0;
        final hasPrice = widget.price != null;
        final stockText = widget.stock ?? '';

        return GestureDetector(
          onTap: () {
            if (_showActions) {
              _hideActions();
            } else {
              widget.onTap();
            }
          },
          onLongPress: () {
            if (widget.inHome != true) {
              setState(() => _showActions = true);
            }
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeOutCubic,
            transform: Matrix4.translationValues(0, _showActions ? -7 : 0, 0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(radius),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(_showActions ? 33 : 13),
                  blurRadius: _showActions ? 20 : 14,
                  offset: Offset(0, _showActions ? 10 : 5),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(radius),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // صورة القسم كخلفية للكارت بالكامل
                  CachedNetworkImage(
                    imageUrl: widget.imageUrl,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => const Center(
                      child: SizedBox(
                        width: 25,
                        height: 25,
                        child: CircularProgressIndicator(strokeWidth: 2.5),
                      ),
                    ),
                    errorWidget: (context, url, error) => const Center(
                      child: Icon(
                        Icons.image_not_supported_rounded,
                        color: Colors.grey,
                        size: 30,
                      ),
                    ),
                  ),

                  // اسم القسم / المنتج (والسعر والمخزون)
                  AnimatedPositioned(
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeOut,
                    left: edge,
                    right: edge,
                    bottom: _showActions ? btnH + edge + 6 : edge + 2,
                    child: AnimatedOpacity(
                      duration: const Duration(milliseconds: 150),
                      opacity: _showActions ? 0 : 1,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: (w * 0.065).clamp(6.0, 12.0),
                          vertical: (w * 0.05).clamp(5.0, 9.0),
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withAlpha(82),
                          borderRadius: BorderRadius.circular(
                            (radius * 0.7).clamp(8.0, 14.0),
                          ),
                          border: Border.all(color: Colors.white.withAlpha(41)),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              categoryName,
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: nameSize,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            if (hasPrice)
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Flexible(
                                    child: FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: PriceText(
                                        widget.price!,
                                        color: Colors.amberAccent,
                                      ),
                                    ),
                                  ),
                                  if (stockText.isNotEmpty)
                                    Flexible(
                                      child: Text(
                                        stockText,
                                        textAlign: TextAlign.center,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          color: Colors.amberAccent,
                                          fontSize: subSize,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // الأزرار تظهر فقط بعد الضغط المطول
                  AnimatedPositioned(
                    duration: const Duration(milliseconds: 220),
                    curve: Curves.easeOutBack,
                    left: edge,
                    right: edge,
                    bottom: _showActions ? edge : -(btnH + 13),
                    child: AnimatedOpacity(
                      duration: const Duration(milliseconds: 150),
                      opacity: _showActions ? 1 : 0,
                      child: Row(
                        children: [
                          Expanded(
                            child: _buildActionButton(
                              icon: Icons.edit_rounded,
                              label: "edit".tr,
                              color: Colors.blueAccent,
                              onTap: widget.onEdit,
                              height: btnH,
                              iconSize: btnIcon,
                              fontSize: btnFont,
                              radius: (radius * 0.7).clamp(8.0, 14.0),
                            ),
                          ),
                          SizedBox(width: compact ? 5 : 8),
                          Expanded(
                            child: _buildActionButton(
                              icon: Icons.delete_rounded,
                              label: "delete".tr,
                              color: Colors.redAccent,
                              onTap: widget.onDelete,
                              height: btnH,
                              iconSize: btnIcon,
                              fontSize: btnFont,
                              radius: (radius * 0.7).clamp(8.0, 14.0),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // زر إغلاق صغير بعد ظهور الخيارات (يدعم RTL)
                  if (_showActions)
                    PositionedDirectional(
                      top: edge - 2,
                      end: edge - 2,
                      child: GestureDetector(
                        onTap: _hideActions,
                        child: Container(
                          width: closeSize,
                          height: closeSize,
                          decoration: BoxDecoration(
                            color: Colors.black.withAlpha(107),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white.withAlpha(64),
                            ),
                          ),
                          child: Icon(
                            Icons.close_rounded,
                            color: Colors.white,
                            size: closeSize * 0.6,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
    required double height,
    required double iconSize,
    required double fontSize,
    required double radius,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          onTap();
          _hideActions();
        },
        borderRadius: BorderRadius.circular(radius),
        child: Container(
          height: height,
          padding: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            color: Colors.white.withAlpha(240),
            borderRadius: BorderRadius.circular(radius),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(31),
                blurRadius: 7,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, color: color, size: iconSize),
                const SizedBox(width: 6),
                Text(
                  label,
                  style: TextStyle(
                    color: color,
                    fontSize: fontSize,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}