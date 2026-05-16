import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hos/controler/admincontroller/items/viewitemcontroller.dart';
import 'package:hos/core/class/handlingdataview.dart';
import 'package:hos/veiw/wedget/searchbar.dart';

class ViewItemScreen extends StatelessWidget {
  const ViewItemScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ViewItemController());

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: controller.goToAddPage,
        backgroundColor: const Color(0xFF1134A6),
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: const Icon(Icons.add, color: Colors.white, size: 28),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // 1. شريط البحث
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Searchbar(
                title: "ابحث عن منتج، رمز، أو قسم...",
                mycontroller: controller.controller,
              ),
            ),

            // 2. الفلاتر (أقسام المنتجات)
            SizedBox(
              height: 50,
              child: GetBuilder<ViewItemController>(
                builder: (controller) {
                  return ListView.separated(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: controller.categorylist.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 10),
                    itemBuilder: (context, index) {
                      final isSelected = controller.selectedCat == index;
                      return _buildFilterChip(
                        label: controller.categorylist[index].name.toString(),
                        isSelected: isSelected,
                        onTap: () => controller.chnagecat(index),
                      );
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 12),

            // 3. قائمة المنتجات
            Expanded(
              child: GetBuilder<ViewItemController>(
                builder: (controller) {
                  return Handlingdataview(
                    statusrequest: controller.statusrequest,
                    widget: ListView.separated(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 80), // مسافة سفلية للزر العائم
                      itemCount: controller.filtereditem.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 16),
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
    );
  }

  // تصميم الفلاتر العصري
  Widget _buildFilterChip({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF1134A6) : Colors.white,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
            color: isSelected ? Colors.transparent : Colors.grey.shade300,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: const Color(0xFF1134A6).withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  )
                ]
              : [],
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey.shade700,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

// ==========================================
// ويدجت مستقل لكارت المنتج (لترتيب الكود وتنظيفه)
// ==========================================
class ProductCard extends StatelessWidget {
  final dynamic item; // يفضل تغييره لنوع الموديل الخاص بك (مثلاً ItemModel)
  final ViewItemController controller;

  const ProductCard({super.key, required this.item, required this.controller});

  @override
  Widget build(BuildContext context) {
    final String imageUrl = "${item.itemsImage}";
    const String price = "\$199.00"; // استبدلها بـ: "\$${item.itemsPrice}"
    const String sku = "SKU: WAT-001";
    final bool inStock = (item.stock ?? 0) > 5; // محاكاة المخزون

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            spreadRadius: 1,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. صورة المنتج وحالة المخزون
          Stack(
            children: [
              Container(
                height: 160,
                width: double.infinity,
                color: Colors.grey.shade100,
                child: CachedNetworkImage(
                  imageUrl: imageUrl,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => const Center(
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                  errorWidget: (context, url, error) => const Icon(
                    Icons.image_not_supported_outlined,
                    color: Colors.grey,
                    size: 40,
                  ),
                ),
              ),
              Positioned(
                top: 12,
                right: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: inStock
                        ? Colors.green.shade50.withOpacity(0.9)
                        : Colors.red.shade50.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: inStock ? Colors.green.shade200 : Colors.red.shade200,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        inStock ? Icons.check_circle : Icons.warning_rounded,
                        size: 14,
                        color: inStock ? Colors.green.shade700 : Colors.red.shade700,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        inStock ? "متوفر" : "قارب على النفاذ",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: inStock ? Colors.green.shade700 : Colors.red.shade700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // 2. تفاصيل المنتج
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        item.itemsName ?? "بدون اسم",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      price,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF1134A6),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                
                // التقييم (يمكن جعله Dynamic لاحقاً)
                Row(
                  children: [
                    ...List.generate(
                      4,
                      (index) => Icon(Icons.star_rounded, size: 18, color: Colors.amber.shade400),
                    ),
                    Icon(Icons.star_outline_rounded, size: 18, color: Colors.grey.shade400),
                    const SizedBox(width: 6),
                    Text(
                      "(42)",
                      style: TextStyle(fontSize: 13, color: Colors.grey.shade500),
                    ),
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Divider(height: 1),
                ),

                // 3. الإجراءات (تعديل - حذف - SKU)
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        sku,
                        style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                      ),
                    ),
                    const Spacer(),
                    Material(
                      color: Colors.transparent,
                      child: IconButton(
                        icon: const Icon(Icons.edit_rounded, color: Color(0xFF1134A6)),
                        onPressed: () => controller.gotoeditpage(item),
                        tooltip: "تعديل",
                        splashRadius: 24,
                      ),
                    ),
                    Material(
                      color: Colors.transparent,
                      child: IconButton(
                        icon: const Icon(Icons.delete_rounded, color: Colors.redAccent),
                        onPressed: () => _showDeleteDialog(context),
                        tooltip: "حذف",
                        splashRadius: 24,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // دالة عرض تحذير الحذف بتصميم أنيق
  void _showDeleteDialog(BuildContext context) {
    Get.defaultDialog(
      title: "تأكيد الحذف",
      titleStyle: const TextStyle(fontWeight: FontWeight.bold, color: Colors.redAccent),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      middleText: "هل أنت متأكد من رغبتك في حذف هذا المنتج بشكل نهائي؟",
      textCancel: "إلغاء",
      textConfirm: "حذف",
      cancelTextColor: Colors.grey.shade800,
      confirmTextColor: Colors.white,
      buttonColor: Colors.redAccent,
      radius: 12,
      onConfirm: () {
        controller.delete(item.id!.toString(), item.itemsImage!);
        Get.back(); // لإغلاق النافذة
      },
    );
  }
}