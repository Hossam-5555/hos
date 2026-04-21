import 'package:hos/core/class/crud.dart';
import 'package:hos/core/conistant/linkApi.dart';

class Orderdata {
  Crud crud;
  Orderdata(this.crud);

  order(int userid) async {
    var response = await crud.getrequset("${LinkApi.viewmyorder}$userid");
    return response.fold((l) => l, (r) => r);
  }

  orderdetailsdata(int orderid) async {
    var response = await crud.postrequset(LinkApi.orderdetails, {
      "orderid": orderid,
    });
    return response.fold((l) => l, (r) => r);
  }

  deletedata(String orderid) async {
    var response = await crud.postrequset(LinkApi.deleteorder, {
      "orderid": orderid,
    });
    return response.fold((l) => l, (r) => r);
  }

  ratingdata(String orderid, String rating, String comment) async {
    var response = await crud.postrequset(LinkApi.rating, {
      "orderid": orderid,
      "rating": rating,
      "comment": comment,
    });
    return response.fold((l) => l, (r) => r);
  }
}
