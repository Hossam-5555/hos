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
  Notificationdata notificationdata = Get.put(Notificationdata(Get.find()));

  List<NotificationModel> notificationlist = [];
  RxInt get notificationcount => notificationlist.length.obs;

  /// ====== MULTI SELECT ======
  bool selectionMode = false;
  List<String> selectedIds = [];

  /// جلب الإشعارات
  Future<void> getnotifier() async {
    notificationlist.clear();
    statusrequest = Statusrequest.loading;
    update();

    var response = await notificationdata.GetNotification(
      myservisec.sharedPreferences.getString("id")!,
    );

    statusrequest = handling(response);

    if (Statusrequest.success == statusrequest) {
      if (response['status'] == 'success') {
        notificationlist = response["data"];
        notificationlist.map((e)=>NotificationModel.fromJson(e as Map<String, dynamic>));
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

    notificationlist.removeWhere(
      (item) => selectedIds.contains(item.notificationId.toString()),
    );

    selectedIds.clear();
    selectionMode = false;
    if (notificationlist.isEmpty) {
      statusrequest = Statusrequest.failure;
    }
    update();
  }

  void closeselected() {
    selectionMode = false;
    selectedIds.clear();
    update();
  }

  @override
  void onInit() {
    getnotifier();
    super.onInit();
  }
}
