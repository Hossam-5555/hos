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
              blurRadius: 1,
              color: const Color.fromARGB(255, 196, 196, 196).withAlpha(60),
              offset: const Offset(1, 2),
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
