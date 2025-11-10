import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:hos/controler/admincontroller/categories/viewcontroller.dart';
import 'package:hos/core/class/handlingdataview.dart';
import 'package:hos/core/conistant/linkApi.dart';

class ViewCategories extends StatelessWidget {
  const ViewCategories({super.key});

  @override
  Widget build(BuildContext context) {
    // 🟢 أنشئ الـ controller هنا مرة واحدة فقط
    final controller = Get.put(ViewCatController(), permanent: false);

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: controller.goToAddPage,
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(
        title: const Text("الفئات"),
        leading: IconButton(
          onPressed: () {
            controller.backtohomebage();
          },
          icon: Icon(Icons.arrow_back),
        ),
      ),

      // 🟢 استخدم GetBuilder علشان يحدث الواجهة لما الداتا تتغير
      body: GetBuilder<ViewCatController>(
        builder: (controller) {
          return Handlingdataview(
            statusrequest: controller.statusrequest,
            widget: ListView.builder(
              itemCount: controller.catdata.length,
              itemBuilder: (context, index) {
                final item = controller.catdata[index];
                return Card(
                  child: Row(
                    children: [
                      Expanded(
                        child: ListTile(
                          title: Text(item.categoriesName ?? "بدون اسم"),
                        ),
                      ),
                      SizedBox(
                        height: 80,
                        width: 80,
                        child:
                            (item.categoriesImage != null &&
                                item.categoriesImage!.toLowerCase().endsWith(
                                  ".svg",
                                ))
                            ? SvgPicture.network(
                                "${LinkApi.imagecategories}/${item.categoriesImage}",
                                fit: BoxFit.contain,
                              )
                            : Image.network(
                                "${LinkApi.imagecategories}/${item.categoriesImage}",
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    const Icon(Icons.image_not_supported),
                              ),
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
