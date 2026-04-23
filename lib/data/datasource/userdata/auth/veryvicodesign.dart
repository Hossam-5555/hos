import 'package:hos/core/class/crud.dart';
import 'package:hos/core/conistant/linkApi.dart';

class VeryfiCodeSignupData {
  Crud crud;
  VeryfiCodeSignupData(this.crud);

  Future<dynamic> postdata(String email, String verifycode) async {
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
