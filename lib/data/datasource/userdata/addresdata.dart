import 'package:hos/core/class/crud.dart';
import 'package:hos/core/conistant/link_api.dart';

class Addresdata {
  Crud crud;
  Addresdata(this.crud);

  // ignore: strict_top_level_inference
  AddAddresdata(
    String name,
    String street,
    String city,
    String lat,
    String long,
    String phone,
  ) async {
    var response = await crud.postrequset(LinkApi.addaddres, {
      "addres_name": name,
      "addres_street": street,
      "addres_city": city,
      "addres_lat": lat,
      "addres_long": long,
      "phone": phone,
    });
    return response.fold((l) => l, (r) => r);
  }

  updateAddresdata(
    String name,
    String street,
    String city,
    String lat,
    String long,
    String phone,
    String id,
  ) async {
    var response = await crud.putandpacth("${LinkApi.addaddres}/$id", {
      "addres_name": name,
      "addres_street": street,
      "addres_city": city,
      "addres_lat": lat,
      "addres_long": long,
      "phone": phone,
    });
    return response.fold((l) => l, (r) => r);
  }

  // ignore: strict_top_level_inference
  viewAddresdata() async {
    var response = await crud.getrequset(LinkApi.addaddres);
    return response.fold((l) => l, (r) => r);
  }

  //deletfrom favorite page
  deleteAddresdata(int addresid) async {
    var response = await crud.postrequset(LinkApi.deleteAddres, {
      "id": addresid,
    });
    return response.fold((l) => l, (r) => r);
  }
  setdefault(int id) async {
    var response = await crud.postrequset(LinkApi.setdafault,{
      "id":id
    });
    return response.fold((l) => l, (r) => r);
  }
}
