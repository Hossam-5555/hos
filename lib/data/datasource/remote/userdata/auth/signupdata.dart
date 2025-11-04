import 'package:hos/core/class/crud.dart';
import 'package:hos/core/conistant/linkApi.dart';

class Signupdata {
  Crud crud;
  Signupdata(this.crud);

  postdata(String username, String email, String password) async {
    var response = await crud.postrequset(LinkApi.Signup, {
      "username": username,
      "email": email,
      "password": password,
    });
    return response.fold((l) => l, (r) => r);
  }
}
