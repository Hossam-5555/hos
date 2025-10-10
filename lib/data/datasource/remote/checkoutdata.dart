import 'package:hos/core/class/crud.dart';
import 'package:hos/core/conistant/linkApi.dart';

class Checkoutdata {
  Crud crud;
  Checkoutdata(this.crud);
  Checkout(Map data) async {
    var response = await crud.postrequset(LinkApi.addorder, data);
    return response.fold((l) => l, (r) => r);
  }
}
