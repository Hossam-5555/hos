import 'package:flutter/material.dart' hide Slider;
import 'package:get/get.dart';
import 'package:hos/controler/onpoarding/onboarding_controler.dart';
import 'package:hos/core/conistant/appcolor.dart';
import 'package:hos/veiw/userscreen/screen/auth/login.dart';

import 'package:hos/veiw/wedget/onpording/costumButton.dart';
import 'package:hos/veiw/wedget/onpording/dotcontroller.dart';
import 'package:hos/veiw/wedget/onpording/silder.dart';

class Onboarding extends StatelessWidget {
  const Onboarding({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(OnboardingControler());

    // احصل على حجم الشاشة
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(flex: 3, child: Slideronboarding()),

            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20.0,
                ), // مسافة من الأطراف
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Dotcontroller(),

                    // زر "التالي"
                    CustomButton(
                      buttonName: '2'.tr,
                      width: screenWidth * 0.6, // 60% من عرض الشاشة
                      buttonColor: Appcolor.deepPurple,
                    ),

                    // زر "تخطي"
                    TextButton(
                      onPressed: () {
                        Get.to(() => Login(), transition: Transition.fadeIn);
                      },
                      child: Text(
                        "skip".tr,
                        style: TextStyle(fontSize: 16, color: Colors.grey[800]),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
