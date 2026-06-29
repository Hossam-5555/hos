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
      appBar: Appbarbackicon(title: "New Category", herotag: "xx"),
      body: GetBuilder<Addcatcontroller>(
        builder: (controller) => SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
          child: Form(
            key: controller.validkey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              

                Center(
                  child: Column(
                    children: [
                      TextButton.icon(
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 25,
                            vertical: 15,
                          ),
                          backgroundColor: Colors.blueAccent.withAlpha(26),
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
                          child: Image.file(controller.file!),
                        ),
                    ],
                  ),
                ),
                SizedBox(height: 20),

                // اسم الفئة
                Textfealdauth(
                  hint: "اكتب اسم الفئة بالإنجليزية",
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
                  child: GetBuilder<Addcatcontroller>(
                    builder: (controller) {
                      return Checkbutton(width: 200,
                        onTap: () => controller.addcategories(),
                        buttonName: "add category",

                        buttonColor: Colors.black,
                        statusrequest: controller.statusrequest,
                      );
                    },
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
