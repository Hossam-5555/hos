import 'package:get/get.dart';
import 'package:hos/core/class/crud.dart';
import 'package:hos/core/functions/handlingdata.dart';
import 'package:hos/core/functions/snackbar.dart';
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
  Future<void> favmanget(int itemid) async {
    statusrequest = Statusrequest.loading;
    update();
    int id = myservisec.sharedPreferences.getInt("id")!;

    var response = await favdata.favoritemanger(id, itemid);
    statusrequest = handling(response);
    if (Statusrequest.success == statusrequest) {
      if (response["status"] == "success") {
        showSnackBar(Get.context!, "Item added to favorite");
      } else {
        statusrequest = Statusrequest.failure;
      }
    }
  }
}
