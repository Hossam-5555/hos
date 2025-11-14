import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hos/controler/usercontroller/home/Homescreencontroller.dart';
import 'package:hos/core/functions/appexitalert.dart';
import 'package:hos/veiw/wedget/Homepage/buttomAppbar.dart';
import 'package:hos/veiw/wedget/Homepage/homescrenAction.dart';

class Homescreen extends StatelessWidget {
  const Homescreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(Homescreencontroller());

    return GetBuilder<Homescreencontroller>(
      builder: (controller) => PopScope(
        canPop: false,
        onPopInvoked: (didPop) async {
          if (didPop) return;
          final bool? shouldExit = await appexitAlert();
          if (shouldExit == true) {
            exit(0);
          }
        },
        child: Scaffold(
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(60),
            child: AppBar(
              actions: [Homescrenaction()],
              title: Text(controller.Appbartitle[controller.Currentpage][0]),
            ),
          ),

          // ============= تعديل مكان الـ BottomAppbar =================
          floatingActionButton: SizedBox(
            width: MediaQuery.of(context).size.width * 0.65, // عرض مناسب
            child: Buttomappbar(), // widget الخاص بك كما هو
          ),

          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,

          // =================================================================
          body: controller.pages.elementAt(controller.Currentpage),
        ),
      ),
    );
  }
}
