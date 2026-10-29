import 'package:hos/data/services/crud.dart';
import 'package:hos/core/conistant/link_api.dart';

class Checkemaildata {
  Crud crud;
  Checkemaildata(this.crud);

  postdata(String email) async {
    var response = await crud.postrequset(LinkApi.checkemail, {"email": email});
    return response.fold((l) => l, (r) => r);
  }
}
