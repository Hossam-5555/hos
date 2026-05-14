import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hos/controler/admincontroller/items/viewitemcontroller.dart';
import 'package:hos/core/class/handlingdataview.dart';
import 'package:hos/veiw/wedget/searchbar.dart';

// ignore: camel_case_types
class viewitem extends StatelessWidget {
  const viewitem({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ViewItemController());

    return Scaffold(
      // زر الإضافة العائم المربع كما في الصورة
      floatingActionButton: FloatingActionButton(
        onPressed: controller.goToAddPage,
        backgroundColor: const Color(0xFF1134A6), // اللون الأزرق الداكن
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: const Icon(Icons.add, color: Colors.white, size: 28),
      ),
      body: Column(
        children: [
          // 1. شريط البحث (Search Bar)
          Padding(
            padding: const EdgeInsets.only(
              top: 16.0,
              left: 16.0,
              right: 16.0,
              bottom: 12.0,
            ),
            child: Searchbar(
              title: "Search products, SKUs, or categories..",
              mycontroller: controller.controller,
            ),
          ),

          // 2. الفلاتر (Filter Chips)
          SizedBox(
            height: 60,
            child: Row(
              children: [
                // استخدام Expanded هنا ضروري جداً
                Expanded(
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    itemCount: controller.categorylist.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 10),
                    itemBuilder: (context, index) {
                      return GetBuilder<ViewItemController>(
                        builder: (controller) {
                          return _buildFilterChip(
                            controller.categorylist[index].name.toString(),
                            // هنا يفضل ربط حالة الاختيار بالـ Controller
                            controller.selectedCat == index,
                            () {
                              controller.chnagecat(index);
                            },
                          );
                        }
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // 3. قائمة المنتجات (Product List)
          Expanded(
            child: GetBuilder<ViewItemController>(
              builder: (controller) {
                return Handlingdataview(
                  statusrequest: controller.statusrequest,
                  widget: ListView.separated(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    itemCount: controller.filtereditem.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 16),
                    itemBuilder: (context, index) {
                      final item = controller.filtereditem[index];
                      final imageUrl = "${item.itemsImage}";

                      // ملاحظة: يمكنك استبدال هذه القيم الوهمية بالمتغيرات الفعلية من الموديل الخاص بك
                      // مثلاً: String price = "\$${item.itemsPrice}";
                      String price = "\$199.00";
                      String sku = "SKU: WAT-001";
                      bool inStock = item.stock! > 5
                          ? true
                          : false; //จำลอง حالة المخزون (متوفر أم لا)

                      return Card(
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(color: Colors.grey.shade300),
                        ),
                        color: Colors.white,
                        clipBehavior: Clip.antiAlias,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // الجزء العلوي: الصورة + حالة المخزون
                            Stack(
                              children: [
                                Container(
                                  height: 180,
                                  width: double.infinity,
                                  color: Colors.grey.shade100,
                                  child: CachedNetworkImage(
                                    imageUrl: imageUrl,
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) => const Center(
                                      child: SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                        ),
                                      ),
                                    ),
                                    errorWidget: (context, url, error) =>
                                        const Icon(
                                          Icons.image_not_supported_outlined,
                                          color: Colors.grey,
                                        ),
                                  ),
                                ),
                                Positioned(
                                  top: 12,
                                  right: 12,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: inStock
                                          ? const Color(
                                              0xFF69FFAA,
                                            ).withOpacity(0.8)
                                          : const Color(
                                              0xFFFFCDD2,
                                            ).withOpacity(0.8),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          inStock
                                              ? Icons.check_circle_outline
                                              : Icons.warning_amber_rounded,
                                          size: 14,
                                          color: inStock
                                              ? Colors.green.shade800
                                              : Colors.red.shade800,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          inStock ? "In Stock" : "Low Stock",
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                            color: inStock
                                                ? Colors.green.shade800
                                                : Colors.red.shade800,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            // الجزء السفلي: تفاصيل المنتج
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // اسم المنتج والسعر
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF1134A6),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),

                                  // التقييمات
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.star_border,
                                        size: 16,
                                        color: Colors.greenAccent.shade400,
                                      ),
                                      Icon(
                                        Icons.star_border,
                                        size: 16,
                                        color: Colors.greenAccent.shade400,
                                      ),
                                      Icon(
                                        Icons.star_border,
                                        size: 16,
                                        color: Colors.greenAccent.shade400,
                                      ),
                                      Icon(
                                        Icons.star_border,
                                        size: 16,
                                        color: Colors.greenAccent.shade400,
                                      ),
                                      Icon(
                                        Icons.star_border,
                                        size: 16,
                                        color: Colors.grey.shade400,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        "(42)",
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  const Divider(height: 1),
                                  const SizedBox(height: 4),

                                  // رقم الـ SKU وأزرار التعديل والحذف
                                  Row(
                                    children: [
                                      Text(
                                        sku,
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey[700],
                                        ),
                                      ),
                                      const Spacer(),
                                      IconButton(
                                        icon: const Icon(
                                          Icons.edit_outlined,
                                          color: Colors.grey,
                                        ),
                                        onPressed: () =>
                                            controller.gotoeditpage(item),
                                        tooltip: "تعديل",
                                      ),
                                      IconButton(
                                        icon: const Icon(
                                          Icons.delete_outline,
                                          color: Colors.grey,
                                        ),
                                        onPressed: () {
                                          Get.defaultDialog(
                                            title: "تحذير ⚠️",
                                            middleText:
                                                "هل تريد حذف هذا المنتج",
                                            textCancel: "إلغاء",
                                            textConfirm: "حذف",
                                            confirmTextColor: Colors.white,
                                            buttonColor: Colors.redAccent,
                                            onConfirm: () {
                                              controller.delete(
                                                item.id!.toString(),
                                                item.itemsImage!,
                                              );
                                              Get.back();
                                            },
                                          );
                                        },
                                        tooltip: "حذف",
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
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // دالة مساعدة لإنشاء أزرار الفلاتر (Chips)
  Widget _buildFilterChip(
    String label,
    bool isSelected,
    void Function()? onTap,
  ) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF2A42A5) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey.shade700,
            fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
