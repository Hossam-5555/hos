import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hos/controler/admincontroller/items/viewitemcontroller.dart';
import 'package:hos/core/class/handlingdataview.dart';
import 'package:hos/core/functions/showdialoge.dart';
import 'package:hos/veiw/wedget/searchbar.dart';

class ViewItemScreen extends StatelessWidget {
  const ViewItemScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    final controller = Get.put(ViewItemController());

    return Scaffold(
      // جعلنا خلفية الـ Scaffold شفافة لنظهر الخلفية الكونية خلفها
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          SafeArea(
            child: Column(
              children: [
                // شريط البحث (مغلف بتأثير متلألئ خفيف)
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.cyanAccent.withAlpha(25), // 0.1 * 255
                          blurRadius: 10,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Searchbar(
                      title: "ابحث عن منتج، رمز، أو قسم...",
                      mycontroller: controller.controller,
                    ),
                  ),
                ),

                // الفلاتر العصرية (أقسام المنتجات - تأثير النيون)
                SizedBox(
                  height: 55,
                  child: GetBuilder<ViewItemController>(
                    builder: (controller) {
                      return ListView.separated(
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 5,
                        ),
                        itemCount: controller.categorylist.length,
                        separatorBuilder: (_, _) => const SizedBox(width: 12),
                        itemBuilder: (context, index) {
                          final isSelected = controller.selectedCat == index;
                          return _buildFuturisticFilterChip(
                            label: controller.categorylist[index].name
                                .toString(),
                            isSelected: isSelected,
                            onTap: () => controller.chnagecat(index),
                          );
                        },
                      );
                    },
                  ),
                ),
                const SizedBox(height: 12),

                // قائمة المنتجات
                Expanded(
                  child: GetBuilder<ViewItemController>(
                    builder: (controller) {
                      return Handlingdataview(
                        statusrequest: controller.statusrequest,
                        widget: GridView.builder(
                          physics: const BouncingScrollPhysics(),
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
                          itemCount: controller.filtereditem.length,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: screenWidth > 700 ? 4 : 2,
                                childAspectRatio:
                                    0.58, // تعديل الارتفاع ليناسب التصميم الجديد
                                crossAxisSpacing: 16,
                                mainAxisSpacing: 16,
                              ),
                          itemBuilder: (context, index) {
                            return ProductCard(
                              item: controller.filtereditem[index],
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
        ],
      ),

      // ==========================================
      // 3. الزر العائم المستقبلي (Neon FAB)
      // ==========================================
      floatingActionButton: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.cyanAccent.withAlpha(128), // 0.5 * 255
              blurRadius: 20,
              spreadRadius: 2,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: FloatingActionButton(
          onPressed: controller.goToAddPage,
          backgroundColor: Colors.transparent, // شفاف ليظهر التدرج
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(
              color: Colors.cyanAccent.withAlpha(128), // 0.5 * 255
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
            child: Center(
              child: Icon(
                Icons.add_moderator_rounded,
                color: Colors.white,
                size: 28,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // تصميم الفلاتر المستقبلي (Neon / Glass)
  Widget _buildFuturisticFilterChip({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 0),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected
              ? Colors.cyanAccent.withAlpha(51) // 0.2 * 255
              : Colors.white.withAlpha(13), // 0.05 * 255
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: isSelected
                ? Colors.cyanAccent
                : Colors.white.withAlpha(25),
            width: isSelected ? 1.5 : 1.0,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.cyanAccent.withAlpha(102), // 0.4 * 255
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ]
              : [],
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.cyanAccent : Colors.grey,
            fontWeight: isSelected ? FontWeight.w800 : FontWeight.w500,
            letterSpacing: 1.2,
            shadows: isSelected
                ? [const Shadow(color: Colors.blueAccent, blurRadius: 5)]
                : [],
          ),
        ),
      ),
    );
  }
}

// ==========================================
// كارت المنتج بتأثير Glassmorphism الفضائي
// ==========================================
class ProductCard extends StatelessWidget {
  final dynamic item;
  final ViewItemController controller;

  const ProductCard({super.key, required this.item, required this.controller});

  @override
  Widget build(BuildContext context) {
    final String imageUrl = "${item.itemsImage}";
    final String price = "${item.itemsPrice}";

    final bool inStock = (item.stock ?? 0) > 15;

    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white, // زجاجي شفاف
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: Colors.grey.withAlpha(51), // 0.2 * 255
              width: 1.2,
            ),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white.withAlpha(25), // 0.1 * 255
                Colors.white.withAlpha(5), // 0.02 * 255
              ],
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// صورة المنتج مع إطار مضيء
              Stack(
                children: [
                  Container(
                    height: 180,
                    width: double.infinity,
                    margin: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.white.withAlpha(76), // 0.3 * 255
                          blurRadius: 2,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: CachedNetworkImage(
                      imageUrl: imageUrl,
                      fit: BoxFit.contain,
                      placeholder: (context, url) {
                        return const Center(
                          child: CircularProgressIndicator(
                            color: Colors.cyanAccent,
                            strokeWidth: 2,
                          ),
                        );
                      },
                      errorWidget: (context, url, error) {
                        return const Icon(
                          Icons.image_not_supported,
                          size: 40,
                          color: Colors.white54,
                        );
                      },
                    ),
                  ),

                  // حالة المخزون بتصميم النيون
                  Positioned(
                    top: 16,
                    right: 16,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: inStock
                            ? Colors.greenAccent.withAlpha(51) // 0.2 * 255
                            : Colors.redAccent.withAlpha(51), // 0.2 * 255
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: inStock
                              ? Colors.greenAccent
                              : Colors.redAccent,
                          width: 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: inStock
                                ? Colors.greenAccent.withAlpha(128) // 0.5 * 255
                                : Colors.redAccent.withAlpha(128), // 0.5 * 255
                            blurRadius: 8,
                          ),
                        ],
                      ),
                      child: Text(
                        inStock ? "متوفر" : "قارب على النفاذ",
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,

                          shadows: [
                            Shadow(
                              color: inStock
                                  ? Colors.greenAccent
                                  : Colors.redAccent,
                              blurRadius: 5,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 8,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// اسم المنتج
                      Text(
                        item.itemsName ?? "بدون اسم",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          // color: Colors.white,
                          letterSpacing: 0.5,
                        ),
                      ),

                      const SizedBox(height: 6),

                      /// السعر (تأثير نيون مضيء)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "$price\t ${"EGP".tr}",
                            style: const TextStyle(
                              fontSize: 15,
                              color: Colors.cyanAccent,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          Row(
                            children: [
                              Text("4", style: TextStyle(fontSize: 10)),
                              Icon(
                                Icons.star_rounded,
                                color: Colors.amberAccent,
                                size: 10,
                              ),
                            ],
                          ),
                        ],
                      ),

                      const SizedBox(height: 6),

                      /// SKU والأزرار
                      SizedBox(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () => controller.gotoeditpage(item),
                              child: Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: Colors.blueAccent.withOpacity(0.2),
                                  shape: BoxShape.rectangle,
                                  border: Border.all(color: Colors.blueAccent),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(
                                  Icons.edit_rounded,
                                  color: Colors.blueAccent,
                                  size: 16,
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                AppDialog.show(
                                  title: "حذف المنتج",

                                  message: "هل تريد حذف المنتج نهائياً؟",

                                  icon: Icons.delete,

                                  color: Colors.red,

                                  confirmText: "حذف",

                                  onConfirm: () {
                                    controller.delete(
                                      item.id.toString(),

                                      item.itemsImage!,
                                    );
                                  },
                                );
                              },
                              child: Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: Colors.redAccent.withOpacity(0.2),
                                  shape: BoxShape.rectangle,
                                  border: Border.all(color: Colors.redAccent),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(
                                  Icons.delete_outline_rounded,
                                  color: Colors.redAccent,
                                  size: 16,
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
        ),
      ),
    );
  }
}
