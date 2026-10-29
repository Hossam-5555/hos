import 'package:hos/data/services/crud.dart';
import 'package:hos/core/conistant/link_api.dart';

class ResetPassData {
  Crud crud;
  ResetPassData({required this.crud});
  postdata(String email, String password, String repassword) async {
    var response = await crud.postrequset(LinkApi.resetpass, {
      "email": email,
      "password": password,
      "password_confirmation": repassword,
    });
    return response.fold((l) => l, (r) => r);
  }
}
