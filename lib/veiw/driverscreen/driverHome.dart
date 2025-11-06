import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hos/controler/drivercontroller/homescreencontroller.dart';
import 'package:hos/core/functions/appexitalert.dart';
import 'package:hos/veiw/wedget/Homepage/buttomAppbar.dart';

class Driverhome extends StatelessWidget {
  const Driverhome({super.key});
  @override
  Widget build(BuildContext context) {
    Get.put(driverHomecontroller());

    return GetBuilder<driverHomecontroller>(
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
            preferredSize: Size.fromHeight(60),
            child: AppBar(
              title: Text(
                controller.driverAppbartitle[controller.Currentpage][0],
              ),
            ),
          ),

          // ================== التعديل هنا ==================

          // نضع شريط التنقل داخل Row لنجبره على التمركز وأخذ عرضه الطبيعي
          floatingActionButton: Row(
            mainAxisAlignment: MainAxisAlignment.center, // للتوسيط الأفقي
            children: [
              Buttomappbar(), // الـ Widget الخاص بك كما هو
            ],
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          // ===============================================
          body: controller.driverpage.elementAt(controller.Currentpage),
        ),
      ),
    );
  }
}
