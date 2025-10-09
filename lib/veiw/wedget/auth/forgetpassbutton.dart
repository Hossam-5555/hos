import 'package:flutter/material.dart';


// ignore: must_be_immutable
class Forgetpassbutton extends StatelessWidget {
   Forgetpassbutton({super.key,this.onPressed});
   void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerRight,
      child: TextButton.icon(
        onPressed: onPressed,
        label: Icon(Icons.question_mark),
        icon: Text('Forget passward  ',style: TextStyle(fontSize: 12),),
      ),
    );
  }
}
