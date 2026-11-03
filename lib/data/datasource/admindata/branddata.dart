// المسار المقترح: lib/data/datasource/admindata/adminbranddata.dart
import 'package:hos/core/conistant/link_api.dart';
import 'package:hos/data/services/crud.dart';

class AdminBrandData {
  final Crud crud;
  AdminBrandData(this.crud);

  // كل القيم Strings عشان الـ http post body بيقبل Strings بس.

  Future getBrands() async {
    var response = await crud.postrequset(LinkApi.viewBrands, {});
    return response.fold((l) => l, (r) => r);
  }

  /// الأقسام المتاحة للاختيار في فورم البراند
  Future getCategories() async {
    var response = await crud.postrequset(LinkApi.brandCategories, {});
    return response.fold((l) => l, (r) => r);
  }

  /// category_ids بتتبعت كنص مفصول بفواصل: "1,2,3"
  Future addBrand(String name, List<int> categoryIds) async {
    var response = await crud.postrequset(LinkApi.addBrand, {
      'name': name,
      'category_ids': categoryIds.join(','),
    });
    return response.fold((l) => l, (r) => r);
  }

  Future updateBrand(String id, String name, List<int> categoryIds) async {
    var response = await crud.postrequset(LinkApi.updateBrand, {
      'id': id,
      'name': name,
      'category_ids': categoryIds.join(','),
    });
    return response.fold((l) => l, (r) => r);
  }

  Future deleteBrand(String id) async {
    var response = await crud.postrequset(LinkApi.deleteBrand, {'id': id});
    return response.fold((l) => l, (r) => r);
  }
}
