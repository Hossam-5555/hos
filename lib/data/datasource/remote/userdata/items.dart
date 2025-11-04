import 'package:hos/core/class/crud.dart';
import 'package:hos/core/conistant/linkApi.dart';
class itemsdata {
  Crud crud;
  itemsdata(this.crud);

  postdata(String id,String userid) async {
    var response = await crud.postrequset(LinkApi.items, {
      "id":id,
      "userid":userid
    });
    return response.fold((l) => l, (r) => r);
  }
}