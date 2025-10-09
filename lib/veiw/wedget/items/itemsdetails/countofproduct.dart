import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hos/controler/home/itemsdetailscontroller.dart';

class Countofproduct extends GetView<Itemdetailscontroller> {
  const Countofproduct({super.key, this.count});
  final count;
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              controller.add();
            },
            icon: Icon(Icons.add),
          ),
          Text(
            "$count",
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
      ),
    );
  }
}
