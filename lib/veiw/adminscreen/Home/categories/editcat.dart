import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hos/controler/admincontroller/categories/editcontroller.dart';
import 'package:hos/veiw/wedget/appbarbackicon.dart';
import 'package:hos/veiw/wedget/auth/Textfealdauth.dart';
import 'package:hos/veiw/wedget/auth/checkbutton.dart';

class Editcat extends StatelessWidget {
  const Editcat({super.key});

  @override
  Widget build(BuildContext context) {
    // final theme = Theme.of(context);
    Get.put(Editcontroller());
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: Appbarbackicon(title: "Edit Category", herotag: "Edit category"),
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
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image.file(
                              File(controller.file!.path),
                              fit: BoxFit.cover,
                            ),
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.add_a_photo_outlined,
                                size: 40,
                                color: Colors.grey[600],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                "Add Photo",
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 14,
                                ),
                              ),
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
                  child: GetBuilder<Editcontroller>(
                    builder: (controller) => Checkbutton(
                      width: w / 2,
                      buttonColor: Colors.black,
                      statusrequest: controller.statusrequest,
                      onTap: () {
                        controller.edit();
                      },
                      buttonName: 'save changes',
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
