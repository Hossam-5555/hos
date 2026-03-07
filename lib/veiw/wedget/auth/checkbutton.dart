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
    return ElevatedButton(
      style: ElevatedButton.styleFrom(backgroundColor: buttonColor),
      onPressed: onTap,
      child: Container(
        alignment: Alignment.center,
        width: width,
        padding: EdgeInsets.symmetric(vertical: 15), // مسافة داخل الزر

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
    // return InkWell(
    //   onTap: onTap,
    //   child: Container(
    //     width: width,
    //     padding: EdgeInsets.symmetric(vertical: 15), // مسافة داخل الزر
    //     alignment: Alignment.center,
    //     decoration: BoxDecoration(
    //       color: buttonColor,
    //       borderRadius: BorderRadius.circular(40),

    //     ),
    //     child:
    //   ),
    // );
  }
}
