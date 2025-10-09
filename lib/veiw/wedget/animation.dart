import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class Animationlottie extends StatefulWidget {
  final String animationPath;

  Animationlottie({required this.animationPath});

  @override
  State<Animationlottie> createState() => AnimationlottieState();
}

class AnimationlottieState extends State<Animationlottie>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;

  @override
  void initState() {
    super.initState();
    // لا تقم بتعيين المدة هنا
    animationController = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // عند الضغط، أعد التشغيل
        animationController.reset();
        animationController.forward();
      },
      child: SizedBox(
        height: 200,
        width: 200,
        child: Lottie.asset(
          widget.animationPath,
          controller: animationController,
          // onLoaded هو مفتاح الحل
          onLoaded: (composition) {
            // هنا يتم تعيين مدة الأنيميشن الأصلية وبدء التشغيل
            animationController
              ..duration = composition.duration
              ..forward(); // شغل الأنيميشن مرة واحدة
          },
        ),
      ),
    );
  }
}

class Animationforstatus extends StatefulWidget {
  final String animationPath;

  Animationforstatus({required this.animationPath});

  @override
  State<Animationforstatus> createState() => _Animationforstatus();
}

class _Animationforstatus extends State<Animationforstatus>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: SizedBox(
        height: 200,
        width: 200,
        child: Lottie.asset(widget.animationPath),
      ),
    );
  }
}
