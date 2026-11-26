import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:hos/data/services/crud.dart';
import 'package:hos/core/conistant/link_api.dart';
import 'package:hos/veiw/wedget/Admin/filteradmin.dart';

class Admindataitem {
  Crud crud;
  Admindataitem(this.crud);

  Future additem(Map data, List<File?> files) async {
    var response = await crud.addRequestWithMultipleImages(
      "POST",
      LinkApi.cruditemsadmin,
      data,
      files,
      "items_images[]",
    );
    return response.fold((l) => l, (r) => r);
  }

  Future edititem(Map data, File? file, int id) async {
    Either<Statusrequest, Map<dynamic, dynamic>> response;
    if (file == null) {
      response = await crud.putandpacth("${LinkApi.cruditemsadmin}/$id", data);
    } else {
      response = await crud.addRequestWithMultipleImages(
        "PATCH",
        LinkApi.cruditemsadmin,
        data,
        [file],
      );
    }
    return response.fold((l) => l, (r) => r);
  }

  Future deleteitem(int itemid) async {
    var response = await crud.deleterequwst(
      "${LinkApi.cruditemsadmin}/$itemid",
      {},
    );
    return response.fold((l) => l, (r) => r);
  }

  Future viewitem(
    String categoryId, {
    FilterResult? filter,
    String? search,
    required double minLimit,
    required double maxLimit,
  }) async {
    final Map<String, String> params = {'category_id': categoryId};

    if (search != null && search.trim().isNotEmpty) {
      params['search'] = search.trim();
    }
    if (filter != null) {
      if (filter.brandIds.isNotEmpty) {
        params['brands'] = filter.brandIds.map((id) => id.toString()).join(',');
      }

      if (filter.price.start > minLimit) {
        params['min_price'] = filter.price.start.round().toString();
      }

      if (filter.price.end < maxLimit) {
        params['max_price'] = filter.price.end.round().toString();
      }

      params['sort_by'] = filter.sort;

      if (filter.inStockOnly) {
        params['in_stock'] = '1';
      }
    }

    final uri = Uri(queryParameters: params);
    final response = await crud.getrequset(
      "${LinkApi.getAdminItems}?${uri.query}",
    );
    return response.fold((l) => l, (r) => r);
  }

  Future getbrandsbycategory(int categoryId) async {
    var response = await crud.postrequset(LinkApi.getbrandsbycategory, {
      "category_id": categoryId,
    });
    return response.fold((l) => l, (r) => r);
  }
}
