import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hos/controler/usercontroller/profile/addres/addrescontroller.dart';
import 'package:hos/veiw/wedget/appbarbackicon.dart';
import 'package:hos/veiw/wedget/auth/Textfealdauth.dart';
import 'package:hos/veiw/wedget/auth/checkbutton.dart';

class AddNewAddres extends StatelessWidget {
  const AddNewAddres({super.key});

  @override
  Widget build(BuildContext context) {
    AddressController controller = Get.put(AddressController());
    final size = MediaQuery.of(context).size;

    return Scaffold(
      resizeToAvoidBottomInset: true, // يضمن رفع العناصر عند ظهور الكيبورد
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: Appbarbackicon(herotag: '', title: "Add Address"),
      ),
      body: Stack(
        children: [
          // 1. الجزء العلوي: الخريطة تملأ الجزء المتاح خلف الكارت
          SizedBox(
            height: size.height * 0.55,
            child: const Center(child: Text('Google Map Here')),
          ),

          // 2. زر تعديل الموقع (مع حماية خاصة من الأعلى)
          Positioned(
            top: 16,
            right: 16,
            child: SafeArea(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 4,
                ),
                onPressed: () => Get.snackbar(
                  'تعديل الموقع',
                  'اضغط على الخريطة لتغيير الموقع',
                ),
                child: const Text('تعديل الموقع على الخريطة'),
              ),
            ),
          ),

          // 3. الجزء السفلي: الكارت الشفاف المطاطي الذكي
          Align(
            alignment: Alignment.bottomCenter,
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(24),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                child: Container(
                  // يضمن ألا يتعدى الكارت 45% من الشاشة لترك مساحة كافية للخريطة
                  constraints: BoxConstraints(maxHeight: size.height * 0.45),
                  decoration: BoxDecoration(
                    color: context.isDarkMode
                        ? const Color(0xFF232429).withValues(alpha: 0.9)
                        : Colors.white.withValues(alpha: 0.9),
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(24),
                    ),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 10,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: SafeArea(
                    top: false, // يحمي المحتوى من شريط السحب السفلي للهاتف
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildTextField(
                            controller.name!,
                            'Enter name of location',
                            Icons.send,
                          ),
                          _buildTextField(
                            controller.city!,
                            'Enter city name',
                            Icons.location_city,
                          ),
                          _buildTextField(
                            controller.street!,
                            'Enter street name',
                            Icons.streetview,
                          ),
                          const SizedBox(height: 16),
                          Checkbutton(
                            statusrequest: controller.statusrequest,
                            buttonColor: Colors.black,
                            width: size.width,
                            onTap: () {},
                            buttonName: "Save location",
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ميثود مختصرة لإنشاء الحقول لتقليل تكرار الكود (Clean Code)
  Widget _buildTextField(
    TextEditingController controller,
    String hint,
    IconData icon,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Textfealdauth(
        obscureText: false,
        suffixIcon: icon,
        hint: hint,
        textEditingController: controller,
        valid: (val) => null,
      ),
    );
  }
}
