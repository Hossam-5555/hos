import 'package:hos/data/services/crud.dart';
import 'package:hos/core/conistant/link_api.dart';

class AdminDataOrder {
  Crud crud;
  AdminDataOrder(this.crud);

 Future pendingdata(
  String status, {
  int page = 1,
}) async {
  var response = await crud.getrequset(
    "${LinkApi.order}?status=$status&page=$page",
  );

  return response.fold(
    (l) => l,
    (r) => r,
  );
}

 Future changestatus(int orderid,String status) async {
    var response = await crud.putandpacth("${LinkApi.order}/$orderid", {
      "status":status
    });
    return response.fold((l) => l, (r) => r);
  }

  

}
