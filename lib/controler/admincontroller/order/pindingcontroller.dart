import 'package:get/get.dart';
import 'package:hos/controler/admincontroller/order/acceptedorder.dart';
import 'package:hos/core/class/crud.dart';
import 'package:hos/core/functions/handlingdata.dart';
import 'package:hos/data/model/ordersmodel.dart';

class AdminPindingController extends Acceptedordercontroller {
  List<OrderModel> orderspending = [];

  @override
  Statusrequest statusrequest = Statusrequest.none;

  Future<void> vieworderspending() async {
    orderspending.clear();
    statusrequest = Statusrequest.loading;
    update();
    var response = await orderdata.pendingdata();
    statusrequest = handling(response);
    if (Statusrequest.success == statusrequest) {
      if (response['status'] == 'success') {
        List data = response["data"];
        orderspending.addAll(data.map((e) => OrderModel.fromJson(e)));
      } else {
        statusrequest = Statusrequest.failure;
      }
    }
    update();
  }

  Future<void> approvependingorder(String userid, String orderid) async {
    statusrequest = Statusrequest.loading;
    update();
    var response = await orderdata.approveorder(orderid, userid);
    statusrequest = handling(response);
    if (Statusrequest.success == statusrequest) {
      if (response['status'] == 'success') {
        vieworderspending();
        Get.snackbar("succee ", " تم قبول الطلب");
      } else {
        Get.snackbar("حدث خطا ", " الرجاء  اعاده المحاوله  ");

        vieworderspending();
      }
    }
    update();
  }

  @override
  void onInit() {
    vieworderspending();
    super.onInit();
  }
}
