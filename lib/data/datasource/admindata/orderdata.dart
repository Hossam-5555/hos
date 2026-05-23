import 'package:hos/core/class/crud.dart';
import 'package:hos/core/conistant/linkApi.dart';

class AdminDataOrder {
  Crud crud;
  AdminDataOrder(this.crud);

  pendingdata(String status) async {
    // إرسال الـ status لكي يفلتر السيرفر بناءً عليها
    var response = await crud.getrequset(
      "${LinkApi.adminorderpending}?status=$status", // أو حسب إعدادات الرابط عندك
    );
    return response.fold((l) => l, (r) => r);
  }

  changestatus(int orderid,String status) async {
    var response = await crud.putandpacth("${LinkApi.adminorderpending}/$orderid", {
      "status":status
    });
    return response.fold((l) => l, (r) => r);
  }

  

  // //approveorder
  // approveorder(String orderid, String userid) async {
  //   var response = await crud.postrequset(LinkApi.adminaprovedorder, {
  //     "orderid": orderid,
  //     "userid": userid,
  //   });
  //   return response.fold((l) => l, (r) => r);
  // }

  // orderhasdone(String orderid, String userid) async {
  //   var response = await crud.postrequset(LinkApi.prepareorder, {
  //     "orderid": orderid,
  //     "userid": userid,
  //   });
  //   return response.fold((l) => l, (r) => r);
  // }
}
