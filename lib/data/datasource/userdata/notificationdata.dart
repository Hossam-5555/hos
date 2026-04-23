import 'package:hos/core/class/crud.dart';
import 'package:hos/core/conistant/linkApi.dart';

class Notificationdata {
  Crud crud;
  Notificationdata(this.crud);

  GetNotification(int userid) async {
    var response = await crud.postrequset(LinkApi.notification, {
      "user_id": userid,
    });
    return response.fold((l) => l, (r) => r);
  }

  Future removeNotification(List ids,int userid) async {
  var response = await crud.postrequset(
    LinkApi.deletnotification,
    {
      "user_id": userid, // أو من SharedPreferences
      "massage_id": ids.map((e) => e.toString()).toList(),
    },
  );

  return response.fold((l) => l, (r) => r);
}
}
