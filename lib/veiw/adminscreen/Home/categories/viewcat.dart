import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hos/controler/admincontroller/categories/viewcontroller.dart';
import 'package:hos/data/services/crud.dart';
import 'package:hos/core/class/handlingdataview.dart';
import 'package:hos/core/conistant/imageasset.dart';
import 'package:hos/core/functions/showdialoge.dart';
import 'package:hos/veiw/wedget/Admin/SheardCard.dart';

class ViewCategories extends StatelessWidget {
  const ViewCategories({super.key});

  @override
  Widget build(BuildContext context) {
    // حقن الـ Controller
    final c = Get.put(ViewCatController());
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
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                              hPad,
                              5,
                              hPad,
                              12,
                            ),
                            child: Container(
                              padding: EdgeInsets.all(compact ? 12 : 16),
                              decoration: BoxDecoration(
                                color: isDark
                                    ? const Color(0xFF323538)
                                    : const Color(0xFFE0E3E8),
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withAlpha(8),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: const Color(
                                        0xFF00F2FE,
                                      ).withAlpha(31),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.inventory_2_outlined,
                                      color: Color(0xFF0284C7),
                                      size: 18,
                                    ),
                                  ),
                                  SizedBox(width: compact ? 8 : 12),

                                  // النصوص تاخد المساحة المتاحة
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Categories'.tr,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          '${controller.catdata.length} ${'categories'.tr}',
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            fontSize: 13,
                                            color: Color(0xFF6B7280),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: compact ? 8 : 12),

                                  // زر إضافة قسم
                                  Flexible(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        gradient: const LinearGradient(
                                          colors: [
                                            Color(0xFF00F2FE),
                                            Color(0xFF4FACFE),
                                          ],
                                          begin: AlignmentDirectional
                                              .centerStart,
                                          end: AlignmentDirectional.centerEnd,
                                        ),
                                        borderRadius: BorderRadius.circular(12),
                                        boxShadow: [
                                          BoxShadow(
                                            color: const Color(
                                              0xFF4FACFE,
                                            ).withAlpha(89),
                                            blurRadius: 8,
                                            offset: const Offset(0, 3),
                                          ),
                                        ],
                                      ),
                                      child: Material(
                                        color: Colors.transparent,
                                        child: InkWell(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          onTap: () => c.goToAddPage(),
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: compact ? 8 : 12,
                                              vertical: 8,
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                const Icon(
                                                  Icons.add_rounded,
                                                  color: Colors.white,
                                                  size: 20,
                                                ),
                                                const SizedBox(width: 4),
                                                Flexible(
                                                  child: FittedBox(
                                                    fit: BoxFit.scaleDown,
                                                    child: Text(
                                                      'add_category'.tr,
                                                      maxLines: 1,
                                                      style: const TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 13,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
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