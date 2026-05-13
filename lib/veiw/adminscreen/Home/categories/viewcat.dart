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
    Get.put(ViewCatController());

    return Scaffold(
      body: GetBuilder<ViewCatController>(
        builder: (controller) {
          return Handlingdataview(
            statusrequest: controller.statusrequest,
            widget: Column(
              children: [
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    const Text(
                      "Add Category",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton.filled(
                      tooltip: "Add Category",
                      padding: EdgeInsets.all(5),
                      style: ButtonStyle(
                        elevation: MaterialStateProperty.all(0.50),
                        backgroundColor: MaterialStateProperty.all(Colors.blue),
                      ),
                      icon: const Icon(Icons.add, color: Colors.black87),
                      onPressed: () => controller.goToAddPage(),
                    ),
                  ],
                ),
                Expanded(
                  child: ListView.separated(
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
                              color: Colors.grey.shade50,
                              blurRadius: 2.5,
                              offset: const Offset(0, 2),
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
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  ),
                                ),
                                errorWidget: (context, url, error) =>
                                    const Icon(
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
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[500],
                            ),
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
                                  color: Colors.black,
                                ),
                                onPressed: () {
                                  Get.defaultDialog(
                                    title: "تنبيه",
                                    middleText:
                                        " سيتم حذف كل العناصر المرتبطه ب هذا لاقسم: ${item.name}؟",
                                    textCancel: "تراجع",
                                    textConfirm: "حذف",
                                    confirmTextColor: Colors.white,
                                    buttonColor: Colors.black,
                                    onConfirm: () {
                                      controller.delete(item.id!);
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
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
