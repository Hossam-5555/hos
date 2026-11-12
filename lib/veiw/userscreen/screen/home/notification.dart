import 'package:animate_do/animate_do.dart'; // 1. إضافة المكتبة
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hos/controler/usercontroller/notificationcontroller.dart';
import 'package:hos/data/services/crud.dart';
import 'package:hos/core/class/handlingdataview.dart';
import 'package:hos/veiw/wedget/notification_card.dart';
import 'package:hos/veiw/wedget/appbarbackicon.dart';

class NotificationPage extends StatelessWidget {
  NotificationPage({super.key});
  final controller = Get.put(Notificationcontroller());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<Notificationcontroller>(
      builder: (s) {
        bool isLoading = controller.statusrequest == Statusrequest.loading;

        return Scaffold(
          appBar: Appbarbackicon(
            selected: controller.selectionMode,
            title: controller.selectionMode
                ? "${controller.selectedIds.length} ${"Selected".tr}"
                : "Notifications".tr,
            herotag: "notification",
            iconButton: controller.selectionMode
                ? const Icon(Icons.delete_sweep_rounded, color: Colors.redAccent)
                : null,
            ontap: () {
              controller.deleteSelected(context);
            },
            onPressed: () {
              controller.closeselected();
            },
          ),
          body: HandlingDataView(
            emptyStyle: EmptyStateStyle.style2,
            statusrequest: controller.statusrequest,
            mediaType: HandlingMediaType.svgImage,
            mode: HandlingMode.fullScreen,
            widget: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              itemCount: isLoading ? 6 : controller.notificationlist.length,
              itemBuilder: (context, index) {
                String title = "";
                String body = "";
                int id = 0;
                String time = "";
                bool isRead = false;

                // تجهيز البيانات بحماية أثناء التحميل
                if (isLoading) {
                  title = "Loading Notification Title";
                  body = "This is a dummy description for skeleton loading effect.";
                  time = "2024-01-01 10:00 AM";
                  isRead = true;
                } else {
                  final item = controller.notificationlist[index];
                  id = item.id!;
                  title = item.title ?? '';
                  body = item.body ?? '';
                  time = item.createdAt ?? '';
                  isRead = item.isActive ?? false;
                }

                bool isSelected = controller.isSelected(id);
                controller.iconstype(title);

                // 2. تغليف الكارت بالأنيميشن المتسلسل
                return FadeInUp(
                  // لضمان عمل الأنيميشن مرة واحدة عند فتح الصفحة ومش مع كل update في Controller
                  key: ValueKey(id != 0 ? id : index), 
                  
                  // حساب وقت التأخير بناءً على ترتيب الإشعار
                  // اخترنا 60 ملي ثانية لسرعة انسيابية ومريحة للعين
                  delay: Duration(milliseconds: isLoading ? 0 : index * 30), 
                  duration: const Duration(milliseconds: 400),
                  
                  child: NotificationCard(
                    title: title,
                    body: body,
                    colors: controller.colors,
                    iconData: controller.iconData,
                    isread: isRead,
                    time: time,
                    isSelected: isSelected,
                    isLoading: isLoading,
                    selectionMode: controller.selectionMode,
                    onLongPress: () => controller.onLongPress(id),
                    onTap: () => controller.onTap(id),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}