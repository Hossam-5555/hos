import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hos/controler/admincontroller/items/edititemcontroller.dart';
import 'package:hos/veiw/adminscreen/Home/itemsview/additem.dart';
import 'package:hos/veiw/wedget/appbarbackicon.dart';
import 'package:hos/veiw/wedget/auth/checkbutton.dart';
// لا تنسى تعديل مسار الاستيراد بناءً على مجلدات مشروعك
// import 'package:hos/controller/edit_item_controller.dart';

class EditItem extends StatelessWidget {
  const EditItem({super.key});

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    // ربط الكنترولر بالصفحة
    Get.put(Edititemcontroller());

    return Scaffold(
      appBar: Appbarbackicon(title: "Edit Items", herotag: ""),
      body: GetBuilder<Edititemcontroller>(
        builder: (controller) {
          return Form(
            key: controller.editkey,
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              children: [
                // 📸 1. معرض الصور (3 أماكن للصور)
                const Text(
                  "صور المنتج",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                GetBuilder<Edititemcontroller>(
                    builder: (controller) {
                      // تصفية القائمة لمعرفة الصور التي تم اختيارها فعلياً (تجاهل القيم null)
                      final selectedFiles = controller.selectedImages
                          .where((file) => file != null)
                          .toList();

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // 1. زر إضافة الصور (مربع واحد كبير)
                          GestureDetector(
                            onTap: () {
                              // هنا نستدعي دالة اختيار صور متعددة من الكنترولر
                              controller.pickMultipleImagesFromGallery();
                            },
                            child: Container(
                              width: double.infinity,
                              height: 120,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade50,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: const Color(0xFF1134A6),
                                  width: 1.5,
                                ),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.add_photo_alternate_rounded,
                                    color: Color(0xFF1134A6),
                                    size: 36,
                                  ),
                                  const SizedBox(height: 8),
                                  const Text(
                                    "اضغط لاختيار الصور",
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF1134A6),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    "يمكنك تحديد أكثر من صورة معاً",
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          // 2. عرض الصور المختارة أسفل الزر (تظهر فقط إذا تم اختيار صور)
                          if (selectedFiles.isNotEmpty) ...[
                            const SizedBox(height: 16),
                            Wrap(
                              spacing: 10, // المسافة الأفقية بين الصور
                              runSpacing: 10, // المسافة العمودية
                              children: List.generate(
                                controller.selectedImages.length,
                                (index) {
                                  final file = controller.selectedImages[index];
                                  if (file == null)
                                    return const SizedBox.shrink();

                                  return Stack(
                                    clipBehavior: Clip.none,
                                    children: [
                                      // الصورة المصغرة
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Image.file(
                                          file,
                                          width: 80,
                                          height: 80,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      // زر الحذف
                                      Positioned(
                                        top: -6,
                                        right: -6,
                                        child: GestureDetector(
                                          onTap: () =>
                                              controller.removeImage(index),
                                          child: Container(
                                            padding: const EdgeInsets.all(4),
                                            decoration: const BoxDecoration(
                                              color: Colors.redAccent,
                                              shape: BoxShape.circle,
                                            ),
                                            child: const Icon(
                                              Icons.close,
                                              size: 14,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                      // علامة تميز الصورة الرئيسية (أول صورة)
                                      if (index == 0)
                                        Positioned(
                                          bottom: 4,
                                          left: 4,
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 6,
                                              vertical: 2,
                                            ),
                                            decoration: BoxDecoration(
                                              color: const Color(0xFF1134A6),
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                            ),
                                            child: const Text(
                                              "الرئيسية",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 9,
                                              ),
                                            ),
                                          ),
                                        ),
                                    ],
                                  );
                                },
                              ),
                            ),
                          ],
                        ],
                      );
                    },
                  ),
                const SizedBox(height: 25),

                // 📝 2. الحقول النصية (الاسم والوصف)
                buildCustomTextField(
                  controller: controller.name,
                  label: "اسم المنتج (انجليزي)",
                  icon: Icons.label_outline,
                ),
                buildCustomTextField(
                  controller: controller.namear,
                  label: "اسم المنتج (عربي)",
                  icon: Icons.label,
                ),
                buildCustomTextField(
                  controller: controller.description,
                  label: "الوصف (انجليزي)",
                  icon: Icons.description_outlined,
                  maxLines: 3,
                ),
                buildCustomTextField(
                  controller: controller.descriptionar,
                  label: "الوصف (عربي)",
                  icon: Icons.description,
                  maxLines: 3,
                ),

                // 💰 3. السعر والخصم (جنب بعض)
                Row(
                  children: [
                    Expanded(
                      child: buildCustomTextField(
                        controller: controller.price,
                        label: "السعر",
                        icon: Icons.attach_money,
                        isNumber: true,
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: buildCustomTextField(
                        controller: controller.descount,
                        label: "الخصم (%)",
                        icon: Icons.percent,
                        isNumber: true,
                      ),
                    ),
                  ],
                ),

                // 📦 4. الكمية (زر زيادة ونقصان)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[400]!),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "المخزون (الكمية):",
                        style: TextStyle(fontSize: 16),
                      ),
                      Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              int current =
                                  int.tryParse(controller.count.text) ?? 0;
                              if (current > 0) {
                                controller.count.text = (current - 1)
                                    .toString();
                                controller.update();
                              }
                            },
                            icon: const Icon(
                              Icons.remove_circle_outline,
                              color: Colors.redAccent,
                            ),
                          ),
                          Text(
                            controller.count.text,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              int current =
                                  int.tryParse(controller.count.text) ?? 0;
                              controller.count.text = (current + 1).toString();
                              controller.update();
                            },
                            icon: const Icon(
                              Icons.add_circle_outline,
                              color: Colors.green,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),

                // ⚙️ 6. حالة التفعيل (Switch Toggle)
                SwitchListTile(
                  title: const Text(
                    "حالة المنتج",
                    style: TextStyle(fontSize: 16),
                  ),
                  subtitle: Text(
                    controller.active == 1 ? "مفعل ويظهر للعملاء" : "مخفي",
                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                  ),
                  value: controller.active == 1,
                  activeColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                    side: BorderSide(color: Colors.grey[400]!),
                  ),
                  onChanged: (val) {
                    controller.active = val ? 1 : 0;
                    controller.update();
                  },
                ),
                const SizedBox(height: 30),

                // 🚀 7. زر الحفظ
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: GetBuilder<Edititemcontroller>(
                    builder: (controller) {
                      return Checkbutton(
                        buttonColor: Colors.blue,
                        width: w,
                        statusrequest: controller.statusrequest,
                        onTap: () {
                          controller.edit();
                        },
                        buttonName: "Save change",
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
    );
  }

  // 🖼️ دالة مساعدة لفتح قائمة اختيار الصورة
}
