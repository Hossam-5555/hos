import 'package:hos/core/class/crud.dart';
import 'package:hos/core/conistant/linkApi.dart';

class Cartdata {
  Crud crud;
  Cartdata(this.crud);

  // ignore: strict_top_level_inference
  deletcartdata(int userid, int itemid) async {
    var response = await crud.postrequset(LinkApi.deletcart, {
      "cart_user_id": userid,
      "cart_item_id": itemid,
    });
    return response.fold((l) => l, (r) => r);
  }

  // ignore: strict_top_level_inference
  addcartdata(int userid, int itemid, int count) async {
    var response = await crud.postrequset(LinkApi.addcart, {
      "cart_user_id": userid,
      "cart_item_id": itemid,
      "cart_count": count,
    });
    return response.fold((l) => l, (r) => r);
  }

  // ignore: strict_top_level_inference
  viewcart(int userid) async {
    var response = await crud.getrequset(
      "${LinkApi.viewcart}$userid",
      // {"userid": userid},
    );
    return response.fold((l) => l, (r) => r);
  }



  couponedata(String couponeName) async {
    var response = await crud.postrequset(LinkApi.coupone, {
      "couponeName": couponeName,
    });
    return response.fold((l) => l, (r) => r);
  }
}
