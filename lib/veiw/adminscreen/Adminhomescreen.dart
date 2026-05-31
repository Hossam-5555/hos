import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:hos/controler/admincontroller/AdminHome.dart';
import 'package:hos/core/conistant/imageasset.dart';
import 'package:hos/veiw/userscreen/screen/home/notification.dart';
import 'package:hos/veiw/userscreen/screen/profile/settings/settings.dart';

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
                   Get.to(
                    () => Settings(),
                    transition: Transition.cupertino,
                  );
                },
                child: const CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage(
                    "https://i.pravatar.cc/150?img=3",
                  ),
                ),
              ),
              const SizedBox(width: 10),
              const Text(
                "Hello, Admin",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const Spacer(),

              InkWell(
                onTap: () {
                  Get.to(
                    () => NotificationPage(),
                    transition: Transition.cupertino,
                  );
                },
                child: Badge(
                  isLabelVisible: true,
                  child: SvgPicture.asset(
                    Imageasset.notification,
                    color: Colors.grey.shade600,
                  ),
                ),
              ),
             
            ],
          ),
        ),
        bottomNavigationBar: GetBuilder<Adminhome>(
          builder: (controller) => BottomNavigationBar(
            selectedItemColor: Colors.blue,
            unselectedItemColor: Colors.grey,
            showUnselectedLabels: true,
            selectedLabelStyle: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
            unselectedLabelStyle: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.normal,
            ),
            onTap: (value) {
              controller.changePage(value);
            },
            currentIndex: controller.currentpage,
            items: controller.pages.map((e) {
              int index = controller.pages.indexOf(e);
              return BottomNavigationBarItem(
                icon: Icon(controller.title[index][1]),
                label: controller.title[index][0],
              );
            }).toList(),
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
