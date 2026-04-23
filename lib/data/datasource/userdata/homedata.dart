import 'package:hos/core/class/crud.dart';
import 'package:hos/core/conistant/linkApi.dart';

class Homedata {
  Crud crud;
  Homedata(this.crud);

  postdata() async {
    var response = await crud.getrequset(
      // LinkApi.homepage
      "http://10.0.2.2:8000/api/category",
    );
    return response.fold((l) => l, (r) => r);
  }

  searchdata(String search,int id) async {
    var response = await crud.postrequset(LinkApi.search, {
      'query': search,
      "user_id": id,
    });
    return response.fold((l) => l, (r) => r);
  }
}
