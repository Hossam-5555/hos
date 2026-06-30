import 'package:get/get.dart';
import 'package:hos/core/conistant/imageasset.dart';
import 'package:hos/veiw/wedget/appbarbackicon.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter/material.dart';

class ProfileController extends GetxController {
  // متغيرات مراقبة (Observable)
  var username = "حسام ياسر".obs;
  var imagePath = "${Imageasset.twetter}".obs; // مسار الصورة المختارة

  final ImagePicker _picker = ImagePicker();

  // دالة تغيير الصورة
  Future<void> pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      imagePath.value = pickedFile.path;
      Get.snackbar(
        "نجاح",
        "تم تحديث الصورة الشخصية",
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  // دالة تحديث الاسم
  void updateName(String newName) {
    if (newName.isNotEmpty) {
      username.value = newName;
    }
  }
}

class EditProfileView extends StatelessWidget {
  EditProfileView({Key? key}) : super(key: key);

  // ربط الكنترولر بالواجهة
  final ProfileController controller = Get.put(ProfileController());
  final TextEditingController nameEditController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // وضع الاسم الحالي في حقل النص عند فتح الصفحة
    nameEditController.text = controller.username.value;

    return Scaffold(
      appBar: Appbarbackicon(title: "Edit profile", herotag: ""),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            children: [
              const SizedBox(height: 20),
              // --- قسم الصورة مع التحديث التلقائي ---
              Center(
                child: Stack(
                  children: [
                    Obx(
                      () => CircleAvatar(
                        radius: 70,
                        backgroundColor: Colors.grey.shade200,
                        backgroundImage: controller.imagePath.value.isNotEmpty
                            ? FileImage(File(controller.imagePath.value))
                            : const NetworkImage(
                                    "https://via.placeholder.com/150",
                                  )
                                  as ImageProvider,
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 5,
                      child: GestureDetector(
                        onTap: () => controller.pickImage(),
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: const BoxDecoration(
                            color: Colors.blueAccent,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.camera_alt,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),

              // --- حقل تعديل الاسم ---
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  "اسم المستخدم",
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: nameEditController,
                decoration: InputDecoration(
                  hintText: "أدخل اسمك",
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none,
                  ),
                  prefixIcon: const Icon(Icons.person_outline),
                ),
              ),
              const SizedBox(height: 50),

              // --- زر الحفظ ---
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  onPressed: () {
                    controller.updateName(nameEditController.text);
                    Get.back(); // العودة لصفحة الإعدادات بعد الحفظ
                    Get.snackbar("تم الحفظ", "تم تحديث بياناتك بنجاح");
                  },
                  child: const Text(
                    "حفظ التغييرات",
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
