import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hos/controler/usercontroller/home/itemsdetailscontroller.dart';

class Countofproduct extends GetView<Itemdetailscontroller> {
  const Countofproduct({super.key, required this.count});
  final  count;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: () {
            controller.add();
          },
          icon: Icon(Icons.add),
        ),
        Text(
          " $count ",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
        ),
        IconButton(
          onPressed: () {
            controller.remove();
          },
          icon: Icon(Icons.remove),
        ),
      ],
    );
  }
}
