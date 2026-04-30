import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hos/controler/usercontroller/notificationcontroller.dart';
import 'package:hos/core/class/crud.dart';
import 'package:hos/core/class/handlingdataview.dart';
import 'package:hos/veiw/wedget/appbarbackicon.dart';
import 'package:jiffy/jiffy.dart';
import 'package:skeletonizer/skeletonizer.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: GetBuilder<Notificationcontroller>(
          builder: (controller) {
            return Appbarbackicon(
              selected: controller.selectionMode,
              title: controller.selectionMode
                  ? "${controller.selectedIds.length} ${"Selected".tr}"
                  : "Notifications".tr,
              herotag: "notification",
              iconButton: controller.selectionMode
                  ? IconButton(
                      icon: const Icon(
                        Icons.delete_sweep_rounded,
                        color: Colors.redAccent,
                      ),
                      onPressed: () {
                        controller.deleteSelected(context);
                      },
                    )
                  : null,
              onPressed: controller.closeselected,
            );
          },
        ),
      ),
      body: GetBuilder<Notificationcontroller>(
        builder: (controller) {
          bool isLoading = controller.statusrequest == Statusrequest.loading;

          return Handlingdataview(
            statusrequest: controller.statusrequest,
            widget: Skeletonizer(
              enabled: isLoading,
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                itemCount: isLoading ? 6 : controller.notificationlist.length,
                itemBuilder: (context, index) {
                  String title = "";
                  String body = "";
                  int id = 0;
                  String time = "";

                  if (isLoading) {
                    title = "Loading Notification Title";
                    body =
                        "This is a dummy description for skeleton loading effect.";
                  } else {
                    final item = controller.notificationlist[index];
                    id = item.id!;
                    title = item.title ?? '';
                    body = item.body ?? '';
                    time = Jiffy.parse(
                      item.createdAt ?? DateTime.now().toString(),
                    ).fromNow();
                  }

                  bool isSelected = !isLoading && controller.isSelected(id);

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: InkWell(
                      onLongPress: isLoading
                          ? null
                          : () => controller.onLongPress(id),
                      onTap: isLoading ? null : () => controller.onTap(id),
                      borderRadius: BorderRadius.circular(20),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? Colors.blue.withOpacity(0.08)
                              : Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isSelected
                                ? Colors.blue.withOpacity(0.5)
                                : Colors.transparent,
                            width: 1.5,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.03),
                              blurRadius: 15,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // --- Icon Section ---
                            Container(
                              height: 50,
                              width: 50,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: isSelected
                                      ? [Colors.blue, Colors.blueAccent]
                                      : [
                                          Colors.blue.withOpacity(0.1),
                                          Colors.blue.withOpacity(0.05),
                                        ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.notifications_none_rounded,
                                color: isSelected ? Colors.white : Colors.blue,
                                size: 26,
                              ),
                            ),
                            const SizedBox(width: 15),

                            // --- Text Content ---
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          title,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15,
                                            color: Colors.blueGrey[900],
                                          ),
                                        ),
                                      ),
                                      if (!isLoading &&
                                          !controller.selectionMode)
                                        Text(
                                          time,
                                          style: TextStyle(
                                            fontSize: 10,
                                            color: Colors.grey[500],
                                          ),
                                        ),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    body,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 13,
                                      height: 1.4,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // --- Selection Mode Checkbox ---
                            if (controller.selectionMode && !isLoading)
                              Padding(
                                padding: const EdgeInsets.only(left: 8),
                                child: Checkbox(
                                  value: isSelected,
                                  activeColor: Colors.blue,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  onChanged: (val) => controller.onTap(id),
                                ),
                              ),
                          ],
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
