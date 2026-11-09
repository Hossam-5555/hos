import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hos/controler/usercontroller/home/itemsdetailscontroller.dart';

// ignore: must_be_immutable
class Countofproduct extends GetView<Itemdetailscontroller> {
  Countofproduct({super.key, required this.count, required this.isdark});
  final count;
  bool? isdark;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 55,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(40),
        color: isdark! ? const Color(0xFF1C1C22) : Colors.black,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
            onPressed: () => controller.remove(),
            iconSize: 20,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 35, minHeight: 35),
            style: IconButton.styleFrom(
              backgroundColor: Colors.white, // اللون اللي أنت عايزه
              shape: const CircleBorder(),
            ),
            icon: const Icon(Icons.remove, color: Colors.black),
          ),
          Text(
            " $count ",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          IconButton(
            onPressed: () => controller.add(),
            iconSize: 20,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 35, minHeight: 35),
            style: IconButton.styleFrom(
              backgroundColor: Colors.black, // اللون اللي أنت عايزه
              shape: const CircleBorder(),
            ),
            icon: const Icon(Icons.add_rounded, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
