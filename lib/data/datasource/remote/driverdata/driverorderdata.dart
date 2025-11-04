import 'package:hos/core/class/crud.dart';
import 'package:hos/core/conistant/linkApi.dart';

class Driverorderdata {
  Crud crud;
  Driverorderdata(this.crud);

  pendingdata(String userid) async {
    var response = await crud.postrequset(LinkApi.viewmyorder, {
      "userid": userid,
    });
    return response.fold((l) => l, (r) => r);
  }

  orderdetailsdata(String orderid) async {
    var response = await crud.postrequset(LinkApi.orderdetails, {
      "orderid": orderid,
    });
    return response.fold((l) => l, (r) => r);
  }

  acceptedorderdata(String orderid, String rating, String comment) async {
    var response = await crud.postrequset(LinkApi.rating, {
      "orderid": orderid,
      "rating": rating,
      "comment": comment,
    });
    return response.fold((l) => l, (r) => r);
  }
}
