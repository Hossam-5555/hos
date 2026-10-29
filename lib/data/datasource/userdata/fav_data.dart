import 'package:hos/data/services/crud.dart';
import 'package:hos/core/conistant/link_api.dart';

class addfavdata {
  Crud crud;
  addfavdata(this.crud);


  favoritemanger( int itemid) async {
    var response = await crud.postrequset(LinkApi.favoritemanger, {
      "fav_item_id": itemid,
    });
    return response.fold((l) => l, (r) => r);
  }

  // ignore: strict_top_level_inference
  veiwfav() async {
    var response = await crud.postrequset(LinkApi.view, {
    });
    return response.fold((l) => l, (r) => r);
  }


}
