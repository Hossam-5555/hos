import 'package:flutter/material.dart';
import 'package:hos/core/class/crud.dart';

// ignore: must_be_immutable
class Checkbutton extends StatelessWidget {
  Checkbutton({
    this.statusrequest,
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
  Statusrequest? statusrequest;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(backgroundColor: buttonColor),
      onPressed: onTap,
      child: Container(
        alignment: Alignment.center,
        width: width,
        padding: EdgeInsets.symmetric(vertical: 15), // مسافة داخل الزر

        child: statusrequest == Statusrequest.loading
            ? SizedBox(height: 35,
              child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3,),)
            : Text(
                buttonName,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 17,
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
