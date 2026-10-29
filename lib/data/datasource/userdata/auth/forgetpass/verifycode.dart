import 'package:hos/data/services/crud.dart';
import 'package:hos/core/conistant/link_api.dart';

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


   Future<dynamic> verfising(String email, String verifycode) async {
    var response = await crud.postrequset(LinkApi.veryfisign, {
      "email": email,
      "code": verifycode,
    });
    return response.fold((l) => l, (r) => r);
  }

  Future<dynamic> resend(String email) async {
    var response = await crud.postrequset(LinkApi.resend, {"email": email});
    return response.fold((l) => l, (r) => r);
  }
}