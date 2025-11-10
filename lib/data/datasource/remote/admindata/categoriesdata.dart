import 'dart:io';
import 'package:hos/core/class/crud.dart';
import 'package:hos/core/conistant/linkApi.dart';

class AdmindaTaCaregores {
  Crud crud;
  AdmindaTaCaregores(this.crud);

  addcat(String name, String namear, File file) async {
    var response = await crud.addRequestWithImageOne(LinkApi.adminaddcat, {
      "name": name,
      "namear": namear,
    }, file);
    return response.fold((l) => l, (r) => r);
  }

  editcat(String catid, String name, String namear) async {
    var response = await crud.postrequset(LinkApi.admineditcat, {
      "catid": catid,
      "name": name,
      "namear": namear,
    });
    return response.fold((l) => l, (r) => r);
  }

  deletecat(String catid) async {
    var response = await crud.postrequset(LinkApi.admindeletecat, {
      "catid": catid,
    });
    return response.fold((l) => l, (r) => r);
  }

  viewcat() async {
    var response = await crud.postrequset(LinkApi.adminviewcat, {});
    return response.fold((l) => l, (r) => r);
  }
}
