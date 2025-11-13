import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:hos/controler/admincontroller/categories/addcatcontroller.dart';
import 'package:hos/veiw/wedget/auth/Textfealdauth.dart';

class Addcategories extends StatelessWidget {
  const Addcategories({super.key});

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    final controller = Get.put(Addcatcontroller());

    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FB),
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "إضافة فئة جديدة",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black87),
          onPressed: () => Get.back(),
        ),
      ),
      body: GetBuilder<Addcatcontroller>(
        builder: (controller) => SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
          child: Form(
            key: controller.validkey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "معلومات الفئة",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 20),


                Center(
                  child: Column(
                    children: [
                      TextButton.icon(
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 25,
                            vertical: 15,
                          ),
                          backgroundColor: Colors.blueAccent.withOpacity(0.1),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        onPressed: () => controller.chooseimage(),
                        icon: const Icon(Icons.add_a_photo, color: Colors.blue),
                        label: const Text(
                          "اختر صورة للفئة",
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      if (controller.file != null)
                        Container(
                          height: 100,
                          width: 100,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(color: Colors.blueAccent),
                          ),
                          child: SvgPicture.file(controller.file!),
                        ),
                    ],
                  ),
                ),
                SizedBox(height: 20,),

                // اسم الفئة
                Textfealdauth(
                  hint: "اكتب اسم الفئة بالإنجليزية",
                  label: "Category Name",
                  suffixIcon: Icons.category_outlined,
                  textEditingController: controller.name,
                  valid: (val) {
                    if (val!.isEmpty) return "الاسم مطلوب";
                    return null;
                  },
                ),

                const SizedBox(height: 20),

                // اسم الفئة بالعربية
                Textfealdauth(
                  hint: "اكتب اسم الفئة بالعربية",
                  label: "الاسم بالعربية",
                  suffixIcon: Icons.language_outlined,
                  textEditingController: controller.namear,
                  valid: (val) {
                    if (val!.isEmpty) return "الاسم بالعربية مطلوب";
                    return null;
                  },
                ),

                const SizedBox(height: 30),
                const Divider(height: 1, thickness: 1),
                const SizedBox(height: 30),

                // رفع الصورة
                

                const SizedBox(height: 40),

                // زر الإضافة
                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black87,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 50,
                        vertical: 14,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      elevation: 3,
                    ),
                    onPressed: () {
                      controller.addcategories();
                    },
                    child: const Text(
                      "إضافة الفئة",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
