import 'package:flutter/material.dart';

// ignore: must_be_immutable
class GoogleFacetweter extends StatelessWidget {
  GoogleFacetweter({super.key, required this.image, required this.w});
  String image;
double w;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      
      style: ElevatedButton.styleFrom(
         backgroundColor: Colors.white
      )
      ,
      label: Container(width: w,
        child: Image.asset(height: 50,width: 50,
          image, fit: BoxFit.contain),
      ),
      onPressed: () {},
    );
  }
}
