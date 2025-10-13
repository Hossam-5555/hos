import 'package:hos/core/class/crud.dart';
import 'package:hos/core/conistant/linkApi.dart';

class Checkoutdata {
  Crud crud;
  Checkoutdata(this.crud);
  Checkout(Map<String,dynamic> data) async {
    var response = await crud.postrequset(LinkApi.checkout, data);
    return response.fold((l) => l, (r) => r);
  }
}
