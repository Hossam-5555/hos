import 'package:get/get.dart';
import 'package:hos/core/class/crud.dart';
import 'package:hos/core/functions/handlingdata.dart';
import 'package:hos/core/serveces/myservisec.dart';
import 'package:hos/data/datasource/userdata/offerdata.dart';
import 'package:hos/data/model/itemsmodel.dart';

class Offercontroller extends GetxController {
  Statusrequest statusrequest = Statusrequest.none;
  Myservisec myservisec = Get.put(Myservisec());
  Offerdata notificationdata = Get.put(Offerdata(Get.find()));
  List offerList = [];
  Future<void> getoffer() async {
    offerList.clear();
    statusrequest = Statusrequest.loading;
    update();
    var response = await notificationdata.getdata();
    statusrequest = handling(response);
    if (Statusrequest.success == statusrequest) {
      if (response['status'] == true) {
        List data = response["data"];
        offerList.addAll(data.map((e) => ItemsModel.fromJson(e)).toList());
        if (offerList.isEmpty) {
          statusrequest = Statusrequest.nodata;
        }
      } else {
        statusrequest = Statusrequest.failure;
      }
    }
    update();
  }

  List<ItemsModel> skeletonData = List.generate(
    6,
    (index) => ItemsModel(
      id: 0,
      itemsName: "اسم المنتج يظهر هنا", // نص بطول متوسط
      itemsPrice: 1000,
      priceAfterDiscount: 800,
      itemsImage: "", // اتركها فارغة، السكيليتون سيرسم مربعاً مكانها
      itemsDiscount: 10,
      isFavorite: false,
    ),
  );
  @override
  void onInit() {
    getoffer();
    super.onInit();
  }
}
