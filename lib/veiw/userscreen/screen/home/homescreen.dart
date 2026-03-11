import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:hos/controler/usercontroller/home/Homescreencontroller.dart';
import 'package:hos/controler/usercontroller/notificationcontroller.dart';
import 'package:hos/core/conistant/imageasset.dart';
import 'package:hos/core/functions/appexitalert.dart';
import 'package:hos/veiw/userscreen/screen/home/notification.dart';
import 'package:hos/veiw/userscreen/screen/searchpage.dart';
import 'package:hos/veiw/wedget/Homepage/buttomAppbar.dart';
import 'package:hos/veiw/wedget/Homepage/homescrenAction.dart';

class Homescreen extends StatelessWidget {
  Homescreen({super.key});
  final controller = Get.put(Homescreencontroller());
  @override
  Widget build(BuildContext context) {
    // final size = MediaQuery.of(context).size;
    // final h = size.height;
    // final w = size.width;
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
              title: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: "A",
                      style: TextStyle(color: Colors.red),
                    ),
                    TextSpan(
                      text: "r",
                      style: TextStyle(color: Colors.blue),
                    ),
                    TextSpan(
                      text: "a",
                      style: TextStyle(color: Colors.green),
                    ),
                    TextSpan(
                      text: "c",
                      style: TextStyle(color: Colors.orange),
                    ),
                    TextSpan(
                      text: "o",
                      style: TextStyle(color: Colors.purple),
                    ),
                    TextSpan(
                      text: "n",
                      style: TextStyle(color: Colors.teal),
                    ),
                  ],
                ),
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.all(2),
                  child: Homescrenaction(
                    herotag: "Search",
                    onPressed: () {
                      Get.to(
                        () => Searchpage(),
                        transition: Transition.fadeIn,
                        duration: const Duration(milliseconds: 400),
                      );
                    },
                    child: SvgPicture.asset(
                      Imageasset.search,
                      height: 25,
                      width: 25,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2,horizontal: 5),
                  child: Homescrenaction(
                    herotag: "notification",
                    onPressed: () {
                      Get.to(
                        () => NotificationPage(),
                        transition: Transition.fadeIn,
                        duration: const Duration(milliseconds: 400),
                      );
                    },
                    child: GetBuilder<Notificationcontroller>(
                      builder: (controller) {
                        return Badge(
                          alignment: Alignment.topRight,
                          smallSize: 5,
                          largeSize: 5, // حجم النقطة مثل انستجرام
                          backgroundColor: Colors.red,
                          label: controller.notificationlist.isNotEmpty
                              ? const SizedBox()
                              : null,
                          child: SvgPicture.asset(
                            Imageasset.notification,
                            height: 25,
                            width: 25,
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
          bottomNavigationBar: Container(
            margin: EdgeInsets.only(left: 15, right: 15, bottom: 12),
            child: Buttomappbar(),
          ),
          body: IndexedStack(
            index: controller.Currentpage,
            children: controller.pages,
          ),
        ),
      ),
    );
  }
}
