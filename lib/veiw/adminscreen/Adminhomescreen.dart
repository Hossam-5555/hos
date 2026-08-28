import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:hos/controler/admincontroller/AdminHome.dart';
import 'package:hos/core/conistant/imageasset.dart';
import 'package:hos/veiw/userscreen/screen/home/notification.dart';
import 'package:hos/veiw/userscreen/screen/profile/settings/settings.dart';
import 'package:hos/veiw/wedget/Homepage/buttomAppbar.dart';
import 'package:hos/veiw/wedget/Homepage/homescrenAction.dart';

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
              InkWell(
                onTap: () {
                  Get.to(() => Settings(), transition: Transition.cupertino);
                },
                child: CircleAvatar(
                  radius: 20,
                  backgroundImage: AssetImage(Imageasset.twetter),
                ),
              ),
              const SizedBox(width: 10),
              const Text(
                "Hello, Admin",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const Spacer(),

              Homescrenaction(
                herotag: "notification",
                onPressed: () {
                  Get.to(
                    () => NotificationPage(),
                    transition: Transition.cupertino,
                  );
                },
                child: Badge(
                  isLabelVisible: true,
                  child: SvgPicture.asset(Imageasset.notification),
                ),
              ),
            ],
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: GetBuilder<Adminhome>(
          builder: (controller) => Container(
            padding: EdgeInsets.all(5),
            margin: EdgeInsets.all(5),
            child: CustomBottomNavBar(
              items: [
                NavItem(
                  label: controller.title[0][0],
                  svgAsset: controller.title[0][1],
                ),
                NavItem(
                  label: controller.title[1][0],
                  svgAsset: controller.title[1][1],
                ),
                NavItem(
                  label: controller.title[2][0],
                  svgAsset: controller.title[2][1],
                ),
           
              ],
              currentIndex: controller.currentpage,
              onTap: controller.changePage,
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
