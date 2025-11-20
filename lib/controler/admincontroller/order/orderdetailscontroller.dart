import 'package:get/get.dart';
import 'package:hos/core/class/crud.dart';
import 'package:hos/core/functions/handlingdata.dart';
import 'package:hos/data/datasource/userdata/orderdata.dart';
import 'package:hos/data/model/cartmodel.dart';
import 'package:hos/data/model/ordersmodel.dart';
import 'package:hos/veiw/adminscreen/Home/orders/trackingorder.dart';

class adminOrderdetailescontroller extends GetxController {
  OrderModel? order;

  Orderdata orderdata = Get.put(Orderdata(Get.find()));
  Statusrequest statusrequest = Statusrequest.none;
  List<cartmodel> data = [];

  Future<void> adminorder() async {
    statusrequest = Statusrequest.loading;
    update();
    var response = await orderdata.orderdetailsdata(order!.ordersId!);
    statusrequest = handling(response);
    if (Statusrequest.success == statusrequest) {
      if (response['status'] == 'success') {
        List orderdata = response["data"];
        data.addAll(orderdata.map((e) => cartmodel.fromJson(e)));
      } else {
        statusrequest = Statusrequest.failure;
      }
    }
    update();
  }

  gototrackingorder() {
    Get.to(() => Trackingorder(), transition: Transition.fadeIn);
  }

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

    adminorder();
    super.onInit();
  }
}
