import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:hos/controler/usercontroller/home/Homescreencontroller.dart';
import 'package:hos/core/conistant/appcolor.dart';
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
                Container(padding: EdgeInsets.symmetric(horizontal: 5),height: 60,
                  width: w,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Get.to(
                            () => NotificationPage(),
                            transition: Transition.fadeIn,
                            duration: Duration(milliseconds: 400),
                          );
                        },
                        child: Container(
                          height: 50,
                          width: 50,
                          padding: EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                offset: Offset(0, 0.2),
                                blurRadius: 6,
                                color: Colors.black.withAlpha(60),
                                blurStyle: BlurStyle.normal,
                              ),
                            ],
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                          margin: EdgeInsets.only(left: 10, top: 1, bottom: 1),
                          child: SvgPicture.asset(
                            Imageasset.notification,
                            height: 20,
                            width: 20,
                          ),
                        ),
                      ),
                      Text(
                        controller.appbartitle[controller.Currentpage][0],
                        style: TextStyle(
                          color: Appcolor.black,
                          fontSize: 22, // ← حجم أنسب لعنوان الصفحة
                          fontFamily: 'RobotoMono', // ← استخدم اسم الخط هنا
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
