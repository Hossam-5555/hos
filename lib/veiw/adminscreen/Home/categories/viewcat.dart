import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hos/controler/admincontroller/categories/viewcontroller.dart';
import 'package:hos/core/class/handlingdataview.dart';

class ViewCategories extends StatelessWidget {
  const ViewCategories({super.key});

  @override
  Widget build(BuildContext context) {
    // استخدمنا Get.put هنا، ويفضل أن يكون الـ Controller قد تم تهيئته مسبقاً في الـ Binding
    final controller = Get.put(ViewCatController());

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => controller.goToAddPage(),
        backgroundColor: Colors.black,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text("Add new category", style: TextStyle(color: Colors.white)),
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
                // تأكد من أن الرابط ليس null
                final imageUrl = item.image ?? "";

                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade200,
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        width: 60, // تحديد عرض ثابت للصورة
                        height: 60,
                        color: Colors.grey[100],
                        child: CachedNetworkImage(
                          imageUrl: imageUrl,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => const Center(
                            child: SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          ),
                          errorWidget: (context, url, error) => const Icon(
                            Icons.image_not_supported_outlined,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                    title: Text(
                      item.name ?? "بدون اسم",
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    subtitle: Text(
                      item.nameAr ?? "",
                      style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.edit_outlined,
                            color: Colors.blue,
                          ),
                          onPressed: () {
                            // هنا تضع وظيفة التعديل
                            // controller.goToEditPage(item);
                          },
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.delete_outline,
                            color: Colors.redAccent,
                          ),
                          onPressed: () {
                            Get.defaultDialog(
                              title: "تنبيه",
                              middleText: "هل أنت متأكد من حذف ${item.name}؟",
                              textCancel: "تراجع",
                              textConfirm: "حذف",
                              confirmTextColor: Colors.white,
                              buttonColor: Colors.redAccent,
                              onConfirm: () {
                                controller.delete(
                                  item.id.toString(),
                                  item.image!,
                                );
                                Get.back();
                              },
                            );
                          },
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
