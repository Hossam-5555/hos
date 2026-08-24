import 'package:hos/core/class/crud.dart';
import 'package:hos/core/conistant/linkApi.dart';

class Checkoutdata {
  Crud crud;
  Checkoutdata(this.crud);
  Checkout(Map<String, dynamic> data) async {
    var response = await crud.postrequset(LinkApi.order, data);
    return response.fold((l) => l, (r) => r);
  }

  payment(int orderid) async {
    var response = await crud.postrequset("${LinkApi.payment}/${orderid}",{});
    return response.fold((l) => l, (r) => r);
  }

  Future getPaymentStatus(int orderId) async {
  var response = await crud.getrequset('${LinkApi.payment}$orderId');
  return response.fold((l) => l, (r) => r);
}
}
