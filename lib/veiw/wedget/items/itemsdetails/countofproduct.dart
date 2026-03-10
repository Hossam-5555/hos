import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hos/controler/usercontroller/home/itemsdetailscontroller.dart';

class Countofproduct extends GetView<Itemdetailscontroller> {
  const Countofproduct({super.key, required this.count});
  final count;
  @override
  Widget build(BuildContext context) {
    return Material(
      shape: RoundedRectangleBorder(side: BorderSide(color: Colors.black.withAlpha(70)),
        borderRadius: BorderRadius.circular(40)),
      child: SizedBox(
        width: 220,
        height: 50,
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
           
          
            IconButton(
              onPressed: () {
                controller.remove();
              },
              icon: Icon(Icons.remove),
            ),  Text(
              " $count ",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
             IconButton(
              onPressed: () {
                controller.add();
              },
              icon: Icon(Icons.add),
            ),
          ],
        ),
      ),
    );
  }
}
