import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:hos/controler/usercontroller/checkout&cart/cart_controller.dart';
import 'package:hos/controler/usercontroller/home/homescreen_controller.dart';
import 'package:hos/controler/usercontroller/notificationcontroller.dart';
import 'package:hos/core/conistant/imageasset.dart';
import 'package:hos/core/conistant/routs.dart';
import 'package:hos/veiw/wedget/Homepage/buttomAppbar.dart';
import 'package:hos/veiw/wedget/appbarbackicon.dart';
import 'package:hos/veiw/wedget/appshell.dart';

class Homescreen extends StatelessWidget {
  Homescreen({super.key});
  final controller = Get.put(Homescreencontroller());
  final cart = Get.put(CartController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<Homescreencontroller>(
      builder: (controller) => AppShell(
        title: Text.rich(
          TextSpan(
            children: [
              const TextSpan(text: " hi!,👋 "),
              TextSpan(text: controller.userName),
            ],
          ),
        ),
        pages: controller.pages,
        navItems: [
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
        pageController: controller.pageControllers,
        onPageChanged: controller.onpagechnage,
        onScroll: controller.onScrollNotification,
        onOrderScroll: controller.onOrderScroll,
        visible: controller.upordown,
        cartCount: cart.countitem.value,
        appBarColor: controller.Currentpage == 2 && cart.data.isNotEmpty
            ? Theme.of(context).cardColor
            : null,
        actionsBuilder: (index) => index != 1 ? [_notificationButton()] : [],
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
