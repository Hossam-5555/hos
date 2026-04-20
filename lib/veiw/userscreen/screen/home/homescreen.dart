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
              centerTitle: false,
              scrolledUnderElevation:
                  0, // منع تغير اللون عند السكرول في Material 3
              title: Text(
                "${controller.appbartitle[controller.Currentpage][0]}",
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              actions: [
                // زر البحث
                controller.Currentpage == 3
                    ? SizedBox.shrink()
                    : Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
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
                            height: 24, // توحيد الحجم
                            width: 24,
                          ),
                        ),
                      ),

                // زر الإشعارات
                Padding(
                  padding: const EdgeInsets.only(
                    right: 16,
                    left: 4,
                  ), // مسافة ممتازة من الحافة
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
                        // نتحقق إذا كان فيه إشعارات ولا لأ
                        int hasUnread = controller.notificationcount;

                        return Badge(
                          isLabelVisible:
                              hasUnread > 0, // دي الطريقة الصح لإخفاء البادج
                          alignment: const Alignment(0.1, 0.90),
                          label: Text(
                            hasUnread.toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ), // تظبيط مكان النقطة على الأيقونة
                          smallSize: 9, // حجم النقطة مناسب للعين
                          backgroundColor: Colors.redAccent,
                          child: SvgPicture.asset(
                            Imageasset.notification,
                            height: 24, // توحيد الحجم
                            width: 24,
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
            margin: EdgeInsets.symmetric(horizontal: 12, vertical: 5),
            child: Buttomappbar(),
          ),
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
