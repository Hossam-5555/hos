import 'package:hos/core/class/crud.dart';
import 'package:hos/core/conistant/linkApi.dart';

class Notificationdata {
  Crud crud;
  Notificationdata(this.crud);

  GetNotification(String userid) async {
    var response = await crud.postrequset(LinkApi.notification, {
      "userid": userid,
    });
    return response.fold((l) => l, (r) => r);
  }

  Future<Object> removeNotification(List notificationid) async {
    // بنحول كل عنصر في اللستة لـ String لأن http package
    // بتتوقع الـ Map values تكون Strings في الـ Body
    Map<String, String> data = {};

    for (int i = 0; i < notificationid.length; i++) {
      data["notificationid[$i]"] = notificationid[i].toString();
    }

    var response = await crud.postrequset(LinkApi.deletnotification, data);
    return response.fold((l) => l, (r) => r);
  }
}
