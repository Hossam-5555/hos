import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hos/core/class/crud.dart';
import 'package:hos/core/functions/handlingdata.dart';
import 'package:hos/core/serveces/myservisec.dart';
import 'package:hos/data/datasource/userdata/notificationdata.dart';
import 'package:hos/data/model/notificationmodel.dart';

class Notificationcontroller extends GetxController {
  Statusrequest statusrequest = Statusrequest.none;

  String id = "1";
  String title = "عنوان الإشعار";
  String body = "محتوى الإشعار";

  Myservisec myservisec = Get.put(Myservisec());
  String? get usertype => myservisec.sharedPreferences.getString("usertype");
  Notificationdata notificationdata = Get.put(Notificationdata(Get.find()));
  int? get userid => myservisec.sharedPreferences.getInt("id");
  
  List<MassageModel> notificationlist = [];
  int notificationcount = 0;

  /// ====== MULTI SELECT ======
  bool selectionMode = false;
  List<int> selectedIds = [];

  /// ضغط مطوّل
  void onLongPress(int id) {
    selectionMode = true;
    if (!selectedIds.contains(id)) {
      selectedIds.add(id);
    }
    update();
  }

  /// ضغط عادي
/// ضغط عادي (تعديل لضمان التحديد وإلغائه)
  void onTap(int id) {
    // لو مش في وضع التحديد، اضغط ضغطة عادية (مثلاً تفتح الإشعار أو تخليه مقروء)
    if (!selectionMode) {
      // هنا ممكن تحط كود فتح الإشعار مستقبلاً
      return; 
    }

    // لو في وضع التحديد، اقلب حالة العنصر (تحديد / إلغاء تحديد)
    if (selectedIds.contains(id)) {
      selectedIds.remove(id);
      if (selectedIds.isEmpty) {
        selectionMode = false;
      }
    } else {
      selectedIds.add(id);
    }
    update(); // تحديث الواجهة فوراً
  }

  bool isSelected(int id) {
    return selectedIds.contains(id);
  }

  void closeselected() {
    selectionMode = false;
    selectedIds.clear();
    update();
  }

  /// حذف المحدد
  Future<void> deleteSelected(BuildContext context) async {
    // 🟢 خزّن العناصر المحذوفة
    final removedItems = notificationlist
        .where((item) => selectedIds.contains(item.id))
        .toList();

    // 🟢 احذف من UI مؤقتًا
    notificationlist.removeWhere((item) => selectedIds.contains(item.id));

    update();

    bool isUndo = false;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 4),
        behavior: SnackBarBehavior.floating, // يخليه طاير مش لازق تحت
        margin: const EdgeInsets.all(12),
        backgroundColor: Colors.grey.shade900,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15), // 🔥 حواف دائرية
        ),
        content: const Row(
          children: [
            Icon(Icons.delete_outline, color: Colors.white),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                "Notifications deleted",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
        action: SnackBarAction(
          label: "UNDO",
          textColor: Colors.orangeAccent,
          onPressed: () {
            isUndo = true;
            notificationlist.insertAll(0, removedItems);
            update();
          },
        ),
      ),
    );

    // ⏳ استنى 4 ثواني
    await Future.delayed(const Duration(seconds: 4));

    // 🔴 لو المستخدم ما ضغطش Undo
    if (!isUndo) {
      await notificationdata.removeNotification(selectedIds);
    }

    // تنظيف
    selectedIds.clear();
    selectionMode = false;

    if (notificationlist.isEmpty) {
      statusrequest = Statusrequest.failure;
    }

    update();
  }

  Future<void> getnotifier() async {
    statusrequest = Statusrequest.loading;
    update();

    var response = await notificationdata.getnotification();
    statusrequest = handling(response);

    if (Statusrequest.success == statusrequest && response['status'] == true) {
      notificationlist.clear();
      notificationlist.addAll(
        (response["data"]["messages"] as List).map(
          (e) => MassageModel.fromJson(e),
        ),
      );
      notificationcount = response["data"]["total_inactive_count"];
      if (notificationcount == 0) {
        statusrequest = Statusrequest.failure;
      }
    } else {
      statusrequest = Statusrequest.failure;
    }

    update();
  }

  // 📥 جلب البيانات الحقيقية المتوافقة مع دالة index() بالباك إند
  Future<void> getNotifications() async {
    notificationlist.clear();
    statusrequest = Statusrequest.loading;
    update();

    var response = await notificationdata.getNotificationsData();
    statusrequest = handling(response);

    if (Statusrequest.success == statusrequest) {
      if (response['status'] == true && response['data'] != null) {
        List rawData = [];
        if (response['data'] is Map && response['data']['data'] != null) {
          rawData = response['data']['data'];
        } else if (response['data'] is List) {
          rawData = response['data'];
        }

        notificationlist.addAll(rawData.map((e) => MassageModel.fromJson(e)));

        if (notificationlist.isEmpty) {
          statusrequest = Statusrequest.nodata;
        }
      } else {
        statusrequest = Statusrequest.failure;
      }
    }
    update();
  }

  @override
  void onInit() {
    if (usertype == "admin") {
      getNotifications();
    } else {
      getnotifier();
    }
    super.onInit();
  }
}