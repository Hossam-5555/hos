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
      // عرض اسم القسم المختار ديناميكياً في الـ AppBar
      appBar: AppBar(
        title: Text(controller.catname ?? "المنتجات"),
        leading: const BackButton(),
      ),
      body: SafeArea(
        child: Column(
          children: [
            /// 🔍 1. شريط البحث
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.cyanAccent.withOpacity(0.1),
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

            /// 🛍️ 2. شبكة المنتجات (تحديث تلقائي)
            Expanded(
              child: GetBuilder<ViewItemController>(
                builder: (controller) {
                  return Handlingdataview(
                    statusrequest: controller.statusrequest,
                    widget: GridView.builder(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
                      itemCount: controller.itemlist.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: screenWidth > 700 ? 4 : 2,
                        // نسبة الطول إلى العرض آمنة ومريحة للشاشات المختلفة
                        childAspectRatio: screenWidth > 700 ? 0.65 : 0.60, 
                        crossAxisSpacing: 14,
                        mainAxisSpacing: 14,
                      ),
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
            side: BorderSide(color: Colors.cyanAccent.withOpacity(0.5), width: 1.5),
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
              child: Icon(Icons.add_moderator_rounded, color: Colors.white, size: 26),
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

    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.grey.withOpacity(0.15), width: 1.2),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white.withOpacity(0.08),
                Colors.white.withOpacity(0.02),
              ],
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              
              /// 🖼️ أ) صورة المنتج (أصبحت ديناميكية ومحمية من الـ Overflow)
              Expanded(
                flex: 11, // تعطي المساحة الأكبر للصورة
                child: Stack(
                  children: [
                    Container(
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
                          child: CircularProgressIndicator(color: Colors.cyanAccent, strokeWidth: 2),
                        ),
                        errorWidget: (_, __, ___) => const Icon(Icons.image_not_supported, size: 30, color: Colors.white30),
                      ),
                    ),

                    // مؤشر حالة المخزون النيون
                    Positioned(
                      top: 12,
                      right: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: inStock ? Colors.greenAccent.withOpacity(0.15) : Colors.redAccent.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: inStock ? Colors.greenAccent : Colors.redAccent, width: 1),
                          boxShadow: [
                            BoxShadow(
                              color: inStock ? Colors.greenAccent.withOpacity(0.3) : Colors.redAccent.withOpacity(0.3),
                              blurRadius: 6,
                            ),
                          ],
                        ),
                        child: Text(
                          inStock ? "In Stock" : "Low Stock",
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                            color: inStock ? Colors.greenAccent : Colors.redAccent,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              /// 📝 ب) تفاصيل المنتج والأزرار (مغلفة بـ Flexible لتجنب أي تداخل مستقبلي)
              Flexible(
                flex: 8, // مساحة كافية للنصوص والتحكم
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(10, 2, 10, 8),
                  child: Column(
                    // توزيع العناصر بالتساوي لضمان المظهر المتناسق مهما اختلف حجم الخط
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly, 
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // اسم المنتج
                      Text(
                        item.itemsName ?? "بدون اسم",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, letterSpacing: 0.5),
                      ),

                      // السعر والتقييم
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Text(
                              "${item.itemsPrice} ${"EGP".tr}",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontSize: 13, color: Colors.cyanAccent, fontWeight: FontWeight.w900),
                            ),
                          ),
                          const Row(
                            children: [
                              Text("4", style: TextStyle(fontSize: 10)),
                              Icon(Icons.star_rounded, color: Colors.amberAccent, size: 12),
                            ],
                          ),
                        ],
                      ),

                      // أزرار التحكم للأدمن (تعديل / حذف)
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
                              AppDialog.show(
                                title: "حذف المنتج",
                                message: "هل تريد حذف المنتج نهائياً؟",
                                icon: Icons.delete,
                                color: Colors.red,
                                confirmText: "حذف",
                                onConfirm: () => controller.delete(item.id.toString(), item.itemsImage!),
                              );
                            },
                          ),
                        ],
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

  // دالة مساعدة (Helper Method) لاختصار كود تصميم أزرار التعديل والحذف وتجنب التكرار
  Widget _buildAdminButton({required IconData icon, required Color color, required VoidCallback onTap}) {
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