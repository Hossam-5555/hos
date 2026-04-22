import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hos/controler/usercontroller/onpoarding/onboarding_controler.dart';
import 'package:hos/core/conistant/imageasset.dart';
import 'package:hos/data/model/onBordingmodel.dart';
import 'package:hos/veiw/wedget/animation.dart';

List<Onbordingmodel> onBoarding = [
  Onbordingmodel(
    "Choose Product",
    Imageasset.onbordingImageone,
    "We have 100k+ products.\nChoose your product from our\nE-commerce shop.",
  ),
  Onbordingmodel(
    "Easy & Safe Payment",
    Imageasset.onbordingImagetwo,
    "Secure and simple payment options\nfor a smooth shopping experience.",
  ),
];

class Slideronboarding extends GetView<OnboardingControler> {
  const Slideronboarding({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return PageView.builder(
      controller: controller.pageController,
      itemCount: onBoarding.length,
      onPageChanged: controller.onpagechange,
      itemBuilder: (context, i) {
        final item = onBoarding[i];

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                child: Animationlottie(
                  animationPath: item.img.toString(),
                  h: 400,
                  w: 400,
                ),
              ),
              Text(
                item.title!,
                textAlign: TextAlign.center,
                style: textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                  fontSize: 30,
                ),
              ),
              SizedBox(height: 20),
              Text(
                item.body!,
                textAlign: TextAlign.center,
                style: textTheme.bodyMedium?.copyWith(
                  color: Colors.black54,
                  height: 1.5,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
