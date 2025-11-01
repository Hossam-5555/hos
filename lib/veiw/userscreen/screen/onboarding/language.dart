import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hos/core/conistant/appcolor.dart';
import 'package:hos/core/conistant/imageasset.dart';
import 'package:hos/core/localization/changlocal.dart';
import 'package:hos/veiw/wedget/language/custumlang.dart';

class Language extends GetView<LocalController> {
  const Language({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Appcolor.white,
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              Imageasset.see,
            ), // تأكد من أن هذا المسار صحيح 100%
            fit: BoxFit.fill,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("1".tr, style: Theme.of(context).textTheme.headlineLarge),
            SizedBox(height: 10),

            Custumlang(
              textbutton: "Ar",
              onPressed: () {
                controller.Changelang('ar');
                Get.toNamed("Onboarding");
              },
            ),
            SizedBox(height: 20),
            Custumlang(
              textbutton: "En",
              onPressed: () {
                controller.Changelang('en');
                Get.toNamed("Onboarding");
              },
            ),
          ],
        ),
      ),
    );
  }
}
