import 'package:hos/core/class/crud.dart';
import 'package:hos/core/conistant/linkApi.dart';

class addfavdata {
  Crud crud;
  addfavdata(this.crud);


  favoritemanger(int userid, int itemid) async {
    var response = await crud.postrequset(LinkApi.favoritemanger, {
      "fav_user_id": userid,
      "fav_item_id": itemid,
    });
    return response.fold((l) => l, (r) => r);
  }

  // ignore: strict_top_level_inference
  veiwfav(int userid) async {
    var response = await crud.postrequset(LinkApi.view, {
      "user_id": userid,
    });
    return response.fold((l) => l, (r) => r);
  }

  //deletfrom favorite page
  deletefromfavorite(int favid) async {
    var response = await crud.postrequset(LinkApi.deletefromfavorite, {
      "favid": favid,
    });
    return response.fold((l) => l, (r) => r);
  }
}
