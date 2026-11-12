import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hos/controler/admincontroller/items/viewitemcontroller.dart';
import 'package:hos/core/class/handlingdataview.dart';
import 'package:hos/core/conistant/imageasset.dart';
import 'package:hos/core/functions/showdialoge.dart';
import 'package:hos/veiw/wedget/Admin/SheardCard.dart';
import 'package:hos/veiw/wedget/Admin/adminsectionheader.dart';
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
                    GetBuilder<ViewItemController>(
                      builder: (controller) => AdminSectionHeader(
                        title: 'إجمالي المنتجات',
                        subtitle: 'المنتجات الموجودة بالمخزن',
                        count: controller.itemlist.length,
                        countLabel: 'منتج',
                        icon: Icons.poll_rounded,
                        onAdd: controller.goToAddItem,
                        addButtonText: 'إضافة منتج',
                        isDark: isDark,
                        isCompact: isCompact,
                      ),
                    ),
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
                    Expanded(
                      child: GetBuilder<ViewItemController>(
                        builder: (controller) {
                          return HandlingDataView(
                            imagePath: Imageasset.nodata,
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
                                final availableWidth =
                                    gridWidth -
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
                                      onEdit: () =>
                                          controller.goToEditItem(item),
                                      onDelete: () {
                                        AppCupertinoDialog.show(
                                          title: 'حذف المنتج',
                                          message:
                                              'هل أنت متأكد من حذف المنتج؟',
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
