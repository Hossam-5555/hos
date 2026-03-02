import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hos/controler/usercontroller/notificationcontroller.dart';
import 'package:hos/core/class/crud.dart';
import 'package:hos/core/class/handlingdataview.dart';
import 'package:hos/veiw/wedget/appbarbackicon.dart';
import 'package:skeletonizer/skeletonizer.dart';

class NotificationPage extends StatelessWidget {
   NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {

    final double screenWidth = Get.width;
    final double screenHeight = Get.height;

    return Scaffold(
      /// ✅ 1. AppBar متفاعل مع التحديد
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: GetBuilder<Notificationcontroller>(
          builder: (controller) {
            return Appbarbackicon(
              selected: controller.selectionMode,
              title: controller.selectionMode
                  ? "${controller.selectedIds.length} محدد"
                  : "Messages",
              herotag: "notification",
              iconButton: IconButton(
                icon: const Icon(Icons.delete),
                onPressed: controller.deleteSelected,
              ),
              onPressed: controller.closeselected,
            );
          },
        ),
      ),

      /// ✅ 2. الجسم (Body)
      body: GetBuilder<Notificationcontroller>(
        builder: (controller) {
          bool isLoading = controller.statusrequest == Statusrequest.loading;

          return Handlingdataview(
            statusrequest: controller.statusrequest,
            widget: Skeletonizer(
              enabled: isLoading,
              child: ListView.builder(
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.04,
                  vertical: screenHeight * 0.01,
                ),
                // إذا تحميل نعرض 6 عناصر وهمية، وإلا نعرض طول القائمة الحقيقي
                itemCount: isLoading ? 6 : controller.notificationlist.length,
                itemBuilder: (context, index) {
                  // -- متغيرات العرض --
                  String title;
                  String body;
                  String id = "";

                  if (isLoading) {
                    // بيانات وهمية للـ Skeleton فقط
                    title = "عنوان الإشعار التجريبي هنا";
                    body =
                        "هذا النص هو مجرد نص تجريبي ليظهر شكل التحميل بشكل جميل";
                  } else {
                    // البيانات الحقيقية
                    final item = controller.notificationlist[index];
                    id = item.notificationId.toString();
                    title = item.notificationTitle ?? 'بدون عنوان';
                    body = item.notificationBody?? 'بدون محتوى';
                  }

                  return GestureDetector(
                    // تعطيل الضغط أثناء التحميل
                    onLongPress: isLoading
                        ? null
                        : () => controller.onLongPress(id),
                    onTap: isLoading ? null : () => controller.onTap(id),

                    child: Card(
                      // تغيير اللون عند التحديد
                      color: Colors.white,
                      elevation: 2,
                      margin: EdgeInsets.symmetric(
                        vertical: screenHeight * 0.008,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                        side: (!isLoading && controller.isSelected(id))
                            ? const BorderSide(color: Colors.blue, width: 1.5)
                            : BorderSide.none,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.blue.withAlpha(25),
                            child: const Icon(
                              Icons.notifications_active,
                              color: Colors.blue,
                            ),
                          ),
                          title: Text(
                            title,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: screenWidth * 0.04,
                            ),
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 5),
                            child: Text(
                              body,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 13,
                              ),
                            ),
                          ),
                          trailing: isLoading
                              ? null // إخفاء الـ checkbox أثناء التحميل
                              : controller.selectionMode
                              ? Checkbox(
                                  activeColor: Colors.blue,
                                  value: controller.isSelected(id),
                                  onChanged: (val) => controller.onTap(id),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                )
                              : Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    // يمكن وضع الوقت هنا لاحقاً
                                    // Text("2m", style: TextStyle(fontSize: 10, color: Colors.grey)),
                                  ],
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
