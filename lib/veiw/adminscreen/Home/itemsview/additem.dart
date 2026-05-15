import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hos/controler/admincontroller/items/additemcontroller.dart';
import 'package:hos/veiw/wedget/auth/checkbutton.dart';
// قم بتعديل مسار الاستيراد حسب هيكل مشروعك
// import 'package:hos/controller/additemcontroller.dart';
// import 'package:hos/core/class/crud.dart';

class Additem extends StatelessWidget {
  const Additem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                  // --- قسم اختيار الصورة ---
                  Center(
                    child: GestureDetector(
                      onTap: () {
                        controller.showoptionimage();
                      },
                      child: Container(
                        width: 150,
                        height: 150,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Colors.blue.shade200,
                            width: 2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              blurRadius: 10,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: controller.file != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(18),
                                child: Image.file(
                                  controller.file!,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                ),
                              )
                            : Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.add_a_photo,
                                    size: 50,
                                    color: Colors.blue.shade300,
                                  ),
                                  const SizedBox(height: 10),
                                  const Text(
                                    "إضافة صورة",
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),

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
    required TextEditingController controller,
    required String label,
    required IconData icon,
    int maxLines = 1,
    bool isNumber = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: TextFormField(
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
