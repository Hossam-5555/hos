import 'package:hos/core/class/crud.dart';
import 'package:hos/core/conistant/linkApi.dart';

class Offerdata {
  Crud crud;
  Offerdata(this.crud);

  getdata() async {
    var response = await crud.postrequset(LinkApi.offer, {});
    return response.fold((l) => l, (r) => r);
  }
}
