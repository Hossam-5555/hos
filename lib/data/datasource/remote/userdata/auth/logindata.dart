import 'package:hos/core/class/crud.dart';
import 'package:hos/core/conistant/linkApi.dart';

class logindata {
  Crud crud;
  logindata(this.crud);

  postdata(String email, String password) async {
    var response = await crud.postrequset(LinkApi.login, {
      "email": email,
      "password": password,
    });
    return response.fold((l) => l, (r) => r);
  }
}
