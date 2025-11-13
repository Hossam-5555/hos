import 'package:hos/core/class/crud.dart';
import 'package:hos/core/conistant/linkApi.dart';

class admindataitem {
  Crud crud;
  admindataitem(this.crud);

  additem(String name, String namear) async {
    var response = await crud.postrequset(LinkApi.adminadditem, {
      "name": name,
      "namear": namear,
    });
    return response.fold((l) => l, (r) => r);
  }

  edititem(String catid, String name, String namear) async {
    var response = await crud.postrequset(LinkApi.adminedititem, {
      "catid": catid,
      "name": name,
      "namear": namear,
    });
    return response.fold((l) => l, (r) => r);
  }

  deleteitem(String catid) async {
    var response = await crud.postrequset(LinkApi.admindeleteitems, {
      "catid": catid,
    });
    return response.fold((l) => l, (r) => r);
  }

  viewitem() async {
    var response = await crud.postrequset(LinkApi.adminviewitem, {});
    return response.fold((l) => l, (r) => r);
  }
}
