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
    final controller = Get.put(ViewCatController());

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: controller.goToAddPage,
        backgroundColor: Colors.black,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text("إضافة فئة", style: TextStyle(color: Colors.white)),
      ),

      body: GetBuilder<ViewCatController>(
        builder: (controller) {
          return Handlingdataview(
            statusrequest: controller.statusrequest,
            widget: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: controller.catdata.length,
              separatorBuilder: (_, _) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final item = controller.catdata[index];
                final imageUrl =
                    "${LinkApi.imagecategories}/${item.categoriesImage}";

                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade300,
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child:
                          (item.categoriesImage != null &&
                              item.categoriesImage!.toLowerCase().endsWith(
                                ".svg",
                              ))
                          ? SvgPicture.network(
                              imageUrl,
                              width: 60,
                              height: 60,
                              fit: BoxFit.contain,
                            )
                          : Image.network(
                              imageUrl,
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                              errorBuilder: (_, _, _) => Container(
                                width: 60,
                                height: 60,
                                color: Colors.grey[200],
                                child: const Icon(
                                  Icons.image_not_supported,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                    ),
                    title: Text(
                      item.categoriesName ?? "بدون اسم",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    subtitle: Text(
                      item.categoriesNameAr ?? "",
                      style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.edit,
                            color: Colors.blueAccent,
                          ),
                          onPressed: () => controller.gotoeditpage(item),
                          tooltip: "تعديل",
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.delete,
                            color: Colors.redAccent,
                          ),
                          onPressed: () {
                            Get.defaultDialog(
                              title: "تحذير ⚠️",
                              middleText: "هل تريد حذف هذا القسم؟",
                              textCancel: "إلغاء",
                              textConfirm: "حذف",
                              confirmTextColor: Colors.white,
                              buttonColor: Colors.redAccent,
                              onConfirm: () {
                                controller.delete(
                                  item.categoriesId!,
                                  item.categoriesImage!,
                                );
                                Get.back();
                              },
                            );
                          },
                          tooltip: "حذف",
                        ),
                      ],
                    ),
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
