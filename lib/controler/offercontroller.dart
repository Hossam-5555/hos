import 'package:get/get.dart';
import 'package:hos/core/class/crud.dart';
import 'package:hos/core/functions/handlingdata.dart';
import 'package:hos/core/serveces/myservisec.dart';
import 'package:hos/data/datasource/remote/offerdata.dart';
import 'package:hos/data/model/itemsmodel.dart';

class Offercontroller extends GetxController {
  Statusrequest statusrequest = Statusrequest.none;
  Myservisec myservisec = Get.put(Myservisec());
  Offerdata notificationdata = Get.put(Offerdata(Get.find()));
  List offerList = [];
  getoffer() async {
    offerList.clear();
    statusrequest = Statusrequest.loading;
    update();
    var response = await notificationdata.getdata();
    statusrequest = handling(response);
    if (Statusrequest.success == statusrequest) {
      if (response['status'] == 'success') {
        
        List data = response["data"];
        print(data);
        offerList.addAll(data.map((e) => Itemsmodel.fromJson(e)).toList());
      } else {
        statusrequest = Statusrequest.failure;
      }
    }
    update();
  }

  @override
  void onInit() {
    getoffer();
    super.onInit();
  }
}
