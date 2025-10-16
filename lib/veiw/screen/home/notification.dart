import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hos/controler/notificationcontroller.dart';
import 'package:hos/core/class/handlingdataview.dart';

class Notification extends StatelessWidget {
  const Notification({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(Notificationcontroller());
    return GetBuilder<Notificationcontroller>(
      builder: (controller) {
        return Handlingdataview(
          statusrequest: controller.statusrequest,
          widget: ListView.builder(itemCount: controller.NotificationList.length,
            itemBuilder: (context, i) => 
              Card(
                child: ListTile(
                  title: Text(
                    "${controller.NotificationList[i]['notification_title']}",
                  ),
                ),
              ),
            
          ),
        );
      },
    );
  }
}
