import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hos/controler/admincontroller/categories/viewcontroller.dart';
import 'package:hos/core/class/crud.dart';
import 'package:hos/core/class/handlingdataview.dart';
import 'package:hos/core/conistant/imageasset.dart';
import 'package:hos/core/functions/showdialoge.dart';
import 'package:hos/veiw/adminscreen/Home/categories/addcat.dart';
import 'package:hos/veiw/wedget/Admin/SheardCard.dart';

class ViewCategories extends StatelessWidget {
  const ViewCategories({super.key});

  @override
  Widget build(BuildContext context) {
    // حقن الـ Controller في الـ Memory
    Get.put(ViewCatController());

    // final ThemeData theme = Theme.of(context);
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;

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
          side: BorderSide(color: Colors.cyanAccent.withAlpha(127), width: 1.5),
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
            child: Icon(Icons.add_circle, color: Colors.white, size: 0.074 * w),
          ),
        ),
      ),
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
              child: GridView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: controller.catdata.length,
                // تجاوب تلقائي مع جميع مقاسات الشاشات (Responsive)
                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent:
                      0.45 * w, // أقصى عرض للكرت يكون 45% من عرض الهاتف
                  childAspectRatio:
                      0.78, // النسب تثبت زي ما هي (نسبة عرض الكرت لطوله)
                  crossAxisSpacing:
                      0.02 * w, // مسافة بين الأعمدة 2% من عرض الهاتف
                  mainAxisSpacing: 0.01 * h,
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
                    imageUrl: categoryItem.image!,
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
