import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart'; // لتفعيل ScrollDirection
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:hos/controler/usercontroller/checkout&cart/cart_controller.dart';
import 'package:hos/controler/usercontroller/home/homescreen_controller.dart';
import 'package:hos/controler/usercontroller/notificationcontroller.dart';
import 'package:hos/core/conistant/imageasset.dart';
import 'package:hos/core/conistant/routs.dart';
import 'package:hos/core/functions/appexitalert.dart';
import 'package:hos/veiw/userscreen/screen/profile/Editprofile.dart';
import 'package:hos/veiw/wedget/Homepage/buttomAppbar.dart';
import 'package:hos/veiw/wedget/appbarbackicon.dart';

class Homescreen extends StatelessWidget {
  Homescreen({super.key});
  final controller = Get.put(Homescreencontroller());
  final cart = Get.put(CartController());

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
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
              backgroundColor:
                  controller.Currentpage == 2 && cart.data.isNotEmpty
                  ? Theme.of(context).cardColor
                  : Theme.of(context).appBarTheme.backgroundColor,
              centerTitle: false,
              scrolledUnderElevation: 0,
              title: Text.rich(
                TextSpan(children: [TextSpan(text: controller.userName)]),
              ),

              actions: [
                controller.Currentpage != 1
                    ? Homescrenaction(
                        herotag: "notification",
                        onPressed: () {
                          Get.toNamed(Approute.notificationPage);
                        },
                        child: GetBuilder<Notificationcontroller>(
                          builder: (controller) {
                            int hasUnread = controller.notificationcount.value;

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
                                // ignore: deprecated_member_use
                                color: Colors.black,
                              ),
                            );
                          },
                        ),
                      )
                    : SizedBox.shrink(),
                SizedBox(width: 5,),
                controller.Currentpage == 3
                    ? Homescrenaction(
                        herotag: "editprofile",
                        onPressed: () {
                          Get.to(() => EditProfileView());
                        },
                        child: SvgPicture.asset(
                          Imageasset.profile,
                          height: 25,
                          width: 25,
                          // ignore: deprecated_member_use
                          color: Colors.black,
                        ),
                      )
                    : SizedBox.shrink(),
                                    SizedBox(width: 5,),

              ],
            ),
          ),
          resizeToAvoidBottomInset: false,

          floatingActionButton: SafeArea(
            child: Container(
              alignment: Alignment.bottomCenter,
              padding: EdgeInsets.only(
                left: w * 0.04,
                right: w * 0.04,
                bottom: 10,
              ),
              child: GetBuilder<Homescreencontroller>(
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
                      svgAsset: controller.appbartitle[3][1],
                    ),
                  ],
                  currentIndex: controller.Currentpage,
                  onTap: controller.changpage,
                  visible: controller.upordown,
                  cartcount: cart.countitem.value,
                ),
              ),
            ),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,

          // ============= الاستماع للتمرير داخل جميع الصفحات =============
          body: NotificationListener<UserScrollNotification>(
            onNotification: (notification) {
              // التأكد إن السكرول رأسي وليس أفقياً بين صفحات الـ PageView
              if (notification.metrics.axis == Axis.vertical) {
                // نمرر الاتجاه للدالة المعدلة في الكنترولر
                controller.onScrollNotification(notification.direction);
                controller.onOrderScroll(notification.metrics.pixels);
              }
              return false;
            },
            child: PageView(
              controller: controller.pageControllers,
              onPageChanged: (i) {
                // إرجاع الـ BottomNavBar للظهور عند التنقل بين الصفحات (اختياري)
                if (!controller.upordown) {
                  controller.onScrollNotification(ScrollDirection.forward);
                }
                controller.onpagechnage(i);
              },
              children: controller.pages,
            ),
          ),
        ),
      ),
    );
  }
}
