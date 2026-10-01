import 'package:flutter/material.dart';

// ignore: must_be_immutable
class Homescrenaction extends StatelessWidget {
  Homescrenaction({
    super.key,
    required this.herotag,
    this.onPressed,
    required this.child,
    this.color,
  });
  Color? color;
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
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color:color?? Color(0xFFE0E3E8),
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
