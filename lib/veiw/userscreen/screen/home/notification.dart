import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hos/controler/usercontroller/notificationcontroller.dart';
import 'package:hos/core/class/handlingdataview.dart';
import 'package:intl/intl.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(Notificationcontroller());
    return Scaffold(
      body: GetBuilder<Notificationcontroller>(
        builder: (controller) {
          return Handlingdataview(
            statusrequest: controller.statusrequest,
            widget: ListView.builder(
              padding: const EdgeInsets.all(10),
              itemCount: controller.NotificationList.length,
              itemBuilder: (context, i) {
                final item = controller.NotificationList[i];
                return Card(color: Color.fromARGB(120, 255, 255, 255),
                  elevation: 3,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    leading: const Icon(
                      Icons.notifications,
                      color: Colors.blue,
                    ),
                    title: Text(
                      item['notification_title'] ?? 'بدون عنوان',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    subtitle: Text(
                      item['notification_body'] ?? 'لا يوجد محتوى',
                      style: TextStyle(color:Color.fromARGB(255, 120, 150, 255)),
                    ),
                    trailing: Text(
                      _formatDate(item['notification_datetime']),
                      style: const TextStyle(fontSize: 12, color: Colors.white70),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  String _formatDate(String? date) {
    if (date == null) return '';
    try {
      final parsed = DateTime.parse(date);
      return DateFormat('yyyy/MM/dd').format(parsed);
    } catch (e) {
      return '';
    }
  }
}
