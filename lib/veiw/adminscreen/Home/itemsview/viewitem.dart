import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hos/controler/admincontroller/items/viewitemcontroller.dart';
import 'package:hos/core/class/handlingdataview.dart';
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
    final w = MediaQuery.of(context).size.width;
   bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: Appbarbackicon(
        title: controller.catname ?? "المنتجات",
        herotag: "veiwproducts",
      ),
      body: SafeArea(
        child: Column(
          children: [
            /// 🔍 1. شريط البحث
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 6),
              child: Searchbar(onPressedIcon: () {
                print("Search icon pressed");
              },
                title: "ابحث عن منتج، رمز، أو قسم...",
                mycontroller: controller.controller,
              ),
            ),

            /// 📊 2. كارت معلومات القسم وزر "إضافة منتج"
            GetBuilder<ViewItemController>(
              builder: (controller) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: isDark ? Color(0xFF323538) : Color(0xFFE0E3E8),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.03),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // إحصائية عدد المنتجات
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: const Color(0xFF00F2FE).withOpacity(0.12),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.inventory_2_outlined,
                              color: Color(0xFF0284C7),
                              size: 18,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "إجمالي المنتجات",
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                "${controller.itemlist.length} منتج",
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey.shade500,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),

                      // ➕ زر إضافة منتج متناسق مع التدرج
                      Container(
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF00F2FE), Color(0xFF4FACFE)],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF4FACFE).withOpacity(0.35),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(12),
                            onTap: controller.goToAddItem,
                            child: const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.add_rounded, color: Colors.white, size: 18),
                                  SizedBox(width: 4),
                                  Text(
                                    "إضافة منتج",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
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
            ),

            /// 🛍️ 3. شبكة المنتجات
            Expanded(
              child: GetBuilder<ViewItemController>(
                builder: (controller) {
                  return HandlingDataView(
                    imagePath: Imageasset.animation2,
                    emptyStyle: EmptyStateStyle.style2,
                    mediaType: HandlingMediaType.animation,
                    statusrequest: controller.statusrequest,
                    widget: GridView.builder(
                      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 0.48 * w, // تجاوب ممتاز مع الشاشات
                        childAspectRatio: 0.76,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                      ),
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                              title: "حذف المنتج",
                              message: "هل أنت متأكد من حذف المنتج؟",
                              onConfirm: () {
                                controller.delete(item.id!);
                              },
                            );
                          },
                          imageUrl: item.itemsImage!,
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
}