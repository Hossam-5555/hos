import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hos/controler/admincontroller/categories/viewcontroller.dart';
import 'package:hos/data/services/crud.dart';
import 'package:hos/core/class/handlingdataview.dart';
import 'package:hos/core/conistant/imageasset.dart';
import 'package:hos/core/functions/showdialoge.dart';
import 'package:hos/veiw/wedget/Admin/SheardCard.dart';
import 'package:hos/veiw/wedget/Admin/adminsectionheader.dart';

class ViewCategories extends StatelessWidget {
  const ViewCategories({super.key});

  @override
  Widget build(BuildContext context) {
    // حقن الـ Controller
    Get.put(ViewCatController());
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: GetBuilder<ViewCatController>(
        builder: (controller) {
          return HandlingDataView(
            mode: HandlingMode.fullScreen,
            emptyStyle: EmptyStateStyle.style2,
            mediaType: HandlingMediaType.animation,
            imagePath: Imageasset.emptystate,
            statusrequest: controller.catdata.isEmpty
                ? Statusrequest.failure
                : controller.statusrequest,
            widget: SafeArea(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final w = constraints.maxWidth;
                  final compact = w < 360;

                  // padding أفقي حسب حجم الشاشة
                  final hPad = w >= 800 ? 32.0 : (compact ? 12.0 : 16.0);

                  // عدد الأعمدة حسب العرض (2 على الموبايل، وأكتر على التابلت/الويب)
                  final columns = (w / 200).floor().clamp(2, 6);
                  final gap = compact ? 8.0 : 12.0;

                  return Align(
                    alignment: Alignment.topCenter,
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 1200),
                      child: Column(
                        children: [
                          // --- كارت علوي يعرض إحصائية الأقسام ---
                          AdminSectionHeader(
                            title: 'إجمالي التصنيفات',
                            subtitle: 'التصنيفات المتاحة',
                            count: controller.catdata.length,
                            countLabel: 'تصنيف',
                            icon: Icons.category_outlined,
                            onAdd: controller.goToAddPage,
                            addButtonText: 'إضافة تصنيف',
                            isDark: isDark,
                            isCompact: false,
                          ),

                          // --- شبكة الأقسام (GridView) ---
                          Expanded(
                            child: GridView.builder(
                              padding: EdgeInsets.symmetric(
                                horizontal: hPad,
                                vertical: 8,
                              ),
                              itemCount: controller.catdata.length,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: columns,
                                    childAspectRatio: 0.82,
                                    crossAxisSpacing: gap,
                                    mainAxisSpacing: gap,
                                  ),
                              itemBuilder: (context, index) {
                                final categoryItem = controller.catdata[index];
                                return CategoryCard(
                                  onTap: () {
                                    controller.gotoproducts(categoryItem);
                                  },
                                  name: controller.isarabic
                                      ? categoryItem.nameAr
                                      : categoryItem.name,
                                  onEdit: () =>
                                      controller.goToEditPage(categoryItem),
                                  onDelete: () {
                                    AppCupertinoDialog.show(
                                      title: "حذف القسم",
                                      message: "هل أنت متأكد من حذف هذا القسم؟",
                                      onConfirm: () {
                                        controller.delete(categoryItem.id!);
                                      },
                                    );
                                  },
                                  imageUrl: categoryItem.image!,
                                );
                              },
                            ),
                          ),
                        ],
                      ),
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
}
