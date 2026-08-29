import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:hos/controler/usercontroller/home/Homescreencontroller.dart';
import 'package:hos/controler/usercontroller/notificationcontroller.dart';
import 'package:hos/core/conistant/imageasset.dart';
import 'package:hos/core/conistant/routs.dart';
import 'package:hos/core/functions/appexitalert.dart';
import 'package:hos/veiw/wedget/Homepage/buttomAppbar.dart';
import 'package:hos/veiw/wedget/Homepage/homescrenAction.dart';

class Homescreen extends StatelessWidget {
  Homescreen({super.key});
  final controller = Get.put(Homescreencontroller());
  @override
  Widget build(BuildContext context) {
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
          appBar: controller.Currentpage == 2
              ? null
              : PreferredSize(
                  preferredSize: const Size.fromHeight(60),
                  child: AppBar(
                    centerTitle: false,
                    scrolledUnderElevation: 0,
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(width: 10),
                        Text(
                          "LUXE",
                          style: TextStyle(
                            fontSize: (w * 0.065).clamp(20.0, 26.0),
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1.2,
                            color: const Color(0xFF3E5FFF),
                          ),
                        ),
                      ],
                    ),
                    actions: [
                      Padding(
                        padding: const EdgeInsetsDirectional.symmetric(
                          horizontal: 10,
                        ),
                        child: Homescrenaction(
                          herotag: "notification",
                          onPressed: () {
                            Get.toNamed(Approute.notificationPage);
                          },
                          child: GetBuilder<Notificationcontroller>(
                            builder: (controller) {
                              int hasUnread = controller.notificationcount;

                              return Badge(
                                isLabelVisible: hasUnread > 0,
                                alignment: const Alignment(0.1, 0.90),
                                label: Text(
                                  hasUnread.toString(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                  ),
                                ),
                                smallSize: 9,
                                backgroundColor: Colors.redAccent,
                                child: SvgPicture.asset(
                                  Imageasset.notification,
                                  height: 24,
                                  width: 24,
                                  color: Colors.black,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

          // ============= تعديل مكان الـ BottomAppbar =================
          floatingActionButton: Container(
            alignment: Alignment.bottomCenter,
            margin: EdgeInsetsDirectional.symmetric(
              horizontal: 12,
              vertical: 5,
            ),
            child: // مع GetX
            GetBuilder<Homescreencontroller>(
              builder: (controller) => CustomBottomNavBar(
                items: [
                  NavItem(
                    label: controller.appbartitle[0][0],
                    svgAsset: controller.appbartitle[0][1],
                  ),
                  NavItem(
                    label: controller.appbartitle[1][0],
                    svgAsset: controller.appbartitle[1][1],
                  ),
                  NavItem(
                    label: controller.appbartitle[2][0],
                    svgAsset: controller.appbartitle[2][1],
                  ),
                  NavItem(
                    label: controller.appbartitle[3][0],
                    imageAsset: controller.appbartitle[3][1],
                  ),
                ],
                currentIndex: controller.Currentpage,
                onTap: controller.changpage,
                visible: controller.upordown,
              ),
            ),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation
              .centerDocked, // تعديل مكان الـ BottomAppbar
          body: PageView(
            controller: controller.pageControllers,
            onPageChanged: (i) {
              controller.onpagechnage(i);
            },
            children: controller.pages,
          ),
        ),
      ),
    );
  }
}
