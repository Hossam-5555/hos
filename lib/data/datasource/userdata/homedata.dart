import 'package:hos/core/class/crud.dart';
import 'package:hos/core/conistant/link_api.dart';

class Homedata {
  Crud crud;
  Homedata(this.crud);

  postdata() async {
    var response = await crud.getrequset(
      LinkApi.homepage
    );
    return response.fold((l) => l, (r) => r);
  }

 Future searchdata(String search, {int page = 1}) async {
  var response = await crud.postrequset(
    LinkApi.search,
    {
      'query': search,
      'page': page.toString(),
    },
  );

  return response.fold((l) => l, (r) => r);
}
}
