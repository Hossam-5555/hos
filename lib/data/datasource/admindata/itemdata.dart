import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:hos/data/services/crud.dart';
import 'package:hos/core/conistant/link_api.dart';

class Admindataitem {
  Crud crud;
  Admindataitem(this.crud);

  additem(Map data,List<File?> files) async {
    var response = await crud.addRequestWithMultipleImages("POST",
      LinkApi.cruditemsadmin,
      data,
      files,
      "items_images[]",
    );
    return response.fold((l) => l, (r) => r);
  }

  edititem(Map data, File? file,int id) async {
    Either<Statusrequest, Map<dynamic, dynamic>> response;
    if (file == null) {
      response = await crud.putandpacth("${LinkApi.cruditemsadmin}/$id", data);
    } else {
      response = await crud.addRequestWithMultipleImages("PATCH",
        LinkApi.cruditemsadmin,
        data,
        [file],
      );
    }
    return response.fold((l) => l, (r) => r);
  }

  deleteitem(int itemid,) async {
    var response = await crud.deleterequwst("${LinkApi.cruditemsadmin}/$itemid",{});
    return response.fold((l) => l, (r) => r);
  }

  viewitem(String categoryId) async {
    var response = await crud.getrequset("${LinkApi.adminviewitem}/$categoryId");
    return response.fold((l) => l, (r) => r);
  }
}
