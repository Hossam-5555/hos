import 'package:flutter/material.dart' hide Slider;
import 'package:get/get.dart';
import 'package:hos/controler/usercontroller/onpoarding/onboarding_controler.dart';
import 'package:hos/core/conistant/appcolor.dart';
import 'package:hos/veiw/userscreen/screen/auth/Auth.dart';
import 'package:hos/veiw/wedget/onpording/costumButton.dart';
import 'package:hos/veiw/wedget/onpording/dotcontroller.dart';
import 'package:hos/veiw/wedget/onpording/silder.dart';

class Onboarding extends StatelessWidget {
  const Onboarding({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(OnboardingControler());
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          // إضافة مساحة سفلية لتبديل الأزرار عن حافة الشاشة
          padding: const EdgeInsets.only(bottom: 24.0),
          child: Column(
            children: [
              /// 🟢 السلايدر (يأخذ المساحة الأكبر بتصميم مريح)
              Expanded(
                flex: 4, 
                child: const Slideronboarding(),
              ),

              /// 🟢 الجزء السفلي (مؤشرات وأزرار)
              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0), // مسافة جانبية أوسع لشكل أرقى
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end, // دفع العناصر للأسفل
                    children: [
                      /// 🟢 Dots
                      const Dotcontroller(),
                      
                      SizedBox(height: size.height * 0.04), // مسافة مرنة بين النقاط والأزرار

                      /// 🟢 الأزرار
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          /// Skip Button
                          TextButton(
                            onPressed: () {
                              // 💡 نصيحة: يفضل نقل هذا السطر داخل دالة في الكونترولر للحفاظ على نظافة الـ UI
                              controller.myservisec.sharedPreferences.setString('step', "1");

                              Get.offAll(
                                () => const AuthPage(),
                                transition: Transition.fadeIn,
                                duration: const Duration(milliseconds: 500), // نعومة في الانتقال
                              );
                            },
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(
                              "skip".tr,
                              style: TextStyle(
                                fontSize: size.width * 0.045,
                                fontWeight: FontWeight.w600, // خط أسمك قليلاً
                                color: Colors.grey.shade600, // لون رمادي أنيق
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),

                          /// Continue Button
                          CustomButton(
                            width: size.width * 0.35, // عرض أكبر قليلاً ليبرز كزر رئيسي (Call to Action)
                            buttonName: 'continue'.tr,
                            buttonColor: Appcolor.black, 
                          ),
                        ],
                      ),
                    ],
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