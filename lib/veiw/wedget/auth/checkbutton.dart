import 'package:flutter/material.dart';

// ignore: must_be_immutable
class Checkbutton extends StatelessWidget {
  Checkbutton({
    super.key,
    required this.onTap,
    required this.buttonName,
     this.width,
    this.buttonColor,
  });
  void Function() onTap;
  double? width;
  Color? buttonColor;
  String buttonName;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: width,
        padding: EdgeInsets.symmetric(vertical: 12), // مسافة داخل الزر
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: buttonColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: const Color.fromARGB(255, 32, 6, 109).withAlpha(26), // 0.1 * 255 = 26
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
