import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hos/controler/admincontroller/categories/viewcontroller.dart';
import 'package:hos/core/class/handlingdataview.dart';
import 'package:hos/veiw/adminscreen/Home/categories/addcat.dart';

class ViewCategories extends StatelessWidget {
  const ViewCategories({super.key});

  @override
  Widget build(BuildContext context) {
    // حقن الـ Controller في الـ Memory
    Get.put(ViewCatController());

    final ThemeData theme = Theme.of(context);

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Get.to(() => const Addcategories()),
        label: const Text(
          "قسم جديد",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        icon: const Icon(Icons.add_rounded),
        backgroundColor: theme.primaryColor,
        elevation: 4,
      ),
      body: GetBuilder<ViewCatController>(
        builder: (controller) {
          return Handlingdataview(
            statusrequest: controller.statusrequest,
            widget: SafeArea(
              child: GridView.builder(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 20,
                ),
                itemCount: controller.catdata.length,
                // تجاوب تلقائي مع جميع مقاسات الشاشات (Responsive)
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 200,
                  childAspectRatio: 0.78,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemBuilder: (context, index) {
                  final categoryItem = controller.catdata[index];
                  return CategoryCard(
                    item: categoryItem,
                    onEdit: () => controller.gotoeditpage(categoryItem),
                    onDelete: () => _showDeleteConfirmationDialog(
                      context,
                      controller,
                      categoryItem,
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }

  // دالة إظهار نافذة التأكيد منفصلة ومستقلة لتبسيط الـ build method
  void _showDeleteConfirmationDialog(
    BuildContext context,
    ViewCatController controller,
    dynamic item,
  ) {
    Get.defaultDialog(
      title: "تأكيد الحذف",
      titleStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
      contentPadding: const EdgeInsets.all(16),
      middleText:
          "هل أنت متأكد من حذف قسم '${item.name}'؟\nسيتم حذف جميع العناصر المرتبطة به نهائياً.",
      middleTextStyle: const TextStyle(color: Colors.black54, height: 1.5),
      textCancel: "إلغاء",
      textConfirm: "حذف",
      confirmTextColor: Colors.white,
      buttonColor: Theme.of(context).colorScheme.error,
      onConfirm: () {
        controller.delete(item.id!);
        Get.back();
      },
    );
  }
}

// ==========================================
// كارت القسم كـ Widget مستقل لتحسين الأداء (Highly Optimized Widget)
// ==========================================
class CategoryCard extends StatelessWidget {
  final dynamic item;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const CategoryCard({
    super.key,
    required this.item,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24), // حواف دائرية ناعمة جداً
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 1. عرض الصورة بالكامل في النصف العلوي
                Expanded(
                  flex: 11,
                  child: CachedNetworkImage(
                    imageUrl: item.image ?? "",
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      color: Colors.grey[100],
                      child: const Center(
                        child: SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(strokeWidth: 2.5),
                        ),
                      ),
                    ),
                    errorWidget: (context, url, error) => Container(
                      color: const Color(0xffF4F6FA),
                      child: const Icon(
                        Icons.image_not_supported_rounded,
                        color: Colors.grey,
                        size: 28,
                      ),
                    ),
                  ),
                ),
                // 2. تفاصيل النصوص في النصف السفلي
                Expanded(
                  flex: 8,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          item.name ?? "",
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow
                              .ellipsis, // حماية الكارت من الـ Overflow
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          item.nameAr ?? "",
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.black45,
                            fontFamily:
                                'Cairo', // يفضل لو تستخدم خط كايرو للعربي
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // 3. أزرار التحكم العائمة بتصميم زجاجي أنيق فوق الصورة
            Positioned(
              top: 8,
              right: 8,
              child: _buildActionButton(
                icon: Icons.edit_rounded,
                iconColor: Colors.blueAccent,
                onTap: onEdit,
              ),
            ),
            Positioned(
              top: 8,
              left: 8,
              child: _buildActionButton(
                icon: Icons.delete_outline_rounded,
                iconColor: Theme.of(context).colorScheme.error,
                onTap: onDelete,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // بناء زر تحكم مخصص ومصغر بشكل احترافي
  Widget _buildActionButton({
    required IconData icon,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(
            0.9,
          ), // خلفية شبه شفافة تتماشى مع أي صورة خلفها
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Icon(icon, color: iconColor, size: 18),
      ),
    );
  }
}
