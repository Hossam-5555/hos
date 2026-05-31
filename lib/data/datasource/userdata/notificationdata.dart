import 'package:hos/core/class/crud.dart';
import 'package:hos/core/conistant/linkApi.dart';

class Notificationdata {
  Crud crud;
  Notificationdata(this.crud);

  GetNotification() async {
    var response = await crud.postrequset(LinkApi.notification, {});
    return response.fold((l) => l, (r) => r);
  }

  getNotificationsData() async {
    var response = await crud.getrequset(LinkApi.adminnotification);
    return response.fold((l) => l, (r) => r);
  }

  Future removeNotification(List ids) async {
    var response = await crud.postrequset(LinkApi.deletnotification, {
      "massage_id": ids.map((e) => e.toString()).toList(),
    });

    return response.fold((l) => l, (r) => r);
  }
}
