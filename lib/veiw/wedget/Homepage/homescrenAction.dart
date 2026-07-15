import 'package:flutter/material.dart';

// ignore: must_be_immutable
class Homescrenaction extends StatelessWidget {
  Homescrenaction({
    super.key,
    required this.herotag,
    this.onPressed,
    required this.child,
  });
  String herotag;
  void Function()? onPressed;
  Widget child;
  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: herotag,
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(border: Border.all(color: Colors.grey.withAlpha(46)),
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFFFFFFF), // مركز الإضاءة الأبيض المشع
              Color(0xFFF2F4F7), // البلاتينيوم الناعم
              Color(0xFFD0D5DD), // الأطراف الفضية الراقية
            ],
          ),

          shape: BoxShape.circle,
        ),
        child: MaterialButton(
          shape: const CircleBorder(),
          onPressed: onPressed,
          child: child,
        ),
      ),
    );
  }
}
