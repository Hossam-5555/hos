import 'package:get/get.dart';
import 'package:hos/core/class/crud.dart';
import 'package:hos/core/class/searchclass.dart';
import 'package:hos/core/functions/handlingdata.dart';
import 'package:hos/core/serveces/myservisec.dart';
import 'package:hos/data/datasource/remote/userdata/fav_data.dart';
import 'package:hos/data/model/myfavorite.dart';

class Myfavcontroler extends SearchMix {
  late Statusrequest statusrequest;
  List<myfavoritemodel> data = [];

  addfavdata favdata = addfavdata(Get.find());
  Myservisec myservisec = Get.find();

  getfav() async {
    data.clear();
    statusrequest = Statusrequest.loading;

    var response = await favdata.veiwfav(
      myservisec.sharedPreferences.getString("id")!,
    );

    statusrequest = handling(response);
    if (statusrequest == Statusrequest.success) {
      if (response['status'] == 'success') {
        List responsedata = response['data'];
        data.addAll(responsedata.map((e) => myfavoritemodel.fromJson(e)));
      } else {
        statusrequest = Statusrequest.failure;
      }
    }

    update();
  }

  //الحذف من صفحه المفضله
  deletefromfavpage(String favoriteid) {
    favdata.deletefromfavorite(favoriteid);

    data.removeWhere((e) => e.favId == favoriteid);

    update();
  }

  @override
  void onInit() {
    getfav();
    super.onInit();
  }
}
