import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:hos/controler/admincontroller/admin_controller.dart';
import 'package:hos/controler/usercontroller/notificationcontroller.dart';
import 'package:hos/core/conistant/app_dimensions.dart';
import 'package:hos/core/conistant/imageasset.dart';
import 'package:hos/core/conistant/routs.dart';
import 'package:hos/veiw/wedget/Homepage/buttomAppbar.dart';
import 'package:hos/veiw/wedget/appbarbackicon.dart';
import 'package:hos/veiw/wedget/appshell.dart';

class AdminHome extends StatelessWidget {
  AdminHome({super.key});
  final Adminhome controller = Get.put(Adminhome());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<Adminhome>(
      builder: (controller) => AppShell(
        title: Text(
          "Hello",
          style: const TextStyle(
            fontSize: AppDimensions.fontTitle,
            fontWeight: FontWeight.bold,
          ),
        ),
        pages: controller.pages,
        navItems: [
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
          NavItem(
            label: controller.title[3][0],
            svgAsset: controller.title[3][1],
          ),
        ],
        currentIndex: controller.currentpage,
        onTap: controller.changePage,
        pageController: controller.controller,
        onPageChanged: controller.onpagechanged,
        onScroll: controller.onScrollNotification,
        onOrderScroll: controller.onOrderScroll,
        visible: controller.upordown,
        cartCount: controller.overviewData['total_orders'] ?? 0,
        actionsBuilder: (index) => index == 1 ? [] : [_notificationButton()],
      ),
    );
  }

  Widget _notificationButton() {
    return GetBuilder<Notificationcontroller>(
      builder: (nc) {
        final hasUnread = nc.notificationcount.value;
        return Homescrenaction(
          herotag: "notification",
          onPressed: () => Get.toNamed(Approute.notificationPage),
          child: Badge(
            isLabelVisible: hasUnread > 0,
            alignment: const Alignment(0.1, 0.90),
            label: Text(
              hasUnread.toString(),
              style: const TextStyle(color: Colors.white, fontSize: 12),
            ),
            smallSize: 9,
            backgroundColor: Colors.redAccent,
            child: SvgPicture.asset(
              Imageasset.notification,
              color: Colors.black,
            ),
          ),
        );
      },
    );
  }
}
