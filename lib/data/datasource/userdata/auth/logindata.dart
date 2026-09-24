import 'package:hos/core/class/crud.dart';
import 'package:hos/core/conistant/link_api.dart';

class LoginData {
  Crud crud;
  LoginData(this.crud);
//لو حصل اي خطأ ف شيل نوع الداله
  Future<dynamic> postdata(String email, String password) async {
    var response = await crud.postrequset(LinkApi.login, {
      "email": email,
      "password": password,
    });
    return response.fold((l) => l, (r) => r);
  }
}
