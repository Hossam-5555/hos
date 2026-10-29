import 'package:hos/data/services/crud.dart';
import 'package:hos/core/conistant/link_api.dart';

class Signupdata {
  Crud crud;
  Signupdata(this.crud);

  postdata(String username, String email, String password) async {
    var response = await crud.postrequset(LinkApi.signup, {
      "name": username,
      "email": email,
      "password": password,
    });
    return response.fold((l) => l, (r) => r);
  }
}
