import 'package:flutter/material.dart' hide Slider;
import 'package:get/get.dart';
import 'package:hos/controler/usercontroller/onpoarding/onboarding_controler.dart';
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
      body: SafeArea(
        child: Column(mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(height: 700, child: Slideronboarding()),
            Container(
              margin: EdgeInsets.all(12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () {
                      Get.to(() => Login(), transition: Transition.fadeIn);
                    },
                    child: Text(
                      "skip".tr,
                      style: TextStyle(fontSize: 20, color: Colors.black),
                    ),
                  ),
                  Dotcontroller(),

                  CustomButton(
                    buttonName: 'continue'.tr,
                    width: screenWidth * 0.15, // 60% من عرض الشاشة
                    buttonColor: Appcolor.black,
                  ),

                  // زر "تخطي"
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
