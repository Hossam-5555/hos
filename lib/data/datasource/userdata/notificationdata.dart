import 'package:hos/data/services/crud.dart';
import 'package:hos/core/conistant/link_api.dart';

class Notificationdata {
  Crud crud;
  Notificationdata(this.crud);

  Future getnotification() async {
    var response = await crud.getrequset(LinkApi.notification);
    return response.fold((l) => l, (r) => r);
  }

  Future getNotificationsData() async {
    var response = await crud.getrequset("${LinkApi.notification}/${22}");
    return response.fold((l) => l, (r) => r);
  }

  Future removeNotification(List ids) async {
    var response = await crud.postrequset(LinkApi.deletnotification, {
      "massage_id": ids.map((e) => e.toString()).toList(),
    });

    return response.fold((l) => l, (r) => r);
  }

  Future markasread(int id) async {
    var response = await crud.putandpacth("${LinkApi.notification}/$id",{});
    return response.fold((l) => l, (r) => r);
  }
}
