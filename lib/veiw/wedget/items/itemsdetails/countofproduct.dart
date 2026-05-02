import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hos/controler/usercontroller/home/itemsdetailscontroller.dart';

class Countofproduct extends GetView<Itemdetailscontroller> {
  const Countofproduct({super.key, required this.count});
  final count;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 55,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: AlignmentGeometry.topLeft,
          end: AlignmentGeometry.bottomRight,
          colors: [Colors.blue,Colors.white, const Color.fromARGB(255, 111, 132, 170)],
        ),
        borderRadius: BorderRadius.circular(40),
        color: Colors.grey[200],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
            onPressed: () {
              controller.remove();
            },
            icon: Icon(Icons.remove,color: Colors.black,),
          ),
          Text(
            " $count ",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold,color: Colors.black87),
          ),
          IconButton(
            onPressed: () {
              controller.add();
            },
            icon: Icon(Icons.add,color: Colors.black,),
          ),
        ],
      ),
    );
  }
}
