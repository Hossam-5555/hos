import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hos/controler/home/Homescreencontroller.dart';
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
          appBar: AppBar(
            actions: [Homescrenaction()],
            title: Text(controller.Appbartitle[controller.Currentpage][0]),
          ),


          // ================== التعديل هنا ==================

          // نضع شريط التنقل داخل Row لنجبره على التمركز وأخذ عرضه الطبيعي
          floatingActionButton: Row(
            mainAxisAlignment: MainAxisAlignment.center, // للتوسيط الأفقي
            children: [
              Buttomappbar(), // الـ Widget الخاص بك كما هو
            ],
          ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
          // ===============================================
          body: controller.pages.elementAt(controller.Currentpage),
        ),
      ),
    );
  }
}
