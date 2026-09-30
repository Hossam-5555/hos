import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hos/controler/admincontroller/categories/addcatcontroller.dart';
import 'package:hos/veiw/wedget/appbarbackicon.dart';
import 'package:hos/veiw/wedget/auth/Textfealdauth.dart';
import 'package:hos/veiw/wedget/auth/checkbutton.dart';

class Addcategories extends StatelessWidget {
  const Addcategories({super.key});

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    final controller = Get.put(Addcatcontroller());

    return Scaffold(
      appBar:  Appbarbackicon(title: "New Category", herotag: "xx"),
      body: GetBuilder<Addcatcontroller>(
        builder: (controller) => SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Form(
            key: controller.validkey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // كارت رفع الصورة وتحديدها بشكل متناسق
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                 
                  child: Column(
                    children: [
                      const Text(
                        "صورة الفئة",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 15),
                      GestureDetector(
                        onTap: () => controller.chooseimage(),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          height: 130,
                          width: 130,
                          decoration: BoxDecoration(
                            color: Colors.blue.shade50.withAlpha(128),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: controller.file != null
                                  ? Colors.blue
                                  : Colors.blue.shade200,
                              width: 1.5,
                            ),
                          ),
                          child: controller.file != null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(18),
                                  child: Image.file(
                                    controller.file!,
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: Colors.blue.withAlpha(25),
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.add_a_photo_rounded,
                                        color: Colors.blue,
                                        size: 28,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    const Text(
                                      "اختر صورة",
                                      style: TextStyle(
                                        color: Colors.blue,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 25),

                // كارت الحقول النصية
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.grey.shade800
                        : Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(10),
                        blurRadius: 15,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "تفاصيل الفئة",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 20),

                      // اسم الفئة بالإنجليزية
                      Textfealdauth(
                        hint: "اكتب اسم الفئة بالإنجليزية",
                        suffixIcon: Icons.category_outlined,
                        textEditingController: controller.name,
                        valid: (val) {
                          if (val == null || val.trim().isEmpty) {
                            return "الاسم مطلوب";
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 18),

                      // اسم الفئة بالعربية
                      Textfealdauth(
                        hint: "اكتب اسم الفئة بالعربية",
                        suffixIcon: Icons.language_outlined,
                        textEditingController: controller.namear,
                        valid: (val) {
                          if (val == null || val.trim().isEmpty) {
                            return "الاسم بالعربية مطلوب";
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 35),

                // زر الإضافة
                Center(
                  child: Checkbutton(
                    width: double.infinity,
                    onTap: () => controller.addcategories(),
                    buttonName: "إضافة الفئة",
                    buttonColor: Colors.black,
                    statusrequest: controller.statusrequest,
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}