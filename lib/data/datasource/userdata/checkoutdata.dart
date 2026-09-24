import 'package:dartz/dartz.dart';
import 'package:hos/core/class/crud.dart';
import 'package:hos/core/conistant/link_api.dart';

class Checkoutdata {
  Crud crud;
  Checkoutdata(this.crud);
  Checkout(Map<String, dynamic> data) async {
    var response = await crud.postrequset(LinkApi.order, data);
    return response.fold((l) => l, (r) => r);
  }

  payment(int orderid) async {
    var response = await crud.postrequset("${LinkApi.payment}/$orderid", {});
    return response.fold((l) => l, (r) => r);
  }

 Future<Either<Statusrequest, Map>> getPaymentStatus(int orderId) async {
  return await crud.getrequset('${LinkApi.paymentstatus}/$orderId');
}

  Future cancelOrder(int orderId) async {
    var response = await crud.putandpacth('${LinkApi.order}/$orderId', {
      "status": "cancelled",
    });
    return response.fold((l) => l, (r) => r);
  }
}
