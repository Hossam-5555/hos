import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:get/get_instance/get_instance.dart';
import 'package:get/state_manager.dart';
import 'package:hos/controler/home/itemsdetailscontroller.dart';
// import 'package:hos/core/conistant/linkApi.dart';
import 'package:hos/veiw/wedget/items/itemsdetails/buttom.dart';
import 'package:hos/veiw/wedget/items/itemsdetails/countofproduct.dart';
import 'package:hos/veiw/wedget/items/itemsdetails/productimage.dart';

// ignore: must_be_immutable
class Itemsdetailes extends GetView<Itemdetailscontroller> {
  Itemsdetailes({super.key});
  Itemdetailscontroller itemsdetailscontroller = Get.put(
    Itemdetailscontroller(),
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(" Detailes"),
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(Icons.arrow_back_ios,color: Colors.white,),
        ),
      ),
      body: GetBuilder<Itemdetailscontroller>(
        builder: (controller) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // صورة المنتج
                Productimagedetails(),
                const SizedBox(height: 20),

                // اسم المنتج
                Text(
                  '${itemsdetailscontroller.itemsmodel.itemsName}',

                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 10),

                // السعر
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      "السعر: ${itemsdetailscontroller.itemsmodel.itemspricediscount}",
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.green,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Countofproduct(count: itemsdetailscontroller.itemcount),
                  ],
                ),

                const SizedBox(height: 20),

                // وصف المنتج
                const Text(
                  "هذا وصف تفصيلي للمنتج يوضح كل الخصائص والمميزات "
                  "مع شرح كامل يساعد المستخدم في معرفة التفاصيل قبل الشراء.",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                    height: 1.5,
                  ),
                ),

                const SizedBox(height: 30),

                // زر الشراء
                Buttom(),
              ],
            ),
          );
        },
      ),
    );
  }
}
