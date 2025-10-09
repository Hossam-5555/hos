import 'package:flutter/material.dart';

class Titles extends StatelessWidget {
  const Titles({super.key, required this.title});
final String title;
  @override
  Widget build(BuildContext context) {
    return  Container(
    margin:EdgeInsets.symmetric(vertical: 5,horizontal: 5) ,
              alignment: Alignment.centerLeft,
              child: Text(
                textAlign: TextAlign.center,
                title,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            );
  }
}