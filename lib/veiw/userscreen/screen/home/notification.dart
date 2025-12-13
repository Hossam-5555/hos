import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hos/controler/usercontroller/notificationcontroller.dart';
import 'package:hos/core/class/crud.dart';
import 'package:hos/core/class/handlingdataview.dart';
import 'package:intl/intl.dart';
import 'package:skeletonizer/skeletonizer.dart'; // تأكد من إضافة skeletonizer في pubspec.yaml

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(Notificationcontroller());
    
    // متغيرات الأبعاد للاستجابة للشاشات المختلفة
    final double screenWidth = Get.width;
    final double screenHeight = Get.height;

    return Scaffold(
      body: GetBuilder<Notificationcontroller>(
        builder: (controller) {
          return Handlingdataview(
            statusrequest: controller.statusrequest,
            widget: Skeletonizer(
              // 1. تفعيل الاسكيلتون فقط عند حالة التحميل
              enabled: controller.statusrequest == Statusrequest.loading,
              
              // 2. استخدام حاوية لضبط الأبعاد
              child: ListView.builder(
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.04, // 4% من عرض الشاشة
                  vertical: screenHeight * 0.02,  // 2% من ارتفاع الشاشة
                ),
                
                // 3. خدعة العدد: إذا كان يحمل، اعرض 8 عناصر وهمية، وإلا اعرض العدد الحقيقي
                itemCount: controller.statusrequest == Statusrequest.loading
                    ? 8
                    : controller.NotificationList.length,
                    
                itemBuilder: (context, index) {
                  // متغيرات لاستقبال البيانات (ستكون وهمية أثناء التحميل)
                  String title;
                  String body;
                  String date;

                  if (controller.statusrequest == Statusrequest.loading) {
                    // 4. بيانات وهمية للهيكل العظمي (يجب أن تكون نصوصاً طويلة قليلاً لتوضيح الشكل)
                    title = "جاري تحميل عنوان الإشعار...";
                    body = "هذا نص تجريبي طويل ليملاء مكان محتوى الإشعار أثناء التحميل";
                    date = "2024/01/01";
                  } else {
                    // 5. البيانات الحقيقية (آمنة الآن لأننا لسنا في حالة Loading)
                    final item = controller.NotificationList[index];
                    title = item['notification_title'] ?? 'بدون عنوان';
                    body = item['notification_body'] ?? 'لا يوجد محتوى';
                    date = _formatDate(item['notification_datetime']);
                  }

                  return Card(
                    // تعديل اللون ليكون ظاهراً (الشفافية العالية قد تخفي تأثير Skeleton)
                    color: const Color.fromARGB(240, 255, 255, 255), 
                    elevation: 3,
                    margin: EdgeInsets.symmetric(vertical: screenHeight * 0.01),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: screenHeight * 0.01),
                      child: ListTile(
                        leading: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.blue.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.notifications,
                            color: Colors.blue,
                            size: 28,
                          ),
                        ),
                        title: Text(
                          title,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: screenWidth * 0.045, // حجم خط متجاوب
                          ),
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: Text(
                            body,
                            style: TextStyle(
                              color: const Color.fromARGB(255, 100, 100, 100),
                              fontSize: screenWidth * 0.035,
                            ),
                            maxLines: 2, // لضمان تناسق الشكل
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        trailing: Text(
                          date,
                          style: TextStyle(
                            fontSize: screenWidth * 0.03,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
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