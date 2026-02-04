import 'package:flutter/material.dart';
import 'package:hos/core/conistant/appcolor.dart';

// ignore: must_be_immutable
class Custumlang extends StatelessWidget {
  Custumlang({super.key, required this.textbutton, required this.onPressed});
  String textbutton;
  void Function()? onPressed;
  @override
  Widget build(BuildContext context) {
    return Container(height: 50,
    width: 100,
      padding: EdgeInsets.all(0),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Appcolor.deepPurple,
      ),
      child: TextButton(
        onPressed: onPressed,
        child: Text(
          textbutton,
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
