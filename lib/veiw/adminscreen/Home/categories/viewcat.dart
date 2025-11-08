import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hos/controler/admincontroller/categories/viewcontroller.dart';

class viewcategories extends StatelessWidget {
  const viewcategories({super.key});

  @override
  Widget build(BuildContext context) {
    viewcatcontroller controller = Get.put(viewcatcontroller());

    return Scaffold(
      appBar: AppBar(title: Text("data")),
      body: ListView.builder(
        itemCount: controller.catdata.length,
        itemBuilder: (context, index) => Container(
          height: 80,
          child: Card(
            child: Text("${controller.catdata[index].categoriesName}"),
          ),
        ),
      ),
    );
  }
}
