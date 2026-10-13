import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hos/controler/admincontroller/items/viewitemcontroller.dart';
import 'package:hos/core/class/handlingdataview.dart';
import 'package:hos/core/conistant/app_colors.dart';
import 'package:hos/core/conistant/imageasset.dart';
import 'package:hos/core/functions/showdialoge.dart';
import 'package:hos/veiw/wedget/Admin/SheardCard.dart';
import 'package:hos/veiw/wedget/appbarbackicon.dart';
import 'package:hos/veiw/wedget/searchbar.dart';

class ViewItemScreen extends StatelessWidget {
  const ViewItemScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ViewItemController());
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: Appbarbackicon(
        title: controller.catname ?? 'المنتجات',
        herotag: 'veiwproducts',
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth;
            final isCompact = width < 360;
            final isTablet = width >= 600;
            final horizontalPadding = isTablet ? 24.0 : 16.0;
            final contentMaxWidth = width >= 1100 ? 1100.0 : double.infinity;

            return Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: contentMaxWidth),
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(
                        horizontalPadding,
                        12,
                        horizontalPadding,
                        6,
                      ),
                      child: Searchbar(
                        onPressedIcon: () {
                          debugPrint('Search icon pressed');
                        },
                        title: 'ابحث عن منتج، رمز، أو قسم...',
                        mycontroller: controller.controller,
                      ),
                    ),
                    GetBuilder<ViewItemController>(
                      builder: (controller) => Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: horizontalPadding,
                          vertical: 6,
                        ),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: isCompact ? 10 : 14,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: isDark
                                ? AppColors.darkCardSurface
                                : AppColors.editBackground,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: isDark
                                  ? AppColors.darkBorder
                                  : AppColors.lightBorder,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: isDark
                                    ? AppColors.darkShadow
                                    : AppColors.lightShadow,
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Row(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(isCompact ? 6 : 8),
                                      decoration: BoxDecoration(
                                        color: const Color(0x1F00F2FE),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        Icons.inventory_2_outlined,
                                        color: const Color(0xFF0284C7),
                                        size: isCompact ? 17 : 19,
                                      ),
                                    ),
                                    SizedBox(width: isCompact ? 7 : 10),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            'إجمالي المنتجات',
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontSize: isCompact ? 11 : 13,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            '${controller.itemlist.length} منتج',
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontSize: isCompact ? 10 : 11,
                                              color: AppColors.mutedText,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),
                              DecoratedBox(
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [
                                      AppColors.primaryStart,
                                      AppColors.primaryEnd,
                                    ],
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Color(0x594FACFE),
                                      blurRadius: 8,
                                      offset: Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(12),
                                    onTap: controller.goToAddItem,
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: isCompact ? 9 : 12,
                                        vertical: 9,
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Icon(
                                            Icons.add_rounded,
                                            color: Colors.white,
                                            size: 18,
                                          ),
                                          if (!isCompact) ...[
                                            const SizedBox(width: 4),
                                            const Text(
                                              'إضافة منتج',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
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
                    ),
                    Expanded(
                      child: GetBuilder<ViewItemController>(
                        builder: (controller) {
                          return HandlingDataView(
                            imagePath: Imageasset.animation2,
                            emptyStyle: EmptyStateStyle.style2,
                            mediaType: HandlingMediaType.animation,
                            statusrequest: controller.statusrequest,
                            widget: LayoutBuilder(
                              builder: (context, gridConstraints) {
                                final gridWidth = gridConstraints.maxWidth;
                                final columns = gridWidth < 420
                                    ? 2
                                    : gridWidth < 700
                                        ? 3
                                        : gridWidth < 1000
                                            ? 4
                                            : 5;
                                final availableWidth = gridWidth -
                                    (horizontalPadding * 2) -
                                    (12 * (columns - 1));
                                final tileWidth = availableWidth / columns;
                                final ratio = tileWidth < 155
                                    ? 0.68
                                    : tileWidth < 210
                                        ? 0.74
                                        : tileWidth < 270
                                            ? 0.80
                                            : 0.88;

                                return GridView.builder(
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: columns,
                                    childAspectRatio: ratio,
                                    crossAxisSpacing: 12,
                                    mainAxisSpacing: 12,
                                  ),
                                  physics: const BouncingScrollPhysics(),
                                  padding: EdgeInsets.symmetric(
                                    horizontal: horizontalPadding,
                                    vertical: 12,
                                  ),
                                  itemCount: controller.itemlist.length,
                                  itemBuilder: (context, index) {
                                    final item = controller.itemlist[index];
                                    return CategoryCard.items(
                                      price: item.itemsPrice.toString(),
                                      stock: item.stock.toString(),
                                      onTap: () {},
                                      name: controller.isarabic
                                          ? item.itemsNameAr
                                          : item.itemsName,
                                      onEdit: () => controller.goToEditItem(item),
                                      onDelete: () {
                                        AppCupertinoDialog.show(
                                          title: 'حذف المنتج',
                                          message: 'هل أنت متأكد من حذف المنتج؟',
                                          onConfirm: () {
                                            if (item.id != null) {
                                              controller.delete(item.id!);
                                            }
                                          },
                                        );
                                      },
                                      imageUrl: item.itemsImage ?? '',
                                    );
                                  },
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
          },
        ),
      ),
    );
  }
}
