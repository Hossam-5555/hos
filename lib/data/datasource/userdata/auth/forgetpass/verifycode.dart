import 'package:hos/core/class/crud.dart';
import 'package:hos/core/conistant/linkApi.dart';

class VerifyCodeForgetpassdata {
  Crud crud;
  VerifyCodeForgetpassdata( {required this.crud});
  postdata(String email, String verifycode) async {
    var response = await crud.postrequset(LinkApi.veryfycodeforgetpass, {
      "email": email,
      "code": verifycode,
    });
    return response.fold((l)=>l, (r)=>r);
  }
}