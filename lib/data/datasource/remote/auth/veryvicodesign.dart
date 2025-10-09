import 'package:hos/core/class/crud.dart';
import 'package:hos/core/conistant/linkApi.dart';

class veryficodesignupdata {
  Crud crud;
  veryficodesignupdata(this.crud);

  postdata(String email, String verifycode) async {
    var response = await crud.postrequset(LinkApi.veryfisign, {
      "email": email,
      "verifycode": verifycode,
    });
    return response.fold((l) => l, (r) => r);
  }

  resend(String email) async {
    var response = await crud.postrequset(LinkApi.resend, {"email": email});
    return response.fold((l) => l, (r) => r);
  }
}
