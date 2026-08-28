import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/utils.dart';

class CategoryCard extends StatefulWidget {
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onTap;
  final String imageUrl;
  final String? name;
  final String? price;
  final String? stock;
  CategoryCard({
    super.key,
    required this.name,
    required this.imageUrl,
    required this.onEdit,
    required this.onDelete,
    required this.onTap,
    this.stock = null,
    this.price = null,
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
    final categoryName = widget.name;

    return GestureDetector(
      onTap: () {
        if (_showActions) {
          _hideActions();
        } else {
          widget.onTap();
        }
      },
      onLongPress: () {
        setState(() => _showActions = true);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOutCubic,
        transform: Matrix4.translationValues(0, _showActions ? -7 : 0, 0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(_showActions ? 0.13 : 0.05),
              blurRadius: _showActions ? 20 : 14,
              offset: Offset(0, _showActions ? 10 : 6),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // صورة القسم كخلفية للكارت بالكامل
              CachedNetworkImage(
                imageUrl: widget.imageUrl,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  color: const Color(0xffF4F6FA),
                  child: const Center(
                    child: SizedBox(
                      width: 25,
                      height: 25,
                      child: CircularProgressIndicator(strokeWidth: 2.5),
                    ),
                  ),
                ),
                errorWidget: (context, url, error) => Container(
                  color: const Color(0xffF4F6FA),
                  child: const Icon(
                    Icons.image_not_supported_rounded,
                    color: Colors.grey,
                    size: 30,
                  ),
                ),
              ),

              // تدرج خفيف يجعل اسم القسم واضحاً فوق الصورة
              const DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.transparent,
                      Color(0xCC000000),
                    ],
                    stops: [0.0, 0.48, 1.0],
                  ),
                ),
              ),

              // اسم القسم في مكان أزرار التعديل والحذف
              AnimatedPositioned(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeOut,
                left: 10,
                right: 10,
                bottom: _showActions ? 58 : 12,
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 150),
                  opacity: _showActions ? 0 : 1,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 9,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.32),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: Colors.white.withOpacity(0.16)),
                    ),
                    child: Column(
                      children: [
                        Text(
                          categoryName!,
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        ?widget.price == null
                            ? null
                            : Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Text(
                                   "${widget.price!} ""EGP".tr,
                                    textAlign: TextAlign.center,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      color: Colors.green,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    widget.stock!,
                                    textAlign: TextAlign.center,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      color: Colors.amberAccent,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
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
                left: 10,
                right: 10,
                bottom: _showActions ? 10 : -55,
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 150),
                  opacity: _showActions ? 1 : 0,
                  child: Row(
                    children: [
                      Expanded(
                        child: _buildActionButton(
                          icon: Icons.edit_rounded,
                          label: "تعديل",
                          color: Colors.blueAccent,
                          onTap: widget.onEdit,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildActionButton(
                          icon: Icons.delete_rounded,
                          label: "حذف",
                          color: Colors.redAccent,
                          onTap: widget.onDelete,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // زر إغلاق صغير بعد ظهور الخيارات
              if (_showActions)
                Positioned(
                  top: 8,
                  right: 8,
                  child: GestureDetector(
                    onTap: _hideActions,
                    child: Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.42),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white.withOpacity(0.25),
                        ),
                      ),
                      child: const Icon(
                        Icons.close_rounded,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          onTap();
          _hideActions();
        },
        borderRadius: BorderRadius.circular(14),
        child: Container(
          height: 42,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.94),
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.12),
                blurRadius: 7,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: 18),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  color: color,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
