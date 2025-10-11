import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hos/controler/home/Homescreencontroller.dart';
import 'package:hos/veiw/wedget/Homepage/buttomAppbar.dart';
import 'package:hos/veiw/wedget/Homepage/homescrenAction.dart';

class Homescreen extends StatelessWidget {
  const Homescreen({super.key});
  @override
  Widget build(BuildContext context) {
    Get.put(Homescreencontroller());

    return GetBuilder<Homescreencontroller>(
      builder: (controller) => Scaffold(
        appBar: AppBar(
          actions: [Homescrenaction()],
          title: Text(controller.Appbartitle[controller.Currentpage][0]),
        ),
        floatingActionButton: Buttomappbar(),

        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

        body: controller.pages.elementAt(controller.Currentpage),
      ),
    );
  }
}
