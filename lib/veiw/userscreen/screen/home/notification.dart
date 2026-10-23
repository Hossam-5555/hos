import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hos/controler/usercontroller/notificationcontroller.dart';
import 'package:hos/core/class/crud.dart';
import 'package:hos/core/class/handlingdataview.dart';
import 'package:hos/veiw/wedget/notification_card.dart';
import 'package:hos/veiw/wedget/appbarbackicon.dart';

class NotificationPage extends StatelessWidget {
  NotificationPage({super.key});
  final controller = Get.put(Notificationcontroller());

  @override
  Widget build(BuildContext context) {
    // نقوم بإنشاء الكنترولر أو إيجاده هنا لمرة واحدة لضمان استخدام نفس النسخة في الصفحة بأكملها

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
                ? Icon(Icons.delete_sweep_rounded, color: Colors.redAccent)
                : null,
            ontap: () {
              controller.deleteSelected(context);
            },
          
            // عند الضغط على X سيقوم بالاستدعاء وتحديث الواجهة بالكامل فوراً
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

                // تجهيز البيانات
                if (isLoading) {
                  title = "Loading Notification Title";
                  body =
                      "This is a dummy description for skeleton loading effect.";
                  time = "2024-01-01 10:00 AM";
                } else {
                  final item = controller.notificationlist[index];
                  id = item.id!;
                  title = item.title ?? '';
                  body = item.body ?? '';
                  time = item.createdAt ?? '';
                }

                bool isSelected = controller.isSelected(id);
                controller.iconstype(title);
                return NotificationCard(
                  title: title,
                  body: body,
                  colors: controller.colors,
                  iconData: controller.iconData,
                  isread: controller.notificationlist[index].isActive!,
                  time: time,
                  isSelected: isSelected,
                  isLoading: isLoading,
                  selectionMode: controller.selectionMode,
                  onLongPress: () => controller.onLongPress(id),
                  onTap: () => controller.onTap(id),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
