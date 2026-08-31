import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hos/controler/usercontroller/onpoarding/onboarding_controler.dart';
import 'package:hos/veiw/wedget/auth/checkbutton.dart';

class Onboarding extends StatelessWidget {
  Onboarding({super.key});

  final c = Get.put(OnboardingControler());

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        child: Stack(
          fit: StackFit.expand,

          children: [
            // =========================
            // الصورة
            // =========================
            Positioned.fill(
              child: Image.network(
                'https://shebad.app/wp-content/uploads/2025/01/1263-1.png',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Center(
                    child: Icon(
                      Icons.image_not_supported,
                      color: Colors.white,
                      size: 50,
                    ),
                  );
                },
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) {
                    return child;
                  }

                  return const Center(
                    child: CircularProgressIndicator(color: Colors.white),
                  );
                },
              ),
            ),

            // =========================
            // اسم التطبيق
            // =========================
            Positioned(
              top: size.height * 0.075,
              left: 24,
              child: const Text(
                'LuxCart',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -2,
                ),
              ),
            ),

            // =========================
            // النصوص والزر
            // =========================
            Positioned(
              left: 24,
              right: 24,
              bottom: 20,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Find Your Perfect Fit',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    'Discover styles tailored to you, with\n'
                    'comfort and confidence.',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 11,
                      height: 1.35,
                    ),
                  ),

                  const SizedBox(height: 20),

                  SizedBox(
                    width: double.infinity,
                    child: Checkbutton(
                      buttonColor: Colors.black,
                      width: double.infinity,
                      onTap: () {
                        c.next();
                      },
                      buttonName: 'Get Started',
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
