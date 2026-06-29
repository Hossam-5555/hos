import 'package:hos/core/class/crud.dart';
import 'package:hos/core/conistant/linkApi.dart';

class Orderdata {
  Crud crud;
  Orderdata(this.crud);

  order() async {
    var response = await crud.getrequset(LinkApi.viewmyorder);
    return response.fold((l) => l, (r) => r);
  }



  deletedata(int orderid) async {
    var response = await crud.putandpacth("${LinkApi.order}/$orderid", {
      "status": "cancelled",
    });
    return response.fold((l) => l, (r) => r);
  }

  // ratingdata(String orderid, String rating, String comment) async {
  //   var response = await crud.postrequset(LinkApi.rating, {
  //     "orderid": orderid,
  //     "rating": rating,
  //     "comment": comment,
  //   });
  //   return response.fold((l) => l, (r) => r);
  // }
}
