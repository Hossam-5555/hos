import 'package:hos/core/class/crud.dart';
import 'package:hos/core/conistant/linkApi.dart';

class ResetPassData {
  Crud crud;
  ResetPassData({required this.crud});
  postdata(String email, String password) async {
    var response = await crud.postrequset(LinkApi.resetpass, {
      "email": email,
      "password": password,
    });
    return response.fold((l)=>l, (r)=>r);
  }
}
