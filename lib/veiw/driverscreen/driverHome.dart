import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hos/controler/drivercontroller/homescreencontroller.dart';
import 'package:hos/core/functions/appexitalert.dart';
import 'package:hos/veiw/wedget/Homepage/buttomappbardriver.dart';

class Driverhome extends StatelessWidget {
  const Driverhome({super.key});
  
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final height = size.height;
    final width = size.width;

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
            preferredSize: Size.fromHeight(height * 0.085), // ارتفاع نسبي
            child: AppBar(
              actions: [
                IconButton(
                  onPressed: () {
                    controller.Logout();
                  },
                  icon: Icon(Icons.exit_to_app),
                ),
              ],
              title: Text(
                controller.driverAppbartitle[controller.Currentpage][0],
              ),
            ),
          ),

          // ================== تعديل الـ BottomAppbar ==================
          floatingActionButton: Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom + height * 0.012,
            ),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: SizedBox(
                width: width * 0.65, // عرض نسبي
                child: Buttomappbardriver(),
              ),
            ),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          // =============================================================

          body: controller.driverpage.elementAt(controller.Currentpage),
        ),
      ),
    );
  }
}
