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

  @override
  void onInit() {
    GetNotifier();
    super.onInit();
  }
}
