import 'package:hos/core/class/crud.dart';
import 'package:hos/core/conistant/linkApi.dart';

class Orderdata {
  Crud crud;
  Orderdata(this.crud);

  order(String userid) async {
    var response = await crud.postrequset(LinkApi.viewmyorder, {"userid": userid});
    return response.fold((l) => l, (r) => r);
  }
}
