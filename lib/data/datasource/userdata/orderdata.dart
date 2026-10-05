import 'package:hos/core/class/crud.dart';
import 'package:hos/core/conistant/link_api.dart';

class Orderdata {
  Crud crud;
  Orderdata(this.crud);

Future order({
  String? status,
  int page = 1,
}) async {
  var response = await crud.getrequset(
    "${LinkApi.viewmyorder}?status=${status ?? 'all'}&page=$page",
  );

  return response.fold(
    (l) => l,
    (r) => r,
  );
}



 Future deletedata(int orderid) async {
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
