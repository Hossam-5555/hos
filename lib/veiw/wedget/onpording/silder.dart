import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hos/controler/usercontroller/onpoarding/onboarding_controler.dart';
import 'package:hos/data/datasource/static/static.dart';

class Slideronboarding extends GetView<OnboardingControler> {
  const Slideronboarding({super.key});

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: controller.pageController,
      itemCount: onBoarding.length,
      onPageChanged: (val) {
        controller.onpagechange(val);
      },
      itemBuilder: (context, i) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              onBoarding[i].title!,
              style: Theme.of(context).textTheme.headlineLarge
            ),
            Image.asset(
              onBoarding[i].img!,
              width: 200,
              height: 230,
              fit: BoxFit.fill,
            ),
            Container(
              width: double.infinity,
              alignment: Alignment.center,
              child: Text(
                onBoarding[i].body!,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            SizedBox(height: 10),
          ],
        );
      },
    );
  }
}
