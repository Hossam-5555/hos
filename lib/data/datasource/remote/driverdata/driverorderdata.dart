import 'package:hos/core/class/crud.dart';
import 'package:hos/core/conistant/linkApi.dart';

class Driverorderdata {
  Crud crud;
  Driverorderdata(this.crud);

  pendingdata(String driverid) async {
    var response = await crud.postrequset(LinkApi.driverpendingorder, {
      "driverid": driverid,
    });
    return response.fold((l) => l, (r) => r);
  }

  acceptedorderdata(String driverid) async {
    var response = await crud.postrequset(LinkApi.driveraccebtedorder, {
      "driverid": driverid,
    });
    return response.fold((l) => l, (r) => r);
  }

  orderdetailsdata(String orderid) async {
    var response = await crud.postrequset(LinkApi.driverorderdetails, {
      "orderid": orderid,
    });
    return response.fold((l) => l, (r) => r);
  }

  //approveorder
  approveorder(String orderid, String userid, String driverid) async {
    var response = await crud.postrequset(LinkApi.driverapproveorder, {
      "orderid": orderid,
      "userid": userid,
      "driverid": driverid,
    });
    return response.fold((l) => l, (r) => r);
  }

  orderhasdone(String orderid, String userid) async {
    var response = await crud.postrequset(LinkApi.driverdoneorder, {
      "orderid": orderid,
      "userid": userid,
    });
    return response.fold((l) => l, (r) => r);
  }
}
