import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:hos/core/class/crud.dart';
import 'package:hos/core/conistant/linkApi.dart';

class admindataitem {
  Crud crud;
  admindataitem(this.crud);

  additem(Map data, File file) async {
    var response = await crud.addRequestWithImageOne(
      LinkApi.adminadditem,
      data,
      file,
    );
    return response.fold((l) => l, (r) => r);
  }

  edititem(Map data, File? file) async {
    Either<Statusrequest, Map<dynamic, dynamic>> response;
    if (file == null) {
      response = await crud.postrequset(LinkApi.adminedititem, data);
    } else {
      response = await crud.addRequestWithImageOne(
        LinkApi.adminedititem,
        data,
        file,
      );
    }
    return response.fold((l) => l, (r) => r);
  }

  deleteitem(String itemid, String imagename) async {
    var response = await crud.postrequset(LinkApi.admindeleteitems, {
      "itemid": itemid,
      "imagename": imagename,
    });
    return response.fold((l) => l, (r) => r);
  }

  viewitem() async {
    var response = await crud.getrequset(LinkApi.adminviewitem);
    return response.fold((l) => l, (r) => r);
  }
}
