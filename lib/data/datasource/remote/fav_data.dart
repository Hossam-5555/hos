import 'package:hos/core/class/crud.dart';
import 'package:hos/core/conistant/linkApi.dart';

class addfavdata {
  Crud crud;
  addfavdata(this.crud);

  // ignore: strict_top_level_inference
  removefav(String userid, String itemid) async {
    var response = await crud.postrequset(LinkApi.remove, {
      "userid": userid,
      "itemid": itemid,
    });
    return response.fold((l) => l, (r) => r);
  }

  // ignore: strict_top_level_inference
  addfavorite(String userid, String itemid) async {
    var response = await crud.postrequset(LinkApi.addfav, {
      "userid": userid,
      "itemid": itemid,
    });
    return response.fold((l) => l, (r) => r);
  }

  // ignore: strict_top_level_inference
  veiwfav(String userid) async {
    var response = await crud.postrequset(LinkApi.view, {"userid": userid});
    return response.fold((l) => l, (r) => r);
  }

  //deletfrom favorite page
  deletefromfavorite(String favid) async {
    var response = await crud.postrequset(LinkApi.deletefromfavorite, {
      "favid": favid,
    });
    return response.fold((l) => l, (r) => r);
  }
}
