import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:hos/controler/usercontroller/notificationcontroller.dart';
import 'package:hos/core/conistant/imageasset.dart';
import 'package:hos/veiw/userscreen/screen/home/notification.dart';

class Homescrenaction extends StatelessWidget {
  const Homescrenaction({super.key});

  @override
  Widget build(BuildContext context) {
    var notifiacation = Get.find<Notificationcontroller>();

    return Hero(
      tag: "notification",
      child: Container(
        height: 52,
        width: 52,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              blurRadius: 4,
              color: const Color.fromARGB(255, 92, 92, 92).withAlpha(60),
              offset: const Offset(0, 2),
            ),
          ],
          shape: BoxShape.circle,
        ),
        child: MaterialButton(
          shape: const CircleBorder(),
          child: GetBuilder<Notificationcontroller>(
            builder: (controller) {
              return Badge(
                alignment: Alignment.center,
                // offset: const Offset(0,-5),
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
          onPressed: () {
            Get.to(
              () => NotificationPage(),
              transition: Transition.fadeIn,
              duration: const Duration(milliseconds: 400),
            );
          },
        ),
      ),
    );
  }
}