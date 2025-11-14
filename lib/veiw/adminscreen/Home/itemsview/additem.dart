import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hos/controler/admincontroller/items/additemcontroller.dart';
import 'package:hos/veiw/wedget/auth/Textfealdauth.dart';

class Additem extends StatelessWidget {
  const Additem({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final height = size.height;
    final width = size.width;

    Get.put(Additemcontroller());

    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FB),
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        toolbarHeight: height * 0.08, // ارتفاع نسبي
        title: const Text(
          "إضافة عنصر جديدة",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black87,
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: Colors.black87,
            size: width * 0.06,
          ),
          onPressed: () => Get.back(),
        ),
      ),
      body: GetBuilder<Additemcontroller>(
        builder: (controller) => SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: width * 0.05,
            vertical: height * 0.03,
          ),
          child: Form(
            key: controller.itemvalidKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: height * 0.025),

                // اسم العنصر بالإنجليزية
                Textfealdauth(
                  hint: "اكتب اسم العنصر بالإنجليزية",
                  label: "Category Name",
                  suffixIcon: Icons.category_outlined,
                  textEditingController: controller.name,
                  valid: (val) => val!.isEmpty ? "الاسم مطلوب" : null,
                ),

                // اسم العنصر بالعربية
                Textfealdauth(
                  hint: "اكتب اسم العنصر بالعربية",
                  label: "الاسم بالعربية",
                  suffixIcon: Icons.language_outlined,
                  textEditingController: controller.namear,
                  valid: (val) => val!.isEmpty ? "الاسم بالعربية مطلوب" : null,
                ),

                // Description English
                Textfealdauth(
                  hint: "Description",
                  label: "Description English",
                  suffixIcon: Icons.description_outlined,
                  textEditingController: controller.namear,
                  valid: (val) => val!.isEmpty ? "الوصف مطلوب" : null,
                ),

                // Description Arabic
                Textfealdauth(
                  hint: "الوصف",
                  label: "الوصف بالعربية",
                  suffixIcon: Icons.language_outlined,
                  textEditingController: controller.namear,
                  valid: (val) => val!.isEmpty ? "الوصف بالعربية مطلوب" : null,
                ),

                // Active
                Textfealdauth(
                  hint: "active",
                  label: "Active",
                  suffixIcon: Icons.toggle_on_outlined,
                  textEditingController: controller.namear,
                  valid: (val) => val!.isEmpty ? "الحقل مطلوب" : null,
                ),

                // Count
                Textfealdauth(
                  hint: "count",
                  label: "Item count",
                  suffixIcon: Icons.format_list_numbered,
                  textEditingController: controller.namear,
                  valid: (val) => val!.isEmpty ? "الحقل مطلوب" : null,
                ),

                // Price
                Textfealdauth(
                  hint: "price",
                  label: "Item price",
                  suffixIcon: Icons.attach_money_outlined,
                  textEditingController: controller.namear,
                  valid: (val) => val!.isEmpty ? "الحقل مطلوب" : null,
                ),

                // Discount
                Textfealdauth(
                  hint: "Discount",
                  label: "Discount",
                  suffixIcon: Icons.discount_outlined,
                  textEditingController: controller.namear,
                  valid: (val) => val!.isEmpty ? "الحقل مطلوب" : null,
                ),
                SizedBox(height: height * 0.035),

                // رفع الصورة
                Center(
                  child: Column(
                    children: [
                      TextButton.icon(
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                            horizontal: width * 0.06,
                            vertical: height * 0.015,
                          ),
                          backgroundColor: Colors.blueAccent.withOpacity(0.1),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        onPressed: () => controller.showoptionimage(),
                        icon: const Icon(Icons.add_a_photo, color: Colors.blue),
                        label: Text(
                          "اختر صورة للعنصر",
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.w600,
                            fontSize: width * 0.04,
                          ),
                        ),
                      ),
                      SizedBox(height: height * 0.02),
                      if (controller.file != null)
                        Container(
                          height: height * 0.15,
                          width: width * 0.35,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(color: Colors.blueAccent),
                          ),
                          child: Image.file(
                            controller.file!,
                            fit: BoxFit.cover,
                          ),
                        ),
                    ],
                  ),
                ),

                SizedBox(height: height * 0.05),

                // زر الإضافة
                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black87,
                      padding: EdgeInsets.symmetric(
                        horizontal: width * 0.1,
                        vertical: height * 0.018,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      elevation: 3,
                    ),
                    onPressed: () {
                      controller.addcategories();
                    },
                    child: Text(
                      "إضافة عنصر",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: width * 0.045,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: height * 0.05),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
