import 'package:get/get.dart';
import 'package:hos/core/class/crud.dart';
import 'package:hos/core/class/searchclass.dart';
import 'package:hos/core/functions/handlingdata.dart';
// import 'package:hos/core/serveces/myservisec.dart';
import 'package:hos/data/datasource/userdata/fav_data.dart';
import 'package:hos/data/model/myfavorite.dart';

class Myfavcontroler extends SearchMix {
  @override
  // ignore: overridden_fields
  late Statusrequest statusrequest;
  List<favoriteModel> data = [];
  RxInt get datacount => data.length.obs;

  addfavdata favdata = addfavdata(Get.find());
  // Myservisec myservisec = Get.find();

  int get id => myservisec.sharedPreferences.getInt("id")!;

  Future<void> getfav() async {
    data.clear();
    statusrequest = Statusrequest.loading;

    var response = await favdata.veiwfav();

    statusrequest = handling(response);
    if (statusrequest == Statusrequest.success) {
      if (response['status'] == true) {
        List responsedata = response['data'];
        data.addAll(responsedata.map((e) => favoriteModel.fromJson(e)));
        data.isEmpty ? statusrequest = Statusrequest.failure : null;
      } else {
        statusrequest = Statusrequest.failure;
      }
    }

    update();
  }

  //الحذف من صفحه المفضله
  void deletefromfavpage(int itemid) {
    favdata.favoritemanger( itemid);

    data.removeWhere((e) => e.item!.id == itemid);
    if (data.isEmpty) {
      statusrequest = Statusrequest.failure;
      update();
    }
  }

  @override
  void onInit() {
    getfav();
    super.onInit();
  }
}
