import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:hos/controler/admincontroller/categories/viewcontroller.dart';
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
          return HandlingDataView(
            mode: HandlingMode.fullScreen,
            mediaType: HandlingMediaType.animation,
            statusrequest: controller.statusrequest,
            widget: SafeArea(
              child: controller.catdata.isEmpty
                  ? Column(
                      mainAxisAlignment:
                          MainAxisAlignment.center, // توسيط عمودي
                      children: [
                        Container(
                          padding: const EdgeInsets.all(20),
                          // تحديد أبعاد ثابتة أو نسبة من الشاشة
                          width: MediaQuery.of(context).size.width * 0.6,
                          height: MediaQuery.of(context).size.width * 0.6,
                          child: SvgPicture.asset(
                            "${Imageasset.emptycart}",
                            fit: BoxFit
                                .contain, // لضمان احتواء الصورة داخل الحاوية دون قص
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          "السلة فارغة تسوق الان ",
                          style: TextStyle(fontSize: 18, color: Colors.grey),
                        ),
                      ],
                    )
                  : GridView.builder(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 20,
                      ),
                      itemCount: controller.catdata.length,
                      // تجاوب تلقائي مع جميع مقاسات الشاشات (Responsive)
                      gridDelegate:
                          const SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 200,
                            childAspectRatio: 0.78,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
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
