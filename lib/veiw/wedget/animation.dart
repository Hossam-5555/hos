import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class Animationlottie extends StatefulWidget {
  final String animationPath;
  final double h;
  final double w;

  const Animationlottie({
    super.key,
    required this.animationPath,
    required this.h,
    required this.w,
  });

  @override
  State<Animationlottie> createState() => AnimationlottieState();
}

class AnimationlottieState extends State<Animationlottie>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;

  @override
  void initState() {
    super.initState();

    animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.h,
      width: widget.w,
      child: Lottie.asset(
        widget.animationPath,
        controller: animationController,
        onLoaded: (composition) {
          animationController
            ..duration = composition.duration
            ..forward();

          // تشغيل لمدة معينة ثم الإيقاف
          Future.delayed(const Duration(seconds: 8), () {
            if (mounted) {
              animationController.reset();
              animationController.stop();
            }
          });
        },
      ),
    );
  }
}

class Animationforstatus extends StatefulWidget {
  final String animationPath;

  const Animationforstatus({super.key, required this.animationPath});

  @override
  State<Animationforstatus> createState() => _Animationforstatus();
}

class _Animationforstatus extends State<Animationforstatus>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      width: 200,
      child: Lottie.asset(widget.animationPath),
    );
  }
}
