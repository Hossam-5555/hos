import 'package:hos/core/class/crud.dart';
import 'package:hos/core/conistant/linkApi.dart';

class AdminDataOrder {
  Crud crud;
  AdminDataOrder(this.crud);

  pendingdata() async {
    var response = await crud.getrequset(LinkApi.adminorderpending);
    return response.fold((l) => l, (r) => r);
  }

  acceptedorderdata() async {
    var response = await crud.postrequset(LinkApi.adminorderaccepted, {});
    return response.fold((l) => l, (r) => r);
  }

  orderdetailsdata(String orderid) async {
    var response = await crud.postrequset(LinkApi.adminorderdetails, {
      "orderid": orderid,
    });
    return response.fold((l) => l, (r) => r);
  }

  //approveorder
  approveorder(String orderid, String userid) async {
    var response = await crud.postrequset(LinkApi.adminaprovedorder, {
      "orderid": orderid,
      "userid": userid,
    });
    return response.fold((l) => l, (r) => r);
  }

  orderhasdone(String orderid, String userid) async {
    var response = await crud.postrequset(LinkApi.prepareorder, {
      "orderid": orderid,
      "userid": userid,
    });
    return response.fold((l) => l, (r) => r);
  }
}
