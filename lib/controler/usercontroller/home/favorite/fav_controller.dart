import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:hos/core/class/crud.dart';
import 'package:hos/core/functions/handlingdata.dart';
import 'package:hos/core/serveces/myservisec.dart';
import 'package:hos/data/datasource/userdata/fav_data.dart';

class FavController extends GetxController {
  Map isfavorite = {}; // {itemid: "1"}
  late Statusrequest statusrequest;

  // لتغيير حالة الأيقونة محليًا
  chasngfav(id, val) {
    isfavorite[id] = val;
    update();
  }

  addfavdata favdata = addfavdata(Get.find());
  Myservisec myservisec = Get.find();

  // 🔹 إضافة إلى المفضلة
  Future<void> addfav(String itemid) async {
    statusrequest = Statusrequest.loading;
    update();
    var response = await favdata.addfavorite(
      myservisec.sharedPreferences.getString("id")!,
      itemid,
    );
    statusrequest = handling(response);
    if (Statusrequest.success == statusrequest) {
      if (response["status"] == "success") {
        Get.rawSnackbar(duration: Duration(milliseconds:850),
          margin: EdgeInsets.all(16),
          borderRadius: 20,
          title: "إشعار",
          messageText: const Text("تمت إضافة العنصر إلى المفضلة"),
        );
      } else {
        statusrequest = Statusrequest.failure;
      }
    }
  }

  // 🔹 إزالة من المفضلة
  removefromfav(String itemid) async {
    statusrequest = Statusrequest.loading;
    var response = await favdata.removefav(
      myservisec.sharedPreferences.getString("id")!,
      itemid,
    );
    statusrequest = handling(response);
    if (Statusrequest.success == statusrequest) {
      if (response['status'] == 'success') {
        Get.rawSnackbar(
          padding: EdgeInsets.all(10),
          borderRadius: 20,
          title: "إشعار",
          messageText: const Text("تمت إزالة العنصر من المفضلة"),
        );
      } else {
        statusrequest = Statusrequest.failure;
      }
    }
  }

 


}
