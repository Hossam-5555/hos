import 'package:hos/core/class/crud.dart';
import 'package:hos/core/conistant/linkApi.dart';

class Cartdata {
  Crud crud;
  Cartdata(this.crud);

  // ignore: strict_top_level_inference
  deletcartdata(String userid, String itemid) async {
    var response = await crud.postrequset(LinkApi.deletcart, {
      "userid": userid,
      "itemid": itemid,
    });
    return response.fold((l) => l, (r) => r);
  }

  // ignore: strict_top_level_inference
  addcartdata(String userid, String itemid, int count) async {
    var response = await crud.postrequset(LinkApi.addcart, {
      "userid": userid,
      "itemid": itemid,
      "count": count.toString(),
    });
    return response.fold((l) => l, (r) => r);
  }

  // ignore: strict_top_level_inference
  viewcart(String userid) async {
    var response = await crud.postrequset(LinkApi.viewcart, {"userid": userid});
    return response.fold((l) => l, (r) => r);
  }

  // ignore: strict_top_level_inference
  getcount(String userid, String itemid) async {
    var response = await crud.postrequset(LinkApi.getcount, {
      "userid": userid,
      'itemid': itemid,
    });
    return response.fold((l) => l, (r) => r);
  }
 
  couponedata(String couponeName)async{
     var response = await crud.postrequset(LinkApi.coupone, {
      "couponeName": couponeName,
    });
    return response.fold((l) => l, (r) => r);
  }


}
