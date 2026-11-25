import 'package:hos/core/conistant/link_api.dart';
import 'package:hos/data/services/crud.dart';

class Deleteacountdata {
  Crud crud;
  Deleteacountdata(this.crud);
  Future<dynamic> postdata() async {
    var response = await crud.deleterequwst(LinkApi.deleteaccont,{});
    return response.fold((l) => l, (r) => r);
  }
}
