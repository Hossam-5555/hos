import 'package:hos/core/class/crud.dart';
import 'package:hos/core/conistant/linkApi.dart';

class Addresdata {
  Crud crud;
  Addresdata(this.crud);

  // ignore: strict_top_level_inference
  AddAddresdata(
    String userid,
    String name,
    String street,
    String city,
    String lat,
    String lang,
  ) async {
    var response = await crud.postrequset(LinkApi.AddAddres, {
      "userid": userid,
      "name": name,
      "street": street,
      "city": city,
      "lat": lat,
      "lang": lang,
    });
    return response.fold((l) => l, (r) => r);
  }

  editeAddresdata(
    String addresid,
    String name,
    String street,
    String city,
    double lat,
    double lang,
  ) async {
    var response = await crud.postrequset(LinkApi.editAddres, {
      "addresid": addresid,
      "name": name,
      "street": street,
      "city": city,
      "lat": lat,
      "lang": lang,
    });
    return response.fold((l) => l, (r) => r);
  }

  // ignore: strict_top_level_inference
  viewAddresdata(String userid) async {
    var response = await crud.postrequset(LinkApi.viewAddres, {
      "userid": userid,
    });
    return response.fold((l) => l, (r) => r);
  }

  //deletfrom favorite page
  deleteAddresdata(String addresid) async {
    var response = await crud.postrequset(LinkApi.deleteAddres, {
      "addresid": addresid,
    });
    return response.fold((l) => l, (r) => r);
  }
}
