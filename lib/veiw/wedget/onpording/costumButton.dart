import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hos/controler/onpoarding/onboarding_controler.dart';

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
    return InkWell(
      onTap: () {
        controller.next(); // يستخدم الدالة من OnboardingController
      },
      child: Container(
        width: width,
        padding: EdgeInsets.symmetric(vertical: 12), // مسافة داخل الزر
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: buttonColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              offset: Offset(3, 3),
              blurRadius: 5,
            ),
          ],
        ),
        child: Text(
          buttonName,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
