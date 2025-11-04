import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hos/controler/usercontroller/onpoarding/onboarding_controler.dart';
import 'package:hos/core/conistant/appcolor.dart';
import 'package:hos/data/datasource/static/static.dart';

class Dotcontroller extends StatelessWidget {
  const Dotcontroller({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<OnboardingControler>(
      builder: (Controller) => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ...List.generate(
            onBoarding.length,
            (index) => AnimatedContainer(
              margin: EdgeInsets.all(10),
              width: Controller.curentpage==index?20:5,
              height: 6,
              decoration: BoxDecoration(
                color: Appcolor.deepPurple,
                borderRadius: BorderRadius.circular(20),
              ),
              duration: Duration(milliseconds: 500),
            ),
          ),
        ],
      ),
    );
  }
}
