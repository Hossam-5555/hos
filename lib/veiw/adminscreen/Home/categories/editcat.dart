import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hos/controler/admincontroller/categories/editcontroller.dart';
import 'package:hos/veiw/wedget/auth/Textfealdauth.dart';

class Editcat extends StatelessWidget {
  const Editcat({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    Get.put(Editcontroller());

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 2,
        centerTitle: true,
        title: Text(
          "Edit Category",
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: GetBuilder<Editcontroller>(
        builder: (controller) => Form(
          key: controller.editkey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // صورة أو شعار القسم
                GestureDetector(
                  onTap: () => controller.chooseimage(),
                  child: Container(
                    height: 120,
                    width: 120,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade300,
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: controller.file != null
                        ? (controller.file!.path.endsWith(".svg")
                            ? SvgPicture.file(
                                controller.file!,
                                fit: BoxFit.cover,
                              )
                            : ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Image.file(
                                  File(controller.file!.path),
                                  fit: BoxFit.cover,
                                ),
                              ))
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.add_a_photo_outlined,
                                  size: 40, color: Colors.grey[600]),
                              const SizedBox(height: 8),
                              Text(
                                "Add Photo",
                                style: TextStyle(
                                    color: Colors.grey[600], fontSize: 14),
                              )
                            ],
                          ),
                  ),
                ),

                const SizedBox(height: 40),

                // اسم القسم
                Textfealdauth(
                  hint: "Category name",
                  suffixIcon: Icons.text_fields,
                  textEditingController: controller.name,
                  valid: (val) {
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // الاسم بالعربية
                Textfealdauth(
                  hint: "اسم القسم بالعربية",
                  suffixIcon: Icons.language,
                  textEditingController: controller.namear,
                  valid: (val) {
                    return null;
                  },
                ),

                const SizedBox(height: 40),

                // زر الحفظ
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: () => controller.edit(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      shadowColor: Colors.black26,
                      elevation: 5,
                    ),
                    child: const Text(
                      "💾 Save Changes",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
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
