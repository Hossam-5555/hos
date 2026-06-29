import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:hos/core/class/crud.dart';
import 'package:hos/core/conistant/linkApi.dart';

class AdmindaTaCaregores {
  Crud crud;
  AdmindaTaCaregores(this.crud);

  addcat(String name, String namear, File file) async {
    var response = await crud.addRequestWithMultipleImages(
      "POST",
      LinkApi.admincategrory,
      {"name": name, "name_ar": namear},
      [file],
    );
    return response.fold((l) => l, (r) => r);
  }

  editcat(int catid, String name, String namear, File? file) async {
    Either<Statusrequest, Map<dynamic, dynamic>> response;
    if (file == null) {
      response = await crud.putandpacth("${LinkApi.admincategrory}/$catid", {
        "name": name,
        "name_ar": namear,
      });
    } else {
      response = await crud.addRequestWithMultipleImages(
        "PATCH",
        "${LinkApi.admincategrory}/$catid",
        {"name": name, "name_ar": namear},
        [file],
      );
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
    var response = await crud.getrequset(LinkApi.admincategrory);
    return response.fold((l) => l, (r) => r);
  }
}
