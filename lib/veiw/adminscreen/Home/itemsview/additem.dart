import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hos/controler/admincontroller/items/additemcontroller.dart';
import 'package:hos/core/functions/upload_image.dart';
import 'package:hos/veiw/wedget/auth/checkbutton.dart';
// قم بتعديل مسار الاستيراد حسب هيكل مشروعك
// import 'package:hos/controller/additemcontroller.dart';
// import 'package:hos/core/class/crud.dart';

class Additem extends StatelessWidget {
  const Additem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double w = screenWidth * 0.05; // 5% من عرض الشاشة
    // نهيئة الكنترولر وربطه بالصفحة
    Get.put(Additemcontroller());

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "إضافة منتج جديد",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: GetBuilder<Additemcontroller>(
        builder: (controller) {
          return Form(
            key: controller.itemvalidKey,
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GetBuilder<Additemcontroller>(
                    builder: (controller) {
                      return Row(
                        children: List.generate(3, (index) {
                          final file = controller.selectedImages[index];
                          final bool hasImage = file != null;

                          return Expanded(
                            child: GestureDetector(
                              onTap: () {
                                // استدعاء دالتك الجاهزة مباشرة وتمرير الـ index المطلوب
                                showImagePickerBottomSheet(
                                  () => controller.chooseFromCamera(
                                    index,
                                  ), // كول باك الكاميرا
                                  () => controller.chooseFromGallery(
                                    index,
                                  ), // كول باك المعرض
                                );
                              },
                              child: Container(
                                margin: EdgeInsets.symmetric(
                                  horizontal: index == 1 ? 6 : 0,
                                ),
                                height: 100,
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade50,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: hasImage
                                        ? const Color(0xFF1134A6)
                                        : Colors.grey.shade300,
                                    style: hasImage
                                        ? BorderStyle.solid
                                        : BorderStyle.none,
                                    width: 1.5,
                                  ),
                                ),
                                child: hasImage
                                    ? Stack(
                                        fit: StackFit.expand,
                                        children: [
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                              11,
                                            ),
                                            child: Image.file(
                                              file,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          // زر الحذف الصغير العصري فوق الصورة
                                          Positioned(
                                            top: 4,
                                            right: 4,
                                            child: GestureDetector(
                                              onTap: () =>
                                                  controller.removeImage(index),
                                              child: Container(
                                                padding: const EdgeInsets.all(
                                                  2,
                                                ),
                                                decoration: const BoxDecoration(
                                                  color: Colors.black54,
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
                                        ],
                                      )
                                    : Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            index == 0
                                                ? Icons.add_a_photo_rounded
                                                : Icons
                                                      .add_photo_alternate_outlined,
                                            color: index == 0
                                                ? const Color(0xFF1134A6)
                                                : Colors.grey.shade400,
                                            size: 26,
                                          ),
                                          const SizedBox(height: 6),
                                          Text(
                                            index == 0
                                                ? "الرئيسية"
                                                : "صورة ${index + 1}",
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: index == 0
                                                  ? FontWeight.bold
                                                  : FontWeight.normal,
                                              color: index == 0
                                                  ? const Color(0xFF1134A6)
                                                  : Colors.grey.shade600,
                                            ),
                                          ),
                                        ],
                                      ),
                              ),
                            ),
                          );
                        }),
                      );
                    },
                  ),

                  SizedBox(height: 30),

                  // --- الحقول الأساسية ---
                  const Text(
                    "البيانات الأساسية",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 15),

                  _buildCustomTextField(
                    controller: controller.namear,
                    label: "اسم المنتج (عربي)",
                    icon: Icons.title,
                  ),
                  _buildCustomTextField(
                    controller: controller.name,
                    label: "اسم المنتج (إنجليزي)",
                    icon: Icons.title_outlined,
                  ),
                  _buildCustomTextField(
                    controller: controller.descriptionar,
                    label: "الوصف (عربي)",
                    icon: Icons.description,
                    maxLines: 3,
                  ),
                  _buildCustomTextField(
                    controller: controller.description,
                    label: "الوصف (إنجليزي)",
                    icon: Icons.description_outlined,
                    maxLines: 3,
                  ),

                  // --- تفاصيل السعر والكمية ---
                  const SizedBox(height: 15),
                  const Text(
                    "تفاصيل التسعير والمخزون",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 15),

                  Row(
                    children: [
                      Expanded(
                        child: _buildCustomTextField(
                          controller: controller.price,
                          label: "السعر",
                          icon: Icons.attach_money,
                          isNumber: true,
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: _buildCustomTextField(
                          controller: controller.descount,
                          label: "الخصم (%)",
                          icon: Icons.discount,
                          isNumber: true,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: _buildCustomTextField(
                          controller: controller.count,
                          label: "الكمية المتاحة",
                          icon: Icons.inventory_2,
                          isNumber: true,
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: _buildCustomTextField(
                          controller: controller.itemcat,
                          label: "رقم القسم",
                          icon: Icons.category,
                          isNumber: true,
                          enabled: false
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),

                  // --- زر الإضافة ---
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: GetBuilder<Additemcontroller>(
                      builder: (controller) {
                        return Checkbutton(
                          width: w,
                          onTap: () {
                            controller.additem();
                          },
                          statusrequest: controller.statusrequest,
                          buttonColor: Colors.blue,
                          buttonName: "إضافة المنتج",
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // --- دالة مساعدة لإنشاء الحقول بشكل احترافي ومتناسق ---
  Widget _buildCustomTextField({
    enabled = true,
    required TextEditingController controller,
    required String label,
    required IconData icon,
    int maxLines = 1,
    bool isNumber = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: TextFormField(
        enabled: enabled,
        // style: TextStyle(color: Colors.white),
        controller: controller,
        maxLines: maxLines,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "هذا الحقل مطلوب";
          }
          return null;
        },
        decoration: InputDecoration(
          hintText: label,
          // labelStyle: TextStyle(color: Colors.grey[700]),
          prefixIcon: Icon(icon, color: Colors.blue),
          filled: true,
          contentPadding: const EdgeInsets.symmetric(
            vertical: 15,
            horizontal: 20,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: Colors.grey.shade300, width: 1.5),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(color: Colors.blue, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(color: Colors.red, width: 1.5),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(color: Colors.red, width: 2),
          ),
        ),
      ),
    );
  }
}
