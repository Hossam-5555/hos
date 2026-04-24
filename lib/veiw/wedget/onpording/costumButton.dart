import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hos/controler/usercontroller/onpoarding/onboarding_controler.dart';

class CustomButton extends GetView<OnboardingControler> {
  final String buttonName; // ملاحظة: بما إنه أيقونة حالياً ممكن تستغني عنه أو تخليه للـ Tooltip
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
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: 65, // تقليل الارتفاع قليلاً ليكون متناسق
        width: 65,  // بما إنه دائرة خليه العرض يساوي الارتفاع ثابتاً
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: buttonColor,
          // إضافة تدرج لوني خفيف يعطي فخامة (Gradient)
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              buttonColor,
              buttonColor.withOpacity(0.8),
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: buttonColor.withOpacity(0.3),
              offset: const Offset(0, 8), // دفع الظل للأسفل أكثر يعطي إحساس بالعمق
              blurRadius: 15,
              spreadRadius: 1,
            ),
          ],
          // إطار خارجي رفيع جداً ليعطي تحديد (Stroke)
          border: Border.all(
            color: Colors.white.withOpacity(0.2),
            width: 1.5,
          ),
        ),
        child: const Center(
          child: Icon(
            Icons.chevron_right_rounded, // أيقونة أنعم (Rounded) وأشيك
            color: Colors.white,
            size: 30,
          ),
        ),
      ),
    );
  }
}