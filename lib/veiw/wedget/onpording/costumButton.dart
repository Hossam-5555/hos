import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hos/controler/usercontroller/onpoarding/onboarding_controler.dart';

class CustomButton extends GetView<OnboardingControler> {
  final String buttonName;
  final Color buttonColor;
  final double width;

  const CustomButton({
    super.key,
    required this.buttonName,
    required this.width,
    required this.buttonColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: controller.next,
      child: Container(height: 70,
        width: width,
        padding: const EdgeInsets.symmetric(vertical: 5),
        alignment: Alignment.center,
        decoration: BoxDecoration(shape: BoxShape.circle,
          color: buttonColor,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              offset: const Offset(3, 3),
              blurRadius: 5,
            ),
          ],
        ),
        child: Icon(Icons.arrow_forward_ios_sharp,color: Colors.white,)
      ),
    );
  }
}