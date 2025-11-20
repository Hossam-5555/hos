import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hos/controler/admincontroller/order/ordertrackingcontroller.dart';

class Trackingorder extends StatelessWidget {
  const Trackingorder({super.key});

  @override
  Widget build(BuildContext context) {
    Trackingordercontroller controller = Get.put(Trackingordercontroller());
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: TextButton(
              child: Text("data"),
              onPressed: () {
                controller.Getcurrentlocation();
              },
            ),
          ),
        ],
      ),
    );
  }
}
