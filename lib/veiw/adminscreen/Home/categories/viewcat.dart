import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hos/controler/admincontroller/categories/viewcontroller.dart';
import 'package:hos/core/class/handlingdataview.dart';
import 'package:hos/veiw/adminscreen/Home/categories/addcat.dart';
import 'package:hos/veiw/wedget/auth/checkbutton.dart';

class ViewCategories extends StatelessWidget {
  const ViewCategories({super.key});

  @override
  Widget build(BuildContext context) {
    // استخدمنا Get.put هنا، ويفضل أن يكون الـ Controller قد تم تهيئته مسبقاً في الـ Binding
    Get.put(ViewCatController());

    return Scaffold(
      body: GetBuilder<ViewCatController>(
        builder: (controller) {
          double w = MediaQuery.of(context).size.width;
          return Handlingdataview(
            statusrequest: controller.statusrequest,
            widget: Column(
              children: [
                SizedBox(height: 20),
                SizedBox(
                  height: 60,
                  child: GetBuilder<ViewCatController>(
                    builder: (controller) {
                      return Checkbutton(
                        buttonColor: Colors.blue,
                        controller: controller,
                        width: w / 2,
                        onTap: () {
                          Get.to(
                            () => Addcategories(),
                            transition: Transition.rightToLeft,
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.easeInOut,
                          );
                        },
                        buttonName: "Add New Category",
                      );
                    },
                  ),
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
                          border: Border.all(color: Colors.grey),
                          color: Colors.white.withAlpha(50),
                          borderRadius: BorderRadius.circular(16),
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
