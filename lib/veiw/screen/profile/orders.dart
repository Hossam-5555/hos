import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hos/controler/profile/ordercontroller.dart';
import 'package:hos/core/class/handlingdataview.dart';

class Orders extends StatelessWidget {
  const Orders({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(Ordercontroller());
    return Scaffold(
      appBar: AppBar(title: Text("طلباتي ")),
      body: GetBuilder<Ordercontroller>(
        builder: (controller) => Handlingdataview(
          statusrequest: controller.statusrequest,
          widget: ListView.builder(
            itemCount: controller.orders.length,
            itemBuilder: (context, index) {
              return Card(
                child: ListTile(
                  title: Text(
                    controller.printpymentmethod(
                      controller.orders[index].ordersPaymentMethod.toString(),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
