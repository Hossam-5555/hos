import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hos/controler/usercontroller/notificationcontroller.dart';
import 'package:hos/core/class/crud.dart';
import 'package:hos/core/class/handlingdataview.dart';
import 'package:hos/veiw/wedget/appbarbackicon.dart';
import 'package:skeletonizer/skeletonizer.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(Notificationcontroller());

    final double screenWidth = Get.width;
    final double screenHeight = Get.height;

    return Scaffold(
      /// ✅ APP BAR (مهم جدًا)
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: GetBuilder<Notificationcontroller>(
          builder: (controller) {
            return  Appbarbackicon(selected: controller.selectionMode,
                    title: controller.selectionMode
                        ? "${controller.selectedIds.length} محدد"
                        : "Messages",
                    herotag: "",
                    iconButton: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: controller.deleteSelected,
                    ),
                    onPressed:controller.closeselected ,
                  );
          },
        ),
      ),

      /// ✅ BODY
      body: GetBuilder<Notificationcontroller>(
        builder: (controller) {
          return Handlingdataview(
            statusrequest: controller.statusrequest,
            widget: Skeletonizer(
              enabled: controller.statusrequest == Statusrequest.loading,
              child: ListView.builder(
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.04,
                  vertical: screenHeight * 0.02,
                ),

                /// ✅ itemCount الصح
                itemCount: controller.statusrequest == Statusrequest.loading
                    ? 8
                    : controller.notificationlist.length,

                itemBuilder: (context, index) {
                  /// ===== Skeleton فقط =====
                  if (controller.statusrequest == Statusrequest.loading) {
                    return const Card(
                      child: ListTile(title: Text("يتم تحميل البيانات "), subtitle: Text("انتظر قلايلا ")),
                    );
                  }

                  /// ===== بيانات حقيقية =====
                  final item = controller.notificationlist[index];

                  final id = item["notification_id"].toString();
                  final title = item['notification_title'] ?? '';
                  final body = item['notification_body'] ?? '';

                  return GestureDetector(
                    onLongPress: () => controller.onLongPress(id),
                    onTap: () => controller.onTap(id),
                    child: Card(
                      color: controller.isSelected(id)
                          ? Colors.blue.withAlpha(38) // 0.15 * 255 = 38
                          : Colors.white,
                      elevation: 3,
                      margin: EdgeInsets.symmetric(
                        vertical: screenHeight * 0.01,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        leading: const Icon(
                          Icons.notifications,
                          color: Colors.blue,
                        ),
                        title: Text(
                          title,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: screenWidth * 0.045,
                          ),
                        ),
                        subtitle: Text(
                          body,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        trailing: controller.selectionMode
                            ? Checkbox(
                                value: controller.isSelected(id),
                                onChanged: (_) => controller.onTap(id),
                              )
                            : Text(
                                '',
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
}
