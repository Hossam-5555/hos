import 'package:get/get.dart';
import 'package:hos/core/class/crud.dart';
import 'package:hos/core/functions/handlingdata.dart';
import 'package:hos/core/serveces/myservisec.dart';
import 'package:hos/data/datasource/userdata/notificationdata.dart';

class Notificationcontroller extends GetxController {
  Statusrequest statusrequest = Statusrequest.none;

  Myservisec myservisec = Get.put(Myservisec());
  Notificationdata notificationdata = Get.put(Notificationdata(Get.find()));

  List NotificationList = [];

  /// ====== MULTI SELECT ======
  bool selectionMode = false;
  List<String> selectedIds = [];

  /// جلب الإشعارات
  GetNotifier() async {
    NotificationList.clear();
    statusrequest = Statusrequest.loading;
    update();

    var response = await notificationdata.GetNotification(
      myservisec.sharedPreferences.getString("id")!,
    );

    statusrequest = handling(response);

    if (Statusrequest.success == statusrequest) {
      if (response['status'] == 'success') {
        NotificationList = response["data"];
      } else {
        statusrequest = Statusrequest.failure;
      }
    }
    update();
  }

  /// ضغط مطوّل
  void onLongPress(String id) {
    selectionMode = true;
    if (!selectedIds.contains(id)) {
      selectedIds.add(id);
    }
    update();
  }

  /// ضغط عادي
  void onTap(String id) {
    if (!selectionMode) return;

    if (selectedIds.contains(id)) {
      selectedIds.remove(id);
      if (selectedIds.isEmpty) {
        selectionMode = false;
      }
    } else {
      selectedIds.add(id);
    }
    update();
  }

  bool isSelected(String id) {
    return selectedIds.contains(id);
  }

  /// حذف المحدد
  Future<void> deleteSelected() async {
    await notificationdata.removeNotification(selectedIds);

    NotificationList.removeWhere(
      (item) => selectedIds.contains(item["notification_id"].toString()),
    );

    selectedIds.clear();
    selectionMode = false;
    if(NotificationList.isEmpty){
      statusrequest = Statusrequest.failure;
    }
    update();
  }

  closeselected() {
    selectionMode = false;
    selectedIds.clear();
    update();
  }

  @override
  void onInit() {
    GetNotifier();
    super.onInit();
  }
}
