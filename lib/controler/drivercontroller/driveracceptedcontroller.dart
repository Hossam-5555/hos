import 'package:get/get.dart';
import 'package:hos/controler/drivercontroller/drivercontroller.dart';
import 'package:hos/core/class/crud.dart';
import 'package:hos/core/functions/handlingdata.dart';
import 'package:hos/data/model/ordersmodel.dart';

class Driveracceptedcontroller extends DriverViewOrderController {
  List<OrderModel> ordersaccepted = [];

  Statusrequest statusrequestaccepted = Statusrequest.none;

  Future<void> viewordersaccepted() async {
    ordersaccepted.clear();
    statusrequestaccepted = Statusrequest.loading;
    update();
    var response = await driverorderdata.acceptedorderdata(
      myservisec.sharedPreferences.getString("id")!,
    );
    statusrequestaccepted = handling(response);
    if (Statusrequest.success == statusrequestaccepted) {
      if (response['status'] == 'success') {
        List data = response["data"];
        ordersaccepted.addAll(data.map((e) => OrderModel.fromJson(e)));
      } else {
        statusrequestaccepted = Statusrequest.failure;
      }
    }
    update();
  }

  Future<void> orderdone(String orderid, String userid) async {
    statusrequestaccepted = Statusrequest.loading;
    update();
    var response = await driverorderdata.orderhasdone(orderid, userid);
    statusrequestaccepted = handling(response);
    if (Statusrequest.success == statusrequestaccepted) {
      if (response['status'] == 'success') {
        viewordersaccepted();
        Get.snackbar("نجاح ", "تم تسليم الطلب بنجاح ");
      } else {
        statusrequestaccepted = Statusrequest.failure;
      }
    }
    update();
  }

  @override
  void onInit() {
    viewordersaccepted();
    super.onInit();
  }
}
