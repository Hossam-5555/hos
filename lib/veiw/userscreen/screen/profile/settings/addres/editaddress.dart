import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hos/core/class/crud.dart';
import 'package:hos/veiw/wedget/appbarbackicon.dart';
import 'package:hos/veiw/wedget/auth/Textfealdauth.dart';
import 'package:hos/veiw/wedget/auth/checkbutton.dart';

class EditAddressController extends GetxController {
  Statusrequest? statusrequest = Statusrequest.none;
  var apartmentNumber = ''.obs;
  var floor = ''.obs;
  var landmark = ''.obs;
  var phone = ''.obs;
  var currentLocation = const LatLng(30.0444, 31.2357).obs; // القاهرة كمثال
  void updateLocation(LatLng newLocation) {
    currentLocation.value = newLocation;
  }

  TextEditingController? name;
  TextEditingController? city;
  TextEditingController? street;
  double lat = 23.3344;
  double long = 23.3344;
  @override
  void onInit() {
    name = TextEditingController();
    city = TextEditingController();
    street = TextEditingController();
    super.onInit();
  }

  void saveAddress() {
    Get.snackbar(
      'تم الحفظ',
      'تم حفظ العنوان بنجاح ✅',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}

class EditAddressPage extends StatelessWidget {
  const EditAddressPage({super.key});

  @override
  Widget build(BuildContext context) {
    // ربط أو استدعاء الكنترولر الخاص بالتعديل
    EditAddressController controller = Get.put(EditAddressController());
    final size = MediaQuery.of(context).size;

    return Scaffold(
      resizeToAvoidBottomInset:
          true, // يضمن رفع الكارت تلقائياً عند فتح الكيبورد
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: Appbarbackicon(herotag: '', title: "Edit Address"),
      ),
      body: Stack(
        children: [
          // 1. الجزء العلوي: الخريطة مفرودة في الخلفية
          SizedBox(
            height: size.height * 0.55,
            child: const Center(child: Text('Google Map Here')),
          ),

          // 2. زر تعديل الموقع المحمي بالـ SafeArea من الأعلى
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

          // 3. الجزء السفلي: كارت التعديل الشفاف المطاطي
          Align(
            alignment: Alignment.bottomCenter,
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(24),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                child: Container(
                  // تحديد أقصى ارتفاع للكارت عشان يسيب مساحة للخريطة وميضربش Overflow
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
                    top: false, // حماية من شريط السحب السفلي للموبايل فقط
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        mainAxisSize: MainAxisSize
                            .min, // يخلي الكارت ياخد مساحة على قد العناصر بس
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildTextField(
                            controller.name!,
                            'Location Name',
                            Icons.send,
                          ),
                          _buildTextField(
                            controller.city!,
                            'City Name',
                            Icons.location_city,
                          ),
                          _buildTextField(
                            controller.street!,
                            'Street Name',
                            Icons.streetview,
                          ),
                          const SizedBox(height: 16),

                          // زر حفظ التعديلات الجديد
                          GetBuilder<EditAddressController>(
                            builder: (controller) {
                              return Checkbutton(
                                statusrequest: controller.statusrequest,
                                buttonColor:  Colors.black,
                                width: size.width,
                                onTap: () => controller.saveAddress(),
                                buttonName: "Save Changes",
                              );
                            },
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

  // ميثود ذكية ومختصرة لبناء التكست فيلدز بدون تكرار سطور الكود
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
