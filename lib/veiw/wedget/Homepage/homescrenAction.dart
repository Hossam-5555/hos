import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:hos/controler/usercontroller/notificationcontroller.dart';
import 'package:hos/core/conistant/imageasset.dart';
import 'package:hos/veiw/userscreen/screen/home/notification.dart';

// ignore: must_be_immutable
class Homescrenaction extends StatelessWidget {
  const Homescrenaction({super.key});
  @override
  Widget build(BuildContext context) {
    var notifiacation = Get.find<Notificationcontroller>();

    return Badge(backgroundColor: const Color.fromARGB(255, 155, 16, 23),
      label: Obx(
        ()=> Text(
          "${notifiacation.notificationcount.value}", // استبدل هذا بعدد العناصر في السلة
          style: TextStyle(color: Colors.white, fontSize: 12),
        ),
      ),
      offset: Offset(-4, 0),
      child: Hero(
        tag: "notification", // تأكد أن هذا الـ tag فريد
        child: Stack(
          children: [
            Container(
              height: 52,
              width: 52,
              margin: EdgeInsets.only(right: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    blurStyle: BlurStyle.normal,
                    blurRadius: 5,
                    color: Colors.black.withAlpha(60),
                    offset: Offset(0, 0.2),
                  ),
                ],
                shape: BoxShape.circle,
              ),
              child: MaterialButton(
                shape: CircleBorder(),
                child: SvgPicture.asset(Imageasset.notification, height: 25, width: 25),
                onPressed: () {
                  Get.to(
                    () => NotificationPage(),
                    transition: Transition.fadeIn,
                    duration: Duration(milliseconds: 400),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
