import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:hos/controler/admincontroller/items/viewitemcontroller.dart';
import 'package:hos/core/class/handlingdataview.dart';
import 'package:hos/core/functions/showdialoge.dart';
import 'package:hos/veiw/wedget/appbarbackicon.dart';
import 'package:hos/veiw/wedget/searchbar.dart';

class ViewItemScreen extends StatelessWidget {
  const ViewItemScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    final controller = Get.put(ViewItemController());

    return Scaffold(
      // عرض اسم القسم المختار ديناميكياً في الـ AppBar
      appBar: Appbarbackicon(
        title: controller.catname ?? "المنتجات",
        herotag: "",
      ),
      body: SafeArea(
        child: Column(
          children: [
            /// 🔍 1. شريط البحث
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Searchbar(
                title: "ابحث عن منتج، رمز، أو قسم...",
                mycontroller: controller.controller,
              ),
            ),

            /// 🛍️ 2. شبكة المنتجات (تحديث تلقائي)
            Expanded(
              child: GetBuilder<ViewItemController>(
                builder: (controller) {
                  return HandlingDataView(
                    statusrequest: controller.statusrequest,
                    widget: MasonryGridView.builder(
                      gridDelegate:
                          SliverSimpleGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: screenWidth > 700 ? 4 : 2,
                          ),
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
                      mainAxisSpacing: 12, // 👈 مسافة عمودية بين الكروت
                      crossAxisSpacing: 12, // 👈 مسافة أفقية بين الكروت
                      itemCount: controller.itemlist.length,
                      itemBuilder: (context, index) {
                        return ProductCard(
                          item: controller.itemlist[index],
                          controller: controller,
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),

      /// ➕ 3. الزر العائم المستقبلي (Neon FAB)
      floatingActionButton: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.cyanAccent.withOpacity(0.4),
              blurRadius: 15,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: FloatingActionButton(
          onPressed: controller.goToAddPage,
          backgroundColor: Colors.transparent,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(
              color: Colors.cyanAccent.withOpacity(0.5),
              width: 1.5,
            ),
          ),
          child: Ink(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF00F2FE), Color(0xFF4FACFE)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Center(
              child: Icon(
                Icons.add_moderator_rounded,
                color: Colors.white,
                size: 26,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// =========================================================
/// 🌌 كارت المنتج بتأثير Glassmorphism الفضائي والأبعاد المحمية
/// =========================================================
class ProductCard extends StatelessWidget {
  final dynamic item;
  final ViewItemController controller;

  const ProductCard({super.key, required this.item, required this.controller});

  @override
  Widget build(BuildContext context) {
    final bool inStock = (item.stock ?? 0) > 15;
    final Color stockColor = inStock ? Colors.green : Colors.red;

    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.grey.withOpacity(0.15),
              width: 1.2,
            ),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white.withOpacity(0.08),
                Colors.white.withOpacity(0.02),
              ],
            ),
          ),
          // تم إزالة الـ Column الداخلي المعقد والـ Expanded
          child: Column(
            mainAxisSize:
                MainAxisSize.min, // 👈 يجعل الكارت يأخذ حجم محتواه فقط
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// 🖼️ أ) صورة المنتج (إعطاؤها طول ثابت ليناسب الـ Masonry)
              Stack(
                children: [
                  Container(
                    height:
                        150, // 👈 طول ثابت ومناسب جداً للصورة لتظهر كالجزء الأكبر
                    width: double.infinity,
                    margin: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: CachedNetworkImage(
                      imageUrl: "${item.itemsImage}",
                      fit: BoxFit.contain,
                      placeholder: (_, __) => const Center(
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                      errorWidget: (_, __, ___) =>
                          const Icon(Icons.image_not_supported, size: 30),
                    ),
                  ),
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: stockColor.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: stockColor, width: 1),
                      ),
                      child: Text(
                        inStock ? "In Stock" : "Low Stock",
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                          color: stockColor,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              /// 📝 ب) تفاصيل المنتج والأزرار
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 4, 12, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // اسم المنتج (بدون لون مخصص لدعم النهار والليل)
                    Text(
                      item.itemsName ?? "بدون اسم",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 6),

                    // السعر والتقييم
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Text(
                            "${item.itemsPrice} ${"EGP".tr}",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                        const Row(
                          children: [
                            Text("4", style: TextStyle(fontSize: 10)),
                            Icon(
                              Icons.star_rounded,
                              color: Colors.amberAccent,
                              size: 12,
                            ),
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(height: 12), // مسافة تفصل السعر عن الأزرار
                    // أزرار التحكم للأدمن
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildAdminButton(
                          icon: Icons.edit_rounded,
                          color: Colors.blueAccent,
                          onTap: () => controller.gotoeditpage(item),
                        ),
                        _buildAdminButton(
                          icon: Icons.delete_outline_rounded,
                          color: Colors.redAccent,
                          onTap: () {
                            AppCupertinoDialog.show(
                              title: "حذف المنتج",
                              message: "هل تريد حذف المنتج نهائياً؟",
                              confirmText: "حذف",
                              onConfirm: () => controller.delete(item.id),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAdminButton({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: color.withOpacity(0.15),
          border: Border.all(color: color, width: 1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: color, size: 16),
      ),
    );
  }
}
