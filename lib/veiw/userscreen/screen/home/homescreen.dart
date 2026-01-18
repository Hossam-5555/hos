import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:hos/controler/usercontroller/home/Homescreencontroller.dart';
import 'package:hos/core/conistant/imageasset.dart';
import 'package:hos/core/functions/appexitalert.dart';
import 'package:hos/veiw/userscreen/screen/home/notification.dart';
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
              leading: GestureDetector(
                onTap: () {
                  Get.to(
                    () => NotificationPage(),
                    transition: Transition.fadeIn,
                    duration: Duration(milliseconds: 400),
                  );
                },
                child: Container(
                  height: 60,
                  width: 60,
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        offset: Offset(0.1, 0.1),
                        blurRadius: 5,
                        color: Colors.black.withAlpha(55),
                        blurStyle: BlurStyle.normal,
                      ),
                    ],
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                  margin: EdgeInsets.only(left: 10),
                  child: SvgPicture.asset(
                    Imageasset.notification,
                    height: 20,
                    width: 20,
                  ),
                ),
              ),
              actions: [Homescrenaction()],
              title: Text(controller.Appbartitle[controller.Currentpage][0]),
            ),
          ),

          // ============= تعديل مكان الـ BottomAppbar =================
          bottomNavigationBar: Container(
            margin: EdgeInsets.only(left: 50, right: 50, bottom: 10),
            child: Buttomappbar(),
          ),

          // =================================================================
          body: controller.pages.elementAt(controller.Currentpage),
        ),
      ),
    );
  }
}
