import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:hos/core/class/crud.dart';
import 'package:hos/core/conistant/linkApi.dart';

class AdmindaTaCaregores {
  Crud crud;
  AdmindaTaCaregores(this.crud);

  addcat(String name, String namear, File file) async {
    var response = await crud.addRequestWithImageOne(LinkApi.adminaddcat, {
      "name": name,
      "name_ar": namear,
    }, file);
    return response.fold((l) => l, (r) => r);
  }

  editcat(
    String catid,
    String name,
    String namear,
    String oldimage,
    File? file,
  ) async {
    Either<Statusrequest, Map<dynamic, dynamic>> response;
    if (file == null) {
      response = await crud.postrequset(LinkApi.admineditcat, {
        "catid": catid,
        "name": name,
        "namear": namear,
        "oldimage": oldimage,
      });
    } else {
      response = await crud.addRequestWithImageOne(LinkApi.admineditcat, {
        "catid": catid,
        "name": name,
        "namear": namear,
        "oldimage": oldimage,
      }, file);
    }
    return response.fold((l) => l, (r) => r);
  }

  deletecat(int catid) async {
    var response = await crud.postrequset(LinkApi.admindeletecat, {
      "id": catid,
    });
    return response.fold((l) => l, (r) => r);
  }

  viewcat() async {
    var response = await crud.getrequset(LinkApi.adminviewcat);
    return response.fold((l) => l, (r) => r);
  }
}
