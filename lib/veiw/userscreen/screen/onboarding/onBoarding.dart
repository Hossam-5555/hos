import 'package:flutter/material.dart' hide Slider;
import 'package:get/get.dart';
import 'package:hos/controler/usercontroller/onpoarding/onboarding_controler.dart';
import 'package:hos/core/conistant/appcolor.dart';
import 'package:hos/core/localization/changlocal.dart';
import 'package:hos/veiw/userscreen/screen/auth/login.dart';
import 'package:hos/veiw/wedget/language/custumlang.dart';

import 'package:hos/veiw/wedget/onpording/costumButton.dart';
import 'package:hos/veiw/wedget/onpording/dotcontroller.dart';
import 'package:hos/veiw/wedget/onpording/silder.dart';

class Onboarding extends StatelessWidget {
  const Onboarding({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(OnboardingControler());
    final controller = Get.put(LocalController());
    // احصل على حجم الشاشة
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: TextButton.icon(
          label: Text("Choose Langauge"),
          onPressed: () {
            showModalBottomSheet(
              backgroundColor: Colors.grey[200],
              context: context,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              builder: (context) {
                return Container(
                  height: 300,
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.symmetric(horizontal: 5),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Choose Language",
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      SizedBox(
                        child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Custumlang(
                              textbutton: "العربيه",
                              onPressed: () {
                                controller.Changelang('ar');
                              },
                            ),
                            SizedBox(height: 20),
                            Custumlang(
                              textbutton: "Enlish",
                              onPressed: () {
                                controller.Changelang('en');
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
          icon: Icon(Icons.language),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(flex: 2, child: Slideronboarding()),

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
