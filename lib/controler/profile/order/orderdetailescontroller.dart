import 'package:get/get.dart';
import 'package:hos/data/model/ordersmodel.dart';



class Orderdetailescontroller extends GetxController {
  OrderModel? order;

  @override
  void onInit() {
    // تأكد إن Get.arguments مش null
    final args = Get.arguments;
    if (args != null && args["order"] != null) {
      order = args["order"];
      print("✅ تم استلام الطلب: ${order?.ordersId}");
    } else {
      print("⚠️ لم يتم استلام أي بيانات من الصفحة السابقة");
    }
    super.onInit();
  }
}

