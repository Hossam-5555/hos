import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hos/core/class/crud.dart';
import 'package:hos/core/functions/handlingdata.dart';
import 'package:hos/core/functions/snackbar.dart';
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
  Notificationdata notificationdata = Notificationdata(Get.find());
  int? get userid => myservisec.sharedPreferences.getInt("id");

  List<MessageModel> notificationlist = [];
  RxInt notificationcount = 0.obs;

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
  void onTap(int id) async {
    // لو مش في وضع التحديد، اضغط ضغطة عادية (مثلاً تفتح الإشعار أو تخليه مقروء)
    if (!selectionMode) {
      final index = notificationlist.indexWhere((e) => e.id == id);
      if (index != -1) {
        notificationlist[index].isActive = true;
        update();
      }
       await notificationdata.markasread(id);

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
    selectionMode = false;

    showSnackBar(
      context,
      "Deleted Successfully",
      Icon(Icons.delete),
      action: SnackBarAction(
        label: "UNDO",
        textColor: Colors.orangeAccent,
        onPressed: () {
          isUndo = true;
          notificationlist.insertAll(0, removedItems);
          update();
        },
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

    if (notificationlist.isEmpty) {
      statusrequest = Statusrequest.failure;
    }

    update();
  }

  Future<void> getnotifier() async {
    statusrequest = Statusrequest.loading;
    update();
    var response = await notificationdata.getNotificationsData();

    statusrequest = handling(response);
    if (Statusrequest.success == statusrequest && response['status'] == true) {
      notificationlist.clear();
      List data = response["data"]["messages"];
      notificationlist.addAll((data).map((e) => MessageModel.fromJson(e)));
      // notificationcount.value = response["data"]["total_inactive_count"];
      notificationcount.value == notificationlist.length;

      if (notificationlist.isEmpty) {
        statusrequest = Statusrequest.nodata;
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

    var response = await notificationdata.getnotification();
    statusrequest = handling(response);
    if (Statusrequest.success == statusrequest) {
      if (response['status'] == true && response['data'] != null) {
        List rawData = [];
        if (response['data'] is Map && response['data']['data'] != null) {
          rawData = response['data']['data'];
        } else if (response['data'] is List) {
          rawData = response['data'];
        }

        notificationlist.addAll(rawData.map((e) => MessageModel.fromJson(e)));

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
