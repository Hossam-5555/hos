import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:hos/controler/admincontroller/admin_controller.dart';
import 'package:hos/controler/usercontroller/notificationcontroller.dart';
import 'package:hos/core/conistant/imageasset.dart';
import 'package:hos/core/conistant/routs.dart';
import 'package:hos/veiw/wedget/Homepage/buttomAppbar.dart';
import 'package:hos/veiw/wedget/Homepage/home_screnaction.dart';

class AdminHome extends StatelessWidget {
  AdminHome({super.key});
  final Adminhome controller = Get.put(Adminhome());
  @override
  Widget build(BuildContext context) {
    return GetBuilder<Adminhome>(
      builder: (controller) => Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              const SizedBox(width: 10),
              const Text(
                "Hello, Admin",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const Spacer(),

              GetBuilder<Notificationcontroller>(
                builder: (controller) {
                  int hasUnread = controller.notificationcount;

                  return Homescrenaction(
                    herotag: "notification",
                    onPressed: () {
                      Get.toNamed(Approute.notificationPage);
                    },
                    child: Badge(
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
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: GetBuilder<Adminhome>(
          builder: (controller) => Container(
            padding: EdgeInsets.all(5),
            margin: EdgeInsets.all(10),
            child: CustomBottomNavBar(
              items: [
                NavItem(
                  label: controller.title[0][0],
                  svgAsset: controller.title[0][1],
                ),
               
                NavItem(
                  label: controller.title[2][0],
                  svgAsset: controller.title[2][1],
                ), NavItem(
                  label: controller.title[1][0],
                  svgAsset: controller.title[1][1],
                ),
                NavItem(
                  label: controller.title[3][0],
                  svgAsset: controller.title[3][1],
                ),
              ],
              currentIndex: controller.currentpage,
              onTap: controller.changePage,
              cartcount: 0,
              isbadgeActive: false,
            ),
          ),
        ),
        body: PageView(
          physics: const NeverScrollableScrollPhysics(),
          controller: controller.controller,
          onPageChanged: (value) {
            controller.onpagechanged(value);
          },
          children: controller.pages,
        ),
      ),
    );
  }
}
