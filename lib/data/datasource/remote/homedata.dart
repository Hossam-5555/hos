import 'package:hos/core/class/crud.dart';
import 'package:hos/core/conistant/linkApi.dart';

class Homedata {
  Crud crud;
  Homedata(this.crud);

  postdata() async {
    var response = await crud.postrequset(LinkApi.homepage, {});
    return response.fold((l) => l, (r) => r);
  }

  searchdata(String search) async {
    var response = await crud.postrequset(LinkApi.search, {'search': search});
    return response.fold((l) => l, (r) => r);
  }
}
