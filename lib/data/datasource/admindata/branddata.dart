// المسار المقترح: lib/data/datasource/admindata/adminbranddata.dart
import 'package:hos/core/class/crud.dart';
import 'package:hos/core/conistant/link_api.dart';

class AdminBrandData {
  final Crud crud;
  AdminBrandData(this.crud);

  // كل القيم Strings عشان الـ http post body بيقبل Strings بس.

  Future getBrands() async {
    var response = await crud.postrequset(LinkApi.viewBrands, {});
    return response.fold((l) => l, (r) => r);
  }

  Future addBrand(String name) async {
    var response = await crud.postrequset(LinkApi.addBrand, {'name': name});
    return response.fold((l) => l, (r) => r);
  }

  Future updateBrand(String id, String name) async {
    var response = await crud.postrequset(LinkApi.updateBrand, {
      'id': id,
      'name': name,
    });
    return response.fold((l) => l, (r) => r);
  }

  Future deleteBrand(String id) async {
    var response = await crud.postrequset(LinkApi.deleteBrand, {'id': id});
    return response.fold((l) => l, (r) => r);
  }
}