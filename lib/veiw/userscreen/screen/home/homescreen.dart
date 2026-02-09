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
    final size = MediaQuery.of(context).size;
    // final h = size.height;
    final w = size.width;
    return GetBuilder<Homescreencontroller>(
      builder: (controller) => PopScope(
        canPop: false,
        // ignore: deprecated_member_use
        onPopInvoked: (didPop) async {
          if (didPop) return;
          final bool shouldExit = await appexitAlert();
          if (shouldExit == true) {
            exit(0);
          }
        },
        child: Scaffold(
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(60),
            child: AppBar(
              actions: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  height: 60,
                  width: w,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(textAlign:TextAlign.right ,
                        "",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Homescrenaction(),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // ============= تعديل مكان الـ BottomAppbar =================
          bottomNavigationBar: Container(
            margin: EdgeInsets.only(left: 12, right: 12, bottom: 12),
            child: Buttomappbar(),
          ),

          // =================================================================
          body: controller.pages.elementAt(controller.Currentpage),
        ),
      ),
    );
  }
}
