import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hos/controler/admincontroller/categories/viewcontroller.dart';
import 'package:hos/core/class/handlingdataview.dart';
import 'package:hos/core/functions/showdialoge.dart';
import 'package:hos/veiw/adminscreen/Home/categories/addcat.dart';

class ViewCategories extends StatelessWidget {
  const ViewCategories({super.key});

  @override
  Widget build(BuildContext context) {
    // حقن الـ Controller في الـ Memory
    Get.put(ViewCatController());

    // final ThemeData theme = Theme.of(context);

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.to(
          () => const Addcategories(),
          transition: Transition.cupertino,
        ),
        backgroundColor: Colors.transparent, // شفاف ليظهر التدرج
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
          child: Center(
            child: Icon(
              Icons.add_moderator_rounded,
              color: Colors.white,
              size: 28,
            ),
          ),
        ),
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
                    isarabic: controller.isarabic,
                    onTap: () {
                      controller.gotoproducts(categoryItem);
                    },
                    item: categoryItem,
                    onEdit: () => controller.gotoeditpage(categoryItem),
                    onDelete: () {
                      AppCupertinoDialog.show(
                        title: "حذف المنتج",
                        message: "هل أنت متأكد من حذف المنتج؟",
                        onConfirm: () {
                          controller.delete(categoryItem.id!);
                        },
                      );
                    },
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
}

// ==========================================
// كارت القسم كـ Widget مستقل لتحسين الأداء (Highly Optimized Widget)
// ==========================================
// ignore: must_be_immutable
class CategoryCard extends StatelessWidget {
  final dynamic item;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final void Function() onTap;
  bool isarabic;
  CategoryCard({
    super.key,
    required this.item,
    required this.onEdit,
    required this.onDelete,
    required this.onTap,
    required this.isarabic,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap, // النقر على الكارت نفسه يفتح صفحة التعديل
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20), // حواف دائرية ناعمة جداً
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // 1. عرض الصورة بالكامل في النصف العلوي
                  Expanded(
                    child: CachedNetworkImage(
                      imageUrl: item.image ?? "",
                      fit: BoxFit.contain,
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
                ],
              ),
              Positioned(
                top: 8,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 8,
                  ),
                  child: Text(
                    isarabic ? item.nameAr ?? "" : item.name ?? "",
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow:
                        TextOverflow.ellipsis, // حماية الكارت من الـ Overflow
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ),

              // 3. أزرار التحكم العائمة بتصميم زجاجي أنيق فوق الصورة
              Positioned(
                bottom: 10,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),

                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 5,
                        vertical: 1,
                      ),
                      alignment: Alignment.center,
                      width: 180,
                      height: 40, // حجم مناسب لأزرار التحكم
                      decoration: BoxDecoration(
                        color: Colors.white.withAlpha(50),
                        borderRadius: BorderRadius.circular(40),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildActionButton(
                            icon: Icons.edit_rounded,
                            iconColor: Colors.blueAccent,
                            onTap: onEdit,
                          ),
                          const SizedBox(width: 8),
                          _buildActionButton(
                            icon: Icons.delete_rounded,
                            iconColor: Colors.redAccent,
                            onTap: onDelete,
                          ),
                        ],
                      ),
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
