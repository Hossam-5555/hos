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
    // double screenWidth = MediaQuery.of(context).size.width;
    final controller = Get.put(ViewItemController());

    return Scaffold(
      // عرض اسم القسم المختار ديناميكياً في الـ AppBar
      appBar: Appbarbackicon(
        title: controller.catname ?? "المنتجات",
        herotag: "",
      ),
      body: SafeArea(
        child: Column(
          children: [
            /// 🔍 1. شريط البحث
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Searchbar(
                title: "ابحث عن منتج، رمز، أو قسم...",
                mycontroller: controller.controller,
              ),
            ),

            /// 🛍️ 2. شبكة المنتجات (تحديث تلقائي)
            Expanded(
              child: GetBuilder<ViewItemController>(
                builder: (controller) {
                  return HandlingDataView(
                    imagePath: Imageasset.animation2,
                    emptyStyle: EmptyStateStyle.style2,
                    mediaType: HandlingMediaType.animation,
                    statusrequest: controller.statusrequest,
                    widget: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 200,
                            childAspectRatio: 0.78,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                          ),
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
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
                          onEdit: () => controller.gotoeditpage(item),
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

      /// ➕ 3. الزر العائم المستقبلي (Neon FAB)
      floatingActionButton: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.cyanAccent.withAlpha(102),
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
            side: BorderSide(
              color: Colors.cyanAccent.withAlpha(128),
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
            child: const Center(
              child: Icon(Icons.add_circle, color: Colors.white, size: 26),
            ),
          ),
        ),
      ),
    );
  }
}
