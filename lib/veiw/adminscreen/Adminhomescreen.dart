import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hos/controler/admincontroller/AdminHome.dart';
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
                onTap: () {},
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
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.notifications_none),
              ),
              IconButton(
                onPressed: () {
                  Get.to(
                    () => Settings(),
                    transition: Transition.rightToLeftWithFade,
                    duration: const Duration(milliseconds: 500),
                  );
                },
                icon: const Icon(Icons.settings),
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
