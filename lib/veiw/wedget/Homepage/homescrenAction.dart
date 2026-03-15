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
        height: 52,
        width: 52,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
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
