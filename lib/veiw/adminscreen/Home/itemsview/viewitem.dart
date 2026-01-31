import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:hos/controler/admincontroller/items/viewitemcontroller.dart';
import 'package:hos/core/class/handlingdataview.dart';
import 'package:hos/core/conistant/linkApi.dart';

// ignore: camel_case_types
class viewitem extends StatelessWidget {
  const viewitem({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ViewItemController());

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        elevation: 2,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          "Items",
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
        leading: IconButton(
          onPressed: controller.backtohomebage,
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black87),
        ),
      ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: controller.goToAddPage,
        backgroundColor: Colors.black,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text("إضافة item", style: TextStyle(color: Colors.white)),
      ),

      body: GetBuilder<ViewItemController>(
        builder: (controller) {
          return Handlingdataview(
            statusrequest: controller.statusrequest,
            widget: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: controller.itemlist.length,
              separatorBuilder: (_, _) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final item = controller.itemlist[index];
                final imageUrl =
                    "${LinkApi.imageitems}/${item.itemsImage}";

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
                          (item.itemsImage != null &&
                              item.itemsImage!.toLowerCase().endsWith(
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
                      item.itemsName ?? "بدون اسم",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    subtitle: Text(
                      item.itemsNameAr ?? "",
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
                              middleText: "هل تريد حذف هذا المنتج",
                              textCancel: "إلغاء",
                              textConfirm: "حذف",
                              confirmTextColor: Colors.white,
                              buttonColor: Colors.redAccent,
                              onConfirm: () {
                                controller.delete(
                                  item.itemsId!.toString(),
                                  item.itemsImage!,
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
