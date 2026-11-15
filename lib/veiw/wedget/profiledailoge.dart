import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hos/core/conistant/app_colors.dart';
import 'package:hos/core/conistant/imageasset.dart';

class ComingSoonOverlay {
  static void show() {
    Get.dialog(
      const _ComingSoonDialog(),
      barrierDismissible: true,
      barrierColor: AppColors.black.withAlpha(90),
      transitionDuration: const Duration(milliseconds: 350),
    );
  }
}

class _ComingSoonDialog extends StatelessWidget {
  const _ComingSoonDialog();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0.75, end: 1),
        duration: const Duration(milliseconds: 450),
        curve: Curves.easeOutBack,
        builder: (context, scale, child) {
          return Transform.scale(scale: scale, child: child);
        },
        child: Container(
          width: 300,
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
          decoration: BoxDecoration(
            // ignore: deprecated_member_use
            color: Theme.of(context).dialogBackgroundColor,
            borderRadius: BorderRadius.circular(28),
            boxShadow: [
              BoxShadow(
                color: AppColors.black.withAlpha(38),
                blurRadius: 30,
                offset: const Offset(0, 15),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Close button
              Align(
                alignment: Alignment.topRight,
                child: GestureDetector(
                  onTap: Get.back,
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      shape: BoxShape.circle,
                    ),
                    child:  Icon(
                      Icons.close_rounded,
                      color: AppColors.black,
                      size: 18,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 4),

              // Treasure image
              Container(
                width: 115,
                height: 115,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.warning,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Image.asset(Imageasset.goold, fit: BoxFit.contain),
                ),
              ),

              const SizedBox(height: 18),

               Text(
                'Coming Soon',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: AppColors.grey,
                  decoration: TextDecoration.none, // ✅ شيل أي underline
                ),
              ),

              const SizedBox(height: 8),

              Text(
                'This treasure is still being prepared.\nStay tuned for something special!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  height: 1.5,
                  color: AppColors.grey,
                  decoration: TextDecoration.none, // ✅ هنا برضو
                ),
              ),

              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: Get.back,
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor: AppColors.warning,
                    foregroundColor: AppColors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: const Text(
                    'Got it',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
