import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hos/controler/admincontroller/items/edititemcontroller.dart';
import 'package:hos/veiw/wedget/auth/Textfealdauth.dart';

class EditItem extends StatelessWidget {
  const EditItem({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;

    // نسب حسب حجم الشاشة
    final double imgSize = size.width * 0.32; // بديل الـ 120
    final double padding = size.width * 0.05;
    final double verticalSpace = size.height * 0.03;
    final double textFieldSpacing = size.height * 0.02;

    Get.put(Edititemcontroller());

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 2,
        centerTitle: true,
        title: Text(
          "Edit item",
          style: const TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: GetBuilder<Edititemcontroller>(
        builder: (controller) => Form(
          key: controller.editkey,
          child: SingleChildScrollView(
            padding: EdgeInsets.all(padding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // صورة العنصر
                GestureDetector(
                  onTap: () => controller.showoptionimage(),
                  child: Container(
                    height: imgSize,
                    width: imgSize,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade300,
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: controller.file != null
                        ? (controller.file!.path.endsWith(".svg")
                            ? SvgPicture.file(controller.file!, fit: BoxFit.cover)
                            : ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Image.file(
                                  File(controller.file!.path),
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      Container(
                                        color: Colors.grey[200],
                                        child: const Icon(Icons.image, size: 35),
                                      ),
                                ),
                              ))
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.add_a_photo_outlined,
                                  size: size.width * 0.1,
                                  color: Colors.grey[600]),
                              const SizedBox(height: 8),
                              Text("Add Photo",
                                  style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: size.width * 0.035)),
                            ],
                          ),
                  ),
                ),

                SizedBox(height: verticalSpace),

                _space(textFieldSpacing),

                Textfealdauth(
                  hint: "القسم",
                  label: "ادخل اسم القسم",
                  suffixIcon: Icons.discount_outlined,
                  textEditingController: controller.itemcat,
                  valid: (val) => val!.isEmpty ? "الحقل مطلوب" : null,
                ),

                _space(textFieldSpacing),

                Textfealdauth(
                  hint: "اكتب اسم العنصر بالإنجليزية",
                  label: "Category Name",
                  suffixIcon: Icons.category_outlined,
                  textEditingController: controller.name,
                  valid: (val) => val!.isEmpty ? "الاسم مطلوب" : null,
                ),

                _space(textFieldSpacing),

                Textfealdauth(
                  hint: "اكتب اسم العنصر بالعربية",
                  label: "الاسم بالعربية",
                  suffixIcon: Icons.language_outlined,
                  textEditingController: controller.namear,
                  valid: (val) => val!.isEmpty ? "الاسم بالعربية مطلوب" : null,
                ),

                _space(textFieldSpacing),

                Textfealdauth(
                  hint: "Description",
                  label: "Description English",
                  suffixIcon: Icons.description_outlined,
                  textEditingController: controller.description,
                  valid: (val) => val!.isEmpty ? "الوصف مطلوب" : null,
                ),

                _space(textFieldSpacing),

                Textfealdauth(
                  hint: "الوصف",
                  label: "الوصف بالعربية",
                  suffixIcon: Icons.language_outlined,
                  textEditingController: controller.descriptionar,
                  valid: (val) => val!.isEmpty ? "الوصف بالعربية مطلوب" : null,
                ),

                _space(textFieldSpacing),

                Textfealdauth(
                  hint: "count",
                  label: "Item count",
                  suffixIcon: Icons.format_list_numbered,
                  textEditingController: controller.count,
                  valid: (val) => val!.isEmpty ? "الحقل مطلوب" : null,
                ),

                _space(textFieldSpacing),

                Textfealdauth(
                  hint: "price",
                  label: "Item price",
                  suffixIcon: Icons.attach_money_outlined,
                  textEditingController: controller.price,
                  valid: (val) => val!.isEmpty ? "الحقل مطلوب" : null,
                ),

                _space(textFieldSpacing),

                Textfealdauth(
                  hint: "Discount",
                  label: "Discount",
                  suffixIcon: Icons.discount_outlined,
                  textEditingController: controller.descount,
                  valid: (val) => val!.isEmpty ? "الحقل مطلوب" : null,
                ),

                SizedBox(height: size.height * 0.05),

                SizedBox(
                  width: double.infinity,
                  height: size.height * 0.065,
                  child: ElevatedButton(
                    onPressed: () => controller.Edit(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      elevation: 5,
                    ),
                    child: Text(
                      "💾 Save Changes",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: size.width * 0.045,
                        fontWeight: FontWeight.bold,
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

  Widget _space(double height) => SizedBox(height: height);
}
